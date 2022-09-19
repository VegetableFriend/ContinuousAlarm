//
//  AlarmModel+CoreDataProperties.m
//  
//
//  Created by HaopengLi on 9/18/22.
//
//

#import "AlarmModel+CoreDataProperties.h"

@implementation AlarmModel (CoreDataProperties)

+ (NSFetchRequest<AlarmModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Alarm"];
}

@dynamic aid;
@dynamic identifier;
@dynamic time;

@end
