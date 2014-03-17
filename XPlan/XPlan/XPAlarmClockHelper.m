//
//  XPAlarmClockHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-13.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAlarmClockHelper.h"
#import "NSDate+Category.h"

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
    [self setAlarm:morningcall message:@"一日之计在于晨,今天你有啥计划吗？"];
}

-(void)setupEveningAlarm
{
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:19 mintus:0];
    [self setAlarm:morningcall message:@"时光如梭，一天已经过去,今天你的计划都完成了吗？"];
}

-(void)setAlarm:(NSDate*)date message:(NSString*)msg
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate  = date;      //触发通知的时间
        notification.repeatInterval=2;      //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone   = [NSTimeZone defaultTimeZone];
        notification.soundName  = UILocalNotificationDefaultSoundName;
        notification.alertBody  = msg;
        
        notification.alertAction= @"打开";  //提示框按钮
        notification.hasAction  = YES;       //是否显示额外的按钮，为no时alertAction消失
        
        //notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
