//
//  XPAlarmClockHelper.h
//  XPlan
//
//  Created by mjlee on 14-3-13.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface XPAlarmClockHelper : NSObject
@property(nonatomic)SystemSoundID soundFileObject;

// 设置闹钟:早晨
-(void)setupMorningAlarm;
// 设置闹钟：夜晚
-(void)setupEveningAlarm;
// 取消本地消息
-(void)cancelLocalNotification;
@end
