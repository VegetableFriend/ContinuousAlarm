//
//  VFContinuousAlarmSettingsViewController.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VFContinuousAlarmSettingsViewController;

@protocol VFContinuousAlarmSettingsDelegate <NSObject>

- (void)addAlarm:(AlarmModel *)model settingsViewController:(VFContinuousAlarmSettingsViewController *)settingsViewController;

@end

@interface VFContinuousAlarmSettingsViewController : UIViewController

@property (nonatomic, weak) id<VFContinuousAlarmSettingsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
