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
#import "DiaryTaskModel.h"

#define IfCoreDataDebug 0


typedef enum {
    XPTask_Type_User   = 0,    // Task Create by User
    XPTask_Type_System = 1     // Task Create By system
}XPTaskType;


typedef enum {
    XPTask_Status_ongoing= 1, // task that on going
    XPTask_Status_Done   = 2  // task that have done
}XPTaskStatus;

typedef enum {
    XPTask_PriorityLevel_all       = 0,
    XPTask_PriorityLevel_normal    = 1,
    XPTask_PriorityLevel_important = 2
}XPTaskPriorityLevel;


@interface XPDataManager : NSObject{
}

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - test

#pragma mark - Task-List
/* 插入一项任务:
 * params
 * @content     --- 任务内容
 * @datecreate  --- 创建时间
 * @taskType    --- 类型：系统、用户自建
 * @prLevel     --- 优先级：普通、重要
 * @project     --- 所属项目,暂时不用 */
-(void)insertTask:(NSString*)content date:(NSDate*)datecreate type:(XPTaskType)taskType prLevel:(XPTaskPriorityLevel)prLevel
          project:(ProjectModel*)project;

/* 更新一项任务:
 * params
 * @task2update --- 任务内容 */
-(void)updateTask:(TaskModel*)task2update;

/* 删除一项任务:
 * params
 * @content     --- 任务内容*/
-(void)deleteTask:(NSString*)content;

/* 根据任务的优先级进行查询
 * @param:day      --- 需要查询的日期
 * @param:level    --- 优先级
 * @param:taskType --- 类型
 * @param:status   --- 状态 */
-(NSArray*)queryTaskByDay:(NSDate*)day prLevel:(XPTaskPriorityLevel)alevel status:(XPTaskStatus)astatus;


/* brief:根据任务的优先级进行查询
 * @param:level - 0.普通 1.重要
 * @param:status- 状态
 */
-(NSArray*)queryHistoryTask:(XPTaskPriorityLevel)alevel status:(int)status;

//TODO: #pragma mark - Project-List
#pragma mark - dialy task 
-(void)insertDialyTask:(NSString*)content weekday:(NSUInteger)weekday;
-(NSArray*)queryDialyTask:(NSUInteger)weekday;

@end

