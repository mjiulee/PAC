//
//  XPUserDataHelper.h
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XPUserDataKey_HadShowGuider = 0, // 今日已经显示过导读图
    XPUserDataKey_LastOpenDate  = 1, // 今日是否打开过程序
    XPUserDataKey_WeatherCity   = 2  // 天气信息的所在城市，默认广州
}XPUserDataKey;

@interface XPUserDataHelper : NSObject

/* brief :获取sigleten 对象
 * params:
 */
+(instancetype)shareInstance;

/* brief:根据key的枚举值进行保存
 * params:
 * @key --- 传入的key值，当key不存在时，直接assert报错
 */
-(BOOL)setUserDataByKey:(XPUserDataKey)key value:(id)value;
/* brief:根据key的枚举值进行读取
 * params:
 * @key --- 要取的到的用户信息对应的key值
 */
-(id)getUserDataByKey:(XPUserDataKey)key;
@end
