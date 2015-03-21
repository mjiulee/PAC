//
//  ShareUtils.m
//  eTravelV2
//
//  Created by mjlee on 14-6-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ShareUtils.h"

#define ShareSDKShareContent @""
//默认进去时的内容
#define ShareSDKDefaultContent @"我正在使用‘我的日常’app哦，快来一起吧~"
//分享标题
#define ShareSDKTitle    @"我的日常"
//分享来源url
#define ShareSDKShareUrl @"https://itunes.apple.com/cn/app/id853802565"
//分享描述
#define ShareSDKShareContentDescription @"我正在使用‘我的日常’app哦，快来一起吧~"

// ShareSdk
static  NSString* AppKey = @"1b0eaa005042";
//sina:微博
#define kSinaWeiboAppkey @"857364782"
#define kSinaWeiboSeckey @"49ca31f2e541bfb42e49a6fe8efbba1d"

//QQ:互联
#define kQQconnectAppkey @"801134596"
#define kQQconnectSeckey @"63176ed6dc115822ce65c119f9dd720d"

//QQ:空间
#define kQQZoneAppkey   @"101077363"
#define kQQZoneSeckey   @"73ba476c896f98fd2c290c9ebe127644"

//QQ微博：
#define kQQWeiboAppkey @"801502141"
#define kQQWeiboSeckey @"b025f1116b1c56af1211e8dbbd874fbf"

//微信：
#define WechatAppId    @"wx9abf4ac057238f49"

@implementation ShareUtils

+(instancetype)instance{
    static ShareUtils * instance;
    static dispatch_once_t  dpn_task;
    dispatch_once(&dpn_task,^(){
        instance = [[ShareUtils alloc] init];
    });
    return instance;
}

-(ShareUtils*)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)setUpAppkeys{
    
    [ShareSDK registerApp:AppKey];
    [ShareSDK connectSinaWeiboWithAppKey:kSinaWeiboAppkey
                               appSecret:kSinaWeiboSeckey
                             redirectUri:@"http://www.sharesdk.cn"
                             weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:kQQWeiboAppkey
                                  appSecret:kQQWeiboSeckey
                                redirectUri:@"http://www.7lk.cn/"
                                   wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kQQZoneAppkey
                           appSecret:kQQZoneSeckey
                   qqApiInterfaceCls:[QQApiInterface class]
     
                     tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQQWithAppId:kQQconnectAppkey
                        qqApiCls:[QQApi class]];
    
    // 微信
    [ShareSDK connectWeChatWithAppId:WechatAppId
                           wechatCls:[WXApi class]];
    
}

-(void)onShareTo:(NSString*)url content:(NSString*)content contWeixi:(NSString*)contWeixi image:(UIImage*)goodsImage complite:(void(^)(NSError *error))complite
{
    //actionSheet 列表
    NSArray* shareList = nil;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        shareList =     [ShareSDK getShareListWithType:
                         ShareTypeWeixiSession,
                         ShareTypeWeixiTimeline,
                         ShareTypeQQSpace,
                         ShareTypeSinaWeibo,
                         ShareTypeTencentWeibo,
                         nil];
    }else{
        shareList =     [ShareSDK getShareListWithType:
                         ShareTypeQQSpace,
                         ShareTypeSinaWeibo,
                         ShareTypeTencentWeibo,
                         nil];
    }
    
    //构造界面 输入内容
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"我的日常" //分享视图标题
                                                              oneKeyShareList:nil //一键分享菜单
                                                               qqButtonHidden:YES //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:YES //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:YES //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:YES //是否显示键盘
                                                            shareViewDelegate:nil //分享视图委托
                                                          friendsViewDelegate:nil //好友视图委托
                                                        picViewerViewDelegate:nil];
    
//    NSString* imagePath = goodsImage;
//    UIImage*  thumbImage= [UIImage imageNamed:@"share_detault"];
//    NSString* ShareUrl  = url;
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",content,url]
                                       defaultContent:ShareSDKDefaultContent
                                                image:nil
                                                title:ShareSDKTitle
                                                  url:url
                                          description:[NSString stringWithFormat:@"%@",ShareSDKShareContentDescription]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    // 商品图片+商品名称+广告语+商品wap链接
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:contWeixi
                                           title:ShareSDKTitle
                                             url:url
                                      thumbImage:[ShareSDK pngImageWithImage:goodsImage]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:contWeixi
                                            title:ShareSDKTitle
                                              url:url
                                       thumbImage:[ShareSDK pngImageWithImage:goodsImage]
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    id<ISSShareActionSheet> sh =[ShareSDK showShareActionSheet:nil shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:shareOptions result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
    {
        if (state == SSResponseStateSuccess){
            NSLog(@"分享成功");
            if (complite) {
                complite(nil);
            }
        }
        else if (state == SSResponseStateFail){
            if (complite) {
                NSError* rterror = [NSError errorWithDomain:[error errorDescription] code:[error errorCode] userInfo:nil];
                complite(rterror);
            }
        }
    }];
    NSLog(@"%@",[sh description]);
}

@end
