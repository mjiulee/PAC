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


typedef enum {
    XPTask_Type_User   = 0,    // Task Create by User
    XPTask_Type_System = 1     // Task Create By system
}XPTaskType;


typedef enum {
    XPTask_Status_ongoing= 0, // task that on going
    XPTask_Status_Done   = 2  // task that have done
}XPTaskStatus;

typedef enum {
    XPTask_PriorityLevel_normal    = 0,
    XPTask_PriorityLevel_important = 1
}XPTaskPriorityLevel;


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
          project:(ProjectModel*)project;

-(void)deleteTask:(NSString*)brief;
/* brief:根据任务的优先级进行查询
 * @param:day --- 需要查询的日期
 * @param:status- 需要查询的状态，0.普通 1.重要
 */
-(NSArray*)selectTaskByDay:(NSDate*)day status:(int)status;


/* brief:根据任务的优先级进行查询
 * @param:status- 需要查询的状态，0.普通 1.重要
 */
-(NSArray*)selectTaskByStatus:(int)status;

// TEST
-(NSArray*)selectTaskAll;

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

