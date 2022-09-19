//
//  VFCACoreDataManager.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/18/22.
//

#import "VFCACoreDataManager.h"

static VFCACoreDataManager *_instance = nil;

@implementation VFCACoreDataManager

+ (VFCACoreDataManager *)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[VFCACoreDataManager alloc] init];
        });
    }
    
    return _instance;
}

- (void)createPersistContainer {
    NSPersistentContainer *container = [[NSPersistentContainer alloc] initWithName:@"VFContinuousAlarmModel"];
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description,
                                                           NSError *error) {
        if (!error) {
            self.container = container;
        }
    }];
}

@end
