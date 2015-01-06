//
//  TaskModel.h
//  XPlan
//
//  Created by mjlee on 15/1/6.
//  Copyright (c) 2015年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectModel;

@interface TaskModel : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateCreate;
@property (nonatomic, retain) NSDate * dateDone;
@property (nonatomic, retain) NSNumber * neednotify;
@property (nonatomic, retain) NSDate * notifydate;
@property (nonatomic, retain) NSString * notifyname;
@property (nonatomic, retain) NSNumber * prLevel;
@property (nonatomic, retain) NSString * sectionIdDaily;
@property (nonatomic, retain) NSString * sectionIdMonthly;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) ProjectModel *project;

@end
