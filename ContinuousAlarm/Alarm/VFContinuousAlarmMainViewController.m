//
//  VFCAAlarmSettingsViewController.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import "VFContinuousAlarmMainViewController.h"
#import "VFContinuousAlarmSettingsViewController.h"

@import Masonry;
@import UserNotifications;

@interface VFContinuousAlarmMainViewController ()

@property (nonatomic, strong) UIButton *addAlarmButton;

@end

@implementation VFContinuousAlarmMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self layoutSubviews];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addAlarmButton];
}

- (void)layoutSubviews {
    [self.addAlarmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)showAlarmSettingsViewController:(id)sender {
    VFContinuousAlarmSettingsViewController *settingsViewController = [[VFContinuousAlarmSettingsViewController alloc] init];
    settingsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self.navigationController presentViewController:settingsViewController
                                            animated:NO
                                          completion:nil];
}

#pragma mark - Getter
- (UIButton *)addAlarmButton {
    if (!_addAlarmButton) {
        _addAlarmButton = [[UIButton alloc] init];
        [_addAlarmButton addTarget:self
                            action:@selector(showAlarmSettingsViewController:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_addAlarmButton setTitle:@"start!" forState:UIControlStateNormal];
        [_addAlarmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addAlarmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _addAlarmButton.layer.cornerRadius = 5;
        _addAlarmButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _addAlarmButton.layer.borderWidth = 1;
        _addAlarmButton.contentEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    }
    
    return _addAlarmButton;
}

@end
