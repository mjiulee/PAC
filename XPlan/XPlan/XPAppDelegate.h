//
//  XPAppDelegate.h
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "XPDataManager.h"

@interface XPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) XPDataManager*    coreDataMgr;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController* deckController;

// 单例模式
+(XPAppDelegate*)shareInstance;

@end
