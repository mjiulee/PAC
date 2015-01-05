//
//  ShareUtils.h
//  eTravelV2
//
//  Created by mjlee on 14-6-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"

#define kUrlAdAppstore  @"https://itunes.apple.com/us/app/ji-hua-free/id853802565?ls=1&mt=8"


@interface ShareUtils : NSObject
+(instancetype)instance;
-(void)setUpAppkeys;

// 发送分享
-(void)onShareTo:(NSString*)url
       contWeixi:(NSString*)contWeixi
           image:(NSString*)goodsImage
        complite:(void(^)(NSError *error))complite;
@end
