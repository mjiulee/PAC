//
//  XPUserDataHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPUserDataHelper.h"

@implementation XPUserDataHelper

+(instancetype)shareInstance
{
    static XPUserDataHelper * instance;
    static dispatch_once_t  dpn_task;
    dispatch_once(&dpn_task,^(){
        instance = [[XPUserDataHelper alloc] init];
    });
    return instance;
}

/* brief:根据key的枚举值进行保存
 * params:
 * @key --- 传入的key值，当key不存在时，直接assert报错
 */
-(BOOL)setUserDataByKey:(XPUserDataKey)key value:(id)value
{
    if (value == nil)
    {
        return NO;
    }
    
    NSString* keyName = nil;
    switch (key) {
        case XPUserDataKey_HadShowGuider:
            keyName = @"XPUserDataKey_HadShowGuider";
            break;
        case XPUserDataKey_LastOpenDate:
            keyName = @"XPUserDataKey_LastOpenDate";
            break;
        case XPUserDataKey_WeatherCity:
            keyName = @"XPUserDataKey_WeatherCity";
            break;
        case XPUserDataKey_MorningNotify:
            keyName = @"XPUserDataKey_MorningNotify";
            break;
        case XPUserDataKey_NightNotify:
            keyName = @"XPUserDataKey_NightNotify";
            break;
        default:
            NSAssert(NO, @"你所要保存的信息，未在预定义的id中，请先定义再保存，此举为了防止信息乱存放");
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
/* brief:根据key的枚举值进行读取
 * params:
 * @key --- 要取的到的用户信息对应的key值
 */
-(id)getUserDataByKey:(XPUserDataKey)key
{
    NSString* keyName = nil;
    switch (key) {
        case XPUserDataKey_HadShowGuider:
            keyName = @"XPUserDataKey_HadShowGuider";
            break;
        case XPUserDataKey_LastOpenDate:
            keyName = @"XPUserDataKey_LastOpenDate";
            break;
        case XPUserDataKey_WeatherCity:
            keyName = @"XPUserDataKey_WeatherCity";
            break;
        case XPUserDataKey_MorningNotify:
            keyName = @"XPUserDataKey_MorningNotify";
            break;
        case XPUserDataKey_NightNotify:
            keyName = @"XPUserDataKey_NightNotify";
            break;
        default:
            NSAssert(NO, @"你所要读取的信息，未在预定义的id中，请先定义再保存，此举为了防止信息乱存放");
            break;
    }
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
    return value;
}


@end
