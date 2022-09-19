//
//  VFCAAlarmSettingsViewController.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import "AlarmModel+CoreDataClass.h"
#import "VFContinuousAlarmModelDAO.h"
#import "VFCANotificationManager.h"
#import "VFContinuousAlarmTableViewCell.h"
#import "VFContinuousAlarmMainViewController.h"
#import "VFContinuousAlarmSettingsViewController.h"

@import Masonry;
@import UserNotifications;

@interface VFContinuousAlarmMainViewController () <UITableViewDelegate, UITableViewDataSource, VFContinuousAlarmSettingsDelegate>

@property (nonatomic, copy) NSArray<AlarmModel *> *alarmModels;

@property (nonatomic, strong) UIButton *addAlarmButton;

@property (nonatomic, strong) UITableView *alarmListTableView;

@end

@implementation VFContinuousAlarmMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self layoutSubviews];
    [self updateData];
}

- (void)updateData {
    NSArray<AlarmModel *> *models = [VFContinuousAlarmModelDAO fetchAllAlarmModels];
    self.alarmModels = models;
    [self.alarmListTableView reloadData];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addAlarmButton];
    [self.view addSubview:self.alarmListTableView];
}

- (void)layoutSubviews {
    [self.addAlarmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    
    [self.alarmListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
    }];
}

- (void)showAlarmSettingsViewController:(id)sender {
    VFContinuousAlarmSettingsViewController *settingsViewController = [[VFContinuousAlarmSettingsViewController alloc] init];
    settingsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    settingsViewController.delegate = self;
    
    [self.navigationController presentViewController:settingsViewController
                                            animated:NO
                                          completion:nil];
}

#pragma mark - VFContinuousAlarmSettingsDelegate
- (void)addAlarm:(AlarmModel *)model settingsViewController:(VFContinuousAlarmSettingsViewController *)settingsViewController {
    [self updateData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < self.alarmModels.count) {
            AlarmModel *model = self.alarmModels[indexPath.row];
            [VFContinuousAlarmModelDAO deleteAlarmModel:model];
            [VFCANotificationManager removeLocalNoticaitonWithIdentifier:model.identifier completion:nil];
            [self updateData];
        }
    }
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VFContinuousAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VFContinuousAlarmTableViewCell class])];
    if (indexPath.row < self.alarmModels.count) {
        cell.model = self.alarmModels[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarmModels.count;
}

#pragma mark - Getter
- (UIButton *)addAlarmButton {
    if (!_addAlarmButton) {
        _addAlarmButton = [[UIButton alloc] init];
        [_addAlarmButton addTarget:self
                            action:@selector(showAlarmSettingsViewController:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_addAlarmButton setTitle:@"Add alarm" forState:UIControlStateNormal];
        [_addAlarmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addAlarmButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _addAlarmButton.layer.cornerRadius = 5;
        _addAlarmButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _addAlarmButton.layer.borderWidth = 1;
        _addAlarmButton.contentEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    }
    
    return _addAlarmButton;
}

- (UITableView *)alarmListTableView {
    if (!_alarmListTableView) {
        _alarmListTableView = [[UITableView alloc] init];
        _alarmListTableView.delegate = self;
        _alarmListTableView.dataSource = self;
        [_alarmListTableView registerClass:[VFContinuousAlarmTableViewCell class]
                    forCellReuseIdentifier:NSStringFromClass([VFContinuousAlarmTableViewCell class])];
    }
    
    return _alarmListTableView;
}


@end
