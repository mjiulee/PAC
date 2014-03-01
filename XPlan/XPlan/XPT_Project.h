//
//  XPT_Project.h
//  XPlan
//
//  Created by mjlee on 14-2-24.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XPT_Task;

@interface XPT_Project : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * project_name;
@property (nonatomic, retain) NSSet *subTasks;
@end

@interface XPT_Project (CoreDataGeneratedAccessors)

- (void)addSubTasksObject:(XPT_Task *)value;
- (void)removeSubTasksObject:(XPT_Task *)value;
- (void)addSubTasks:(NSSet *)values;
- (void)removeSubTasks:(NSSet *)values;

@end
