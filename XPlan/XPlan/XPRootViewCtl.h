//
//  XPRootViewCtl.h
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _XPRootListType{
    XPRootList_List_Type_Normal  = 0,   // 普通列表
    XPRootList_List_Type_Project = 1,   // 项目列表
}XPRootListType;


@interface XPRootViewCtl : UIViewController
@property(nonatomic,setter = setXPRootListType:) XPRootListType XPListType;

@end
