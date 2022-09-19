//
//  VFContinuousAlarmModelDAO.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/18/22.
//

#import "VFContinuousAlarmModelDAO.h"
#import "VFCACoreDataManager.h"

@implementation VFContinuousAlarmModelDAO

+ (void)saveAlarmModel:(AlarmModel *)model {
    NSError *error = nil;
    [[VFCACoreDataManager sharedInstance].container.viewContext save:&error];
}

+ (NSArray<AlarmModel *> *)fetchAllAlarmModels {
    NSFetchRequest *request = [AlarmModel fetchRequest];
    
    NSError *error = nil;
    return [[VFCACoreDataManager sharedInstance].container.viewContext executeFetchRequest:request error:&error];
}

+ (void)deleteAlarmModel:(AlarmModel *)model {
    [[VFCACoreDataManager sharedInstance].container.viewContext deleteObject:model];
    
    NSError *error = nil;
    [[VFCACoreDataManager sharedInstance].container.viewContext save:&error];
}

@end
