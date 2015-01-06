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

+(instancetype)shareInstance;
// 设置每天早上、晚上的提醒
-(void)setupNotification;
// 对任务做提醒
-(void)setTaskNotify:(NSDate*)date message:(NSString*)msg name:(NSString*)name;
-(void)cancelTaskNotification:(NSString*)name;
@end
