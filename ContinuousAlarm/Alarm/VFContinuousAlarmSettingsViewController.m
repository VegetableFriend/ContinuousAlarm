//
//  VFContinuousAlarmSettingsViewController.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import "VFCAToast.h"
#import "AlarmModel+CoreDataClass.h"
#import "VFCANotificationManager.h"
#import "VFCACoreDataManager.h"
#import "VFContinuousAlarmSettingsViewController.h"
#import "VFContinuousAlarmModelDAO.h"
#import "VFContinuousAlarmConfig.h"

@import UserNotifications;
@import Masonry;

/// Settings panel height
static const CGFloat kVFCAAlarmSettingsPanelHeight = 350;

@interface VFContinuousAlarmSettingsViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *settingsPanel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation VFContinuousAlarmSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self layoutViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startPanelAnimation:YES];
}

- (void)setupViews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.settingsPanel];
    
    [self.settingsPanel addSubview:self.titleLabel];
    [self.settingsPanel addSubview:self.closeButton];
    [self.settingsPanel addSubview:self.datePicker];
    [self.settingsPanel addSubview:self.submitButton];
}

- (void)layoutViews {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.settingsPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(kVFCAAlarmSettingsPanelHeight));
        make.bottom.equalTo(self.view).offset(kVFCAAlarmSettingsPanelHeight);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingsPanel).offset(20);
        make.right.equalTo(self.settingsPanel).offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingsPanel).offset(20);
        make.centerX.equalTo(self.settingsPanel);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.left.equalTo(self.settingsPanel).offset(20);
        make.right.equalTo(self.settingsPanel).offset(-20);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.settingsPanel);
        make.bottom.equalTo(self.settingsPanel).offset(-20);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)startPanelAnimation:(BOOL)show {
    CGFloat bottomMargin = show ? -20 : kVFCAAlarmSettingsPanelHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.settingsPanel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(bottomMargin);
        }];
        self.backgroundView.alpha = 0.7;
        
        // Referesh frame to trigger animation
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissCurrentViewController:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)submitAlarm:(id)sender {
    NSDate *pickedDate = self.datePicker.date;
    if (pickedDate < [NSDate date]) {
        [VFCAToast showToastWithTips:@"Picked time must larger than current time!" completion:nil];
    } else {
        UNAuthorizationOptions options =
        UNAuthorizationOptionSound |
        UNAuthorizationOptionAlert |
        UNAuthorizationOptionBadge;
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
                [self addAlarmIntoSystem];
            }
        }];
    }
}

- (void)addAlarmIntoSystem {
    [VFCANotificationManager addLocalNotificationWithIdentifier:[self alarmPushIdentifier] completion:^(BOOL success) {
        if (success) {
            [VFCAToast showToastWithTips:@"Add alarm successfully" completion:nil];
            [self saveAlarmModelIntoLocal];
        } else {
            [VFCAToast showToastWithTips:@"Add alarm failed" completion:nil];
        }
    }];
}

- (void)saveAlarmModelIntoLocal {
    AlarmModel *model = [[AlarmModel alloc] initWithContext:[VFCACoreDataManager sharedInstance].container.viewContext];
    model.identifier = [self alarmPushIdentifier];
    model.time = self.datePicker.date;
    model.aid = [VFContinuousAlarmConfig currentAlarmCount];
    
    [VFContinuousAlarmModelDAO saveAlarmModel:model];
    [VFContinuousAlarmConfig increaseCurrentAlarmCount];
    [self.delegate addAlarm:model settingsViewController:self];
}

- (NSString *)alarmPushIdentifier {
    NSString *dateString = self.datePicker.date.description;
    NSUInteger currentAlarmCount = [VFContinuousAlarmConfig currentAlarmCount];
    
    return [NSString stringWithFormat:@"%@_%@", @(currentAlarmCount).stringValue, dateString];
}

#pragma mark - accessor
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentViewController:)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    return _backgroundView;
}

- (UIView *)settingsPanel {
    if (!_settingsPanel) {
        _settingsPanel = [[UIView alloc] init];
        _settingsPanel.backgroundColor = [UIColor whiteColor];
        _settingsPanel.layer.cornerRadius = 20;
    }
    
    return _settingsPanel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Choose a time";
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeClose];
        [_closeButton addTarget:self
                         action:@selector(dismissCurrentViewController:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
    
    return _datePicker;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _submitButton.layer.borderWidth = 1;
        _submitButton.contentEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        [_submitButton setTitle:@"submit" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self
                          action:@selector(submitAlarm:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

@end
