//
//  XPDataManager.h
//  XPlan
//
//  Created by mjlee on 14-2-22.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModel.h"
#import "TaskModel.h"
#import "ProjectModel.h"


#define IfCoreDataDebug 0

@interface XPDataManager : NSObject
{
}

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - test
-(BOOL)insertTest:(NSString*)title date:(NSDate*)adate;
-(BOOL)queryTest:(int)page size:(int)asize;

//#pragma mark - Task-List
// * 任务表的增删改查
-(void)insertTask:(NSString*)brief
           status:(int)status
             date:(NSDate*)adate
          project:(ProjectModel*)project;

-(void)updateTask:(TaskModel*)task2update
            brief:(NSString*)brief
           status:(int)status
          project:(ProjectModel*)project;

-(void)deleteTask:(NSString*)brief;
-(NSArray*)selectTaskByDay:(NSDate*)day;

//
//#pragma mark - Project-List
///* 项目表的增删改查
// */
-(void)insertProject:(NSString*)name;
-(NSArray*)selectProject:(NSInteger)page size:(NSInteger)size;

// others:
//-(NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//-(void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook;
//-(void)deleteData;

@end

