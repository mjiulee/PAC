//
//  XPNewTaskVctler.h
//  XPlan
//
//  Created by mjlee on 14-2-25.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
typedef enum _XPNewTaskViewType{
    XPNewTaskViewType_New   = 10,
    XPNewTaskViewType_NewNormal,
    XPNewTaskViewType_NewImportant,
    XPNewTaskViewType_Update
}XPNewTaskViewType;

@interface XPNewTaskVctler : UIViewController{
    
}

@property(nonatomic)        XPNewTaskViewType viewType;
@property(nonatomic,strong) TaskModel* task2Update;
@end
