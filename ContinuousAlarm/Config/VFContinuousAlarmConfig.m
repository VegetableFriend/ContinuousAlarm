//
//  VFContinuousAlarmConfig.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/20/22.
//

#import "VFContinuousAlarmConfig.h"

static NSString *const kVFCACurrentAlarmCountKey = @"VFCACurrentAlarmCountKey";

@implementation VFContinuousAlarmConfig

+ (void)increaseCurrentAlarmCount {
    NSUInteger currentAlarmCount = [self currentAlarmCount];
    currentAlarmCount += 1;
    
    [[self userDefaults] setInteger:currentAlarmCount forKey:kVFCACurrentAlarmCountKey];
}

+ (NSUInteger)currentAlarmCount {
    return [[self userDefaults] integerForKey:kVFCACurrentAlarmCountKey];
}

+ (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end
