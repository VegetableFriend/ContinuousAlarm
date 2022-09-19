//
//  AlarmModel+CoreDataProperties.h
//  
//
//  Created by HaopengLi on 9/18/22.
//
//

#import "AlarmModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmModel (CoreDataProperties)

+ (NSFetchRequest<AlarmModel *> *)fetchRequest;

@property (nonatomic) int64_t aid;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSDate *time;

@end

NS_ASSUME_NONNULL_END
