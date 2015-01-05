//
//  XPAlarmClockHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-13.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAlarmClockHelper.h"
#import "NSDate+Category.h"
#import "XPUserDataHelper.h"

static NSString* const kSTRmorningAlarm = @"xp-morning-call";
static NSString* const kSTREveningAlarm = @"xp-evening-call";

@interface XPAlarmClockHelper()
// 设置闹钟:早晨
-(void)setupMorningAlarm;
// 设置闹钟：夜晚
-(void)setupEveningAlarm;
// 取消本地消息
-(void)cancelLocalNotification;
@end;

@implementation XPAlarmClockHelper

+(instancetype)shareInstance
{
    static XPAlarmClockHelper * instance;
    static dispatch_once_t  dpn_task;
    dispatch_once(&dpn_task,^(){
        instance = [[XPAlarmClockHelper alloc] init];
    });
    return instance;
}

-(void)setupNotification
{
    // 先取消
    [self cancelLocalNotification];
    // 设置每天都要进行一次提醒：在早上9：00进行提醒
    [self setupMorningAlarm];
    // 设置每天都要进行一次提醒：在晚上19：00进行提醒
    [self setupEveningAlarm];
}

-(void)PlayAlarm{
    CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	
	// Get the URL to the sound file to play
    CFURLRef soundFileURLRef =	CFBundleCopyResourceURL (mainBundle,CFSTR ("tap"),CFSTR ("aif"),NULL);
    //将nsstring转为cfstring
    
    //SystemSoundID soundFileObject;
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID(soundFileURLRef,&_soundFileObject);//声音的绑定（类似数据库时用的数据库指针）
}

-(void)setupMorningAlarm
{
    NSUInteger hour=9,minute = 0;
    NSDictionary* dict = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_MorningNotify];
    if (dict) {
        NSNumber* hourNumber   = [dict objectForKey:@"hour"];
        NSNumber* miniteNumber = [dict objectForKey:@"minute"];
        hour   = [hourNumber unsignedIntegerValue];
        minute = [miniteNumber unsignedIntegerValue];
    }
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:hour mintus:minute];
    [self setAlarm:morningcall message:@"一日之计在于晨,今天你有想做的事情吗？快来计划一下吧~" name:kSTRmorningAlarm];
}

-(void)setupEveningAlarm
{
    NSUInteger hour=19,minute = 0;
    NSDictionary* dict = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_NightNotify];
    if (dict) {
        NSNumber* hourNumber   = [dict objectForKey:@"hour"];
        NSNumber* miniteNumber = [dict objectForKey:@"minute"];
        hour   = [hourNumber unsignedIntegerValue];
        minute = [miniteNumber unsignedIntegerValue];
    }
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:hour mintus:minute];
    [self setAlarm:morningcall message:@"时光如梭，一天已经过去,今天你的计划都完成了吗？快来总结吧~" name:kSTREveningAlarm];
}

-(void)setAlarm:(NSDate*)date message:(NSString*)msg name:(NSString*)name
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate   = date;      //触发通知的时间
        notification.repeatCalendar = [NSCalendar currentCalendar];
        notification.repeatInterval = NSDayCalendarUnit;//kCFCalendarUnitDay;一天一次
        notification.timeZone   = [NSTimeZone defaultTimeZone];
        notification.soundName  = UILocalNotificationDefaultSoundName;
        notification.alertBody  = msg;
        
        notification.alertAction= @"打开";  //提示框按钮
        notification.hasAction  = YES;       //是否显示额外的按钮，为no时alertAction消失
        
        //notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:name forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)cancelLocalNotification
{
    //拿到 存有 所有 推送的数组
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
    for (UILocalNotification * loc in array)
    {
        if ([[loc.userInfo objectForKey:@"key"] isEqualToString:kSTREveningAlarm]||
            [[loc.userInfo objectForKey:@"key"] isEqualToString:kSTRmorningAlarm]||
            [[loc.userInfo objectForKey:@"key"] isEqualToString:@"name"])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:loc];//取消 本地推送
        }
    }
    NSLog(@"关闭本地通知");
}

-(void)setTaskNotify:(NSDate*)date message:(NSString*)msg name:(NSString*)name
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate   = date;      //触发通知的时间
        notification.repeatCalendar = [NSCalendar currentCalendar];
        notification.timeZone   = [NSTimeZone defaultTimeZone];
        notification.soundName  = UILocalNotificationDefaultSoundName;
        notification.alertBody  = msg;
        
        notification.alertAction= @"打开";  //提示框按钮
        notification.hasAction  = YES;       //是否显示额外的按钮，为no时alertAction消失
        
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:name forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end
