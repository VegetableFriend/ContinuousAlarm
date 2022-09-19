//
//  VFCANotificationManager.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/20/22.
//

#import "VFCANotificationManager.h"

@import UserNotifications;

@implementation VFCANotificationManager

+ (void)addLocalNotificationWithIdentifier:(NSString *)identifier completion:(nullable VFCAVFCANotificationOperationResultBlock)completion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Wake up!";
    content.body = @"Wake up BRO!";
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @1;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
         
    [center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        if (!error) {
            [self wrapMainThreadCallCompletion:completion arg:YES];
        } else {
            [self wrapMainThreadCallCompletion:completion arg:NO];
        }
    
    }];
}

+ (void)removeLocalNoticaitonWithIdentifier:(NSString *)identifier completion:(nullable VFCAVFCANotificationOperationResultBlock)completion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    if (completion) {
        [self wrapMainThreadCallCompletion:completion arg:YES];
    }
}

+ (void)wrapMainThreadCallCompletion:(nullable VFCAVFCANotificationOperationResultBlock)completion arg:(BOOL)arg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(arg);
        }
    });
}

@end
