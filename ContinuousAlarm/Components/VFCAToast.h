//
//  VFCAToast.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFCAToast : UIView

+ (void)showToastWithTips:(NSString *)tips completion:(dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
