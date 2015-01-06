//
//  ProjectModel.h
//  XPlan
//
//  Created by mjlee on 15/1/6.
//  Copyright (c) 2015年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskModel;

@interface ProjectModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface ProjectModel (CoreDataGeneratedAccessors)

- (void)addTasksObject:(TaskModel *)value;
- (void)removeTasksObject:(TaskModel *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
