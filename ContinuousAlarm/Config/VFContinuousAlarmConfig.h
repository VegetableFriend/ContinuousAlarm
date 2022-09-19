//
//  VFContinuousAlarmConfig.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFContinuousAlarmConfig : NSObject

+ (void)increaseCurrentAlarmCount;

+ (NSUInteger)currentAlarmCount;

@end

NS_ASSUME_NONNULL_END
