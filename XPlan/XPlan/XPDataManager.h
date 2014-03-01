//
//  XPDataManager.h
//  XPlan
//
//  Created by mjlee on 14-2-22.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModel.h"

#define IfCoreDataDebug 1

//#define XPT_Project_SqlTable @"XPT_Project"
//#define XPT_Task_SqlTable    @"XPT_Task"
//#define XPT_Test_SqlTable    @"TestModel"

@interface XPDataManager : NSObject
{
}

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - test
-(BOOL)insertTest:(NSString*)title date:(NSDate*)adate;
-(BOOL)queryTest:(int)page size:(int)asize;

//#pragma mark - Task-List
///*
// * 任务表的增删改查
// */
//-(BOOL)insertTask:(XPT_Task*)task;
//-(void)updateTask:(XPT_Task*)task;
//-(void)deleteTask:(NSNumber*)taskId;
//-(NSArray*)selectTaskByDay:(NSDate*)day;
//
//#pragma mark - Project-List
///*
// * 项目表的增删改查
// */
//-(void)insertProject:(XPT_Project*)project;
//-(void)updateProject:(XPT_Project*)project;
//-(void)deleteProject:(NSNumber*)pId;

// others:
//-(NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//-(void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook;
//-(void)deleteData;

@end

