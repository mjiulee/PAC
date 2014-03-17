//
//  XPAppDelegate.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAppDelegate.h"
#import "IIViewDeckController.h"
#import "XPLeftMenuViewCtler.h"

#import "XPProjectViewCtler.h"
#import "XPTaskListVCtler.h"

#import "XPStartupGuiderVctler.h"
#import "XPAlarmClockHelper.h"

@interface XPAppDelegate()
@property(nonatomic,strong) XPAlarmClockHelper* alarmHelper;
@end

@implementation XPAppDelegate

+ (XPAppDelegate*)shareInstance
{
    return (XPAppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(void)showTaskListDeckVctler
{
    // 初始化
    _deckController = [self generateControllerStack];
    
    // 动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    // view插入、移出
    [self.guiderVctler.view removeFromSuperview];
    self.window.rootViewController = self.deckController;
    [[_window layer] addAnimation:animation forKey:@"animation"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // core Data setup
    _coreDataMgr= [[XPDataManager alloc] init];
    
    // alarmhelper setup
    XPAlarmClockHelper* alarmHelper = [[XPAlarmClockHelper alloc] init];
    self.alarmHelper = alarmHelper;
    
    // 设置每天都要进行一次提醒：在早上9：00进行提醒
    [self.alarmHelper setupMorningAlarm];
    // 设置每天都要进行一次提醒：在晚上19：00进行提醒
    [self.alarmHelper setupEveningAlarm];

    // show the start up guider
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _guiderVctler   = [self generateStartupGuider];
    self.window.rootViewController = _guiderVctler;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"123123123131231231++++++++++++");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提醒"
                                                    message:notification.alertBody
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark- startguider vctler
-(XPStartupGuiderVctler*)generateStartupGuider{
    XPStartupGuiderVctler* startupvc = [[XPStartupGuiderVctler alloc] init];
    return startupvc;
}

#pragma mark- ViewDeck
- (IIViewDeckController*)generateControllerStack
{
    XPTaskListVCtler* centervc = [[XPTaskListVCtler alloc] init];
    UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
    XPLeftMenuViewCtler*  leftController = [[XPLeftMenuViewCtler alloc] initWithStyle:UITableViewStyleGrouped];
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:rootNav
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    //deckController.panningMode = IIViewDeckNavigationBarPanning;
    deckController.leftSize = 100;
    deckController.openSlideAnimationDuration = 0.25f;
    deckController.closeSlideAnimationDuration= 0.25f;

    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}

/*
-(void)testPage:(NSString*)datas total:(CGFloat)total pageidx:(int)page{
    NSArray* ary = [datas componentsSeparatedByString:@","];

    CGFloat totalValue = 0;
    for (NSString* item in ary) {
        totalValue += [item floatValue];
    }
    if (total != totalValue) {
        NSLog(@"第%d页不对,total=%.02f,total2=%.02f",page,total,totalValue);
    }else{
        NSLog(@"第%d页正确,total=%0.2f",page,totalValue);
    }
}*/

@end
