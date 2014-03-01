//
//  XPT_Task.h
//  XPlan
//
//  Created by mjlee on 14-2-24.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class XPT_Project;

@interface XPT_Task : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * done_date;
@property (nonatomic, retain) NSNumber * ifdone;
@property (nonatomic, retain) NSDate * notify_time;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * taskcontent;
@property (nonatomic, retain) NSDate * update_date;
@property (nonatomic, retain) XPT_Project *inproject;

@end
