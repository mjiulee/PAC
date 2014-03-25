//
//  XPAlarmClockHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-13.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAlarmClockHelper.h"
#import "NSDate+Category.h"

static NSString* const kSTRmorningAlarm = @"xp-morning-call";
static NSString* const kSTREveningAlarm = @"xp-evening-call";

@implementation XPAlarmClockHelper
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
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:9 mintus:0];
    [self setAlarm:morningcall message:@"一日之计在于晨,今天你有啥计划吗？" name:kSTRmorningAlarm];
}

-(void)setupEveningAlarm
{
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:19 mintus:0];
    [self setAlarm:morningcall message:@"时光如梭，一天已经过去,今天你的计划都完成了吗？" name:kSTREveningAlarm];
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

@end
