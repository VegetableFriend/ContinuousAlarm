//
//  VFContinuousAlarmModelDAO.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/18/22.
//

#import <Foundation/Foundation.h>
#import "AlarmModel+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface VFContinuousAlarmModelDAO : NSObject

+ (void)saveAlarmModel:(AlarmModel *)model;

+ (NSArray<AlarmModel *> *)fetchAllAlarmModels;

+ (void)deleteAlarmModel:(AlarmModel *)model;

@end

NS_ASSUME_NONNULL_END
