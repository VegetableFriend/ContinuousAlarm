//
//  VFCANotificationManager.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^VFCAVFCANotificationOperationResultBlock)(BOOL result);

@interface VFCANotificationManager : NSObject

+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier completion:(nullable VFCAVFCANotificationOperationResultBlock)completion;

+ (void)removeLocalNoticaitonWithIdentifier:(NSString *)identifier completion:(nullable VFCAVFCANotificationOperationResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
