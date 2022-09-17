//
//  VFContinuousAlarmSettingsViewController.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import "VFContinuousAlarmSettingsViewController.h"
#import "VFCAToast.h"

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
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Wake up!";
    content.body = @"Wake up BRO!";
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @1;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
        
    NSString *identifier = @"noticeId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
         
    [center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        [VFCAToast showToastWithTips:@"Add alarm successfully" completion:nil];
    }];
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
