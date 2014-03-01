//
//  TaskModel.h
//  XPlan
//
//  Created by mjlee on 14-3-1.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectModel;

@interface TaskModel : NSManagedObject
{
//    NSString * brief;
//    NSDate * create_date;
//    NSNumber * status;
//    NSDate * finish_date;
//    ProjectModel *project;
}
@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * finish_date;
@property (nonatomic, retain) ProjectModel *project;

@end
