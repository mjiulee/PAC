//
//  XPAppDelegate.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAppDelegate.h"
#import "XPRootViewCtl.h"
#import "IIViewDeckController.h"
#import "XPLeftMenuViewCtler.h"

@implementation XPAppDelegate

+ (XPAppDelegate*)shareInstance
{
    return (XPAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _coreDataMgr= [[XPDataManager alloc] init];
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _deckController = [self generateControllerStack];
    self.window.rootViewController = _deckController;
    [self.window makeKeyAndVisible];
    
    /*
    {   // 第20页
        NSString* page20 = @"1800,1590,1000,690,600,5883,72,105,3000,9940,432,265,5000";
        CGFloat total20 = 30377;
        [self testPage:page20 total:total20 pageidx:20];
    }

    {   // 第21页
        NSString* page20 = @"5000,484,55,1060.7,167,54,696,8750,9900,1093,954,75";
        CGFloat total20 = 28288.7;
        [self testPage:page20 total:total20 pageidx:21];
    }

    {   // 第22页
        NSString* page20 = @"6971,2530,514,280,2030,1410,5450,500,2760,74,70,4013,228";
        CGFloat total20 = 26830;
        [self testPage:page20 total:total20 pageidx:22];
    }
    
    {   // 第23页
        NSString* page20 = @"613,520,162,720,251,170,638";
        CGFloat total20 = 3074;
        [self testPage:page20 total:total20 pageidx:23];
    }

    {   // 第24页
        NSString* page20 = @"1677,1200,25,10954,161,260,1360,5959,54,36,10350,719,11360";
        CGFloat total20 = 44115;
        [self testPage:page20 total:total20 pageidx:24];
    }
    {   // 第25页
        NSString* page20 = @"8090,760.28,16759,42178.5,29205.36,94576.33,621,154,182,100,382,1017,1179,284";
        CGFloat total20 = 195488.47;
        [self testPage:page20 total:total20 pageidx:25];
    }
    {   // 第25页
        NSString* page20 = @"8090,760.28,16759,42178.5,29205.36,94576.33,621,154,182,100,382,1017,1179,284";
        CGFloat total20 = 195488.47;
        [self testPage:page20 total:total20 pageidx:25];
    }
    */
    
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

#pragma mark- ViewDeck
- (IIViewDeckController*)generateControllerStack
{
    XPRootViewCtl* centervc = [[XPRootViewCtl alloc] init];
    UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
    XPLeftMenuViewCtler*  leftController = [[XPLeftMenuViewCtler alloc] initWithStyle:UITableViewStylePlain];
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:rootNav
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    deckController.leftSize = 100;
    deckController.openSlideAnimationDuration = 0.25f;
    deckController.closeSlideAnimationDuration= 0.50f;

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
}
*/

@end
