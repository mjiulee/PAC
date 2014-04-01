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
-(void)setupNotification;
@end
