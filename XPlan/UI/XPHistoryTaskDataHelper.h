//
//  XPHistoryTaskDataHelper.h
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPHistoryTaskDataHelper : NSObject
@property(nonatomic,strong) NSMutableArray* listNormal;
@property(nonatomic,strong) NSMutableArray* listImportant;
@property(nonatomic,strong) NSMutableArray* listFinished;

//@property(nonatomic,strong) NSMutableArray* dataNormal;
//@property(nonatomic,strong) NSMutableArray* dataImportant;
//@property(nonatomic,strong) NSMutableArray* dataFinished;

// 检查是否有
-(BOOL)checkIfHadHistoryTask:(XPTaskPriorityLevel)priority;
// 分页处理
-(BOOL)hasNextPage:(XPTaskPriorityLevel)priority;
-(void)getNextPage:(XPTaskPriorityLevel)priority;

@end
