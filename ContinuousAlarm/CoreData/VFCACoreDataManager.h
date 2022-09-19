//
//  VFCACoreDataManager.h
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/18/22.
//

#import <Foundation/Foundation.h>

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface VFCACoreDataManager : NSObject

@property (nonatomic, strong) NSPersistentContainer *container;

+ (VFCACoreDataManager *)sharedInstance;

- (void)createPersistContainer;

@end

NS_ASSUME_NONNULL_END
