//
//  ShareUtils.m
//  eTravelV2
//
//  Created by mjlee on 14-6-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ShareUtils.h"

#define ShareSDKShareContent @"我正在七乐康网上药店抢购特价商品，每天都有不一样的惊喜，注册还有积分礼品，赶快来逛逛吧！https://itunes.apple.com/cn/app/id919070794"
//默认进去时的内容
#define ShareSDKDefaultContent @"我正在七乐康网上药店抢购特价商品，每天都有不一样的惊喜，注册还有积分礼品，赶快来逛逛吧！https://itunes.apple.com/cn/app/id919070794"
//分享标题
#define ShareSDKTitle @"我正在使用七乐康购物呢"
//分享来源url
#define ShareSDKShareUrl @"https://itunes.apple.com/cn/app/id919070794"
//分享描述
#define ShareSDKShareContentDescription @"哈哈哈"


// ShareSdk
static  NSString* AppKey = @"1b0eaa005042";

//// SinaWeibo
static  NSString* SinaWeiboAppKey=@"857364782";
static  NSString* SinaWeiboAppSecret=@"49ca31f2e541bfb42e49a6fe8efbba1d";

// TencentWeibo
static  NSString* TencentWeiboAppKey=@"801502141";
static  NSString* TencentWeiboAppSecret=@"b025f1116b1c56af1211e8dbbd874fbf";

// QZone
static  NSString* QZoneAppId=@"801134596";
static  NSString* QZoneAppKey=@"63176ed6dc115822ce65c119f9dd720d";

//// Wechat
//static  NSString* WechatSortId=@"4";
//static  NSString* WechatAppId=@"wx79f8358726155a15";
//
//// WechatMoments
//static  NSString* WechatMomentsSortId=@"5";
//static  NSString* WechatMomentsAppId=@"wx79f8358726155a15";

// weibo分享

//#define kShareSDKAppkey @"1b0eaa005042"
////sina:微博
//#define kSinaWeiboAppkey @"857364782"
//#define kSinaWeiboSeckey @"49ca31f2e541bfb42e49a6fe8efbba1d"
//
////QQ:互联
//#define kQQconnectAppkey @"801134596"
//#define kQQconnectSeckey @"63176ed6dc115822ce65c119f9dd720d"
//
////QQ微博：
//#define kQQWeiboAppkey @"801502141"
//#define kQQWeiboSeckey @"b025f1116b1c56af1211e8dbbd874fbf"


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
    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiboAppKey
                               appSecret:SinaWeiboAppSecret
                             redirectUri:@"http://www.sharesdk.cn"
                             weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:TencentWeiboAppKey
                                  appSecret:TencentWeiboAppSecret
                                redirectUri:@"http://www.7lk.cn/"
                                   wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    //    [ShareSDK connectQZoneWithAppKey:QZoneAppId
    //                           appSecret:QZoneAppKey
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    
    // 微信
//    [ShareSDK connectWeChatWithAppId:WechatAppId
//                           wechatCls:[WXApi class]];
    
}

-(void)onShareTo:(NSString*)url contWeixi:(NSString*)contWeixi image:(NSString*)goodsImage complite:(void(^)(NSError *error))complite
{
    //actionSheet 列表
    NSArray* shareList = nil;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        shareList =     [ShareSDK getShareListWithType:
                         ShareTypeWeixiSession,
                         ShareTypeWeixiTimeline,
                         ShareTypeSinaWeibo,
                         ShareTypeTencentWeibo,
                         nil];
    }else{
        shareList =     [ShareSDK getShareListWithType:
                         ShareTypeSinaWeibo,
                         ShareTypeTencentWeibo,
                         nil];
    }
    
    //构造界面 输入内容
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享" //分享视图标题
                                                              oneKeyShareList:nil //一键分享菜单
                                                               qqButtonHidden:YES //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:YES //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:YES //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:YES //是否显示键盘
                                                            shareViewDelegate:nil //分享视图委托
                                                          friendsViewDelegate:nil //好友视图委托
                                                        picViewerViewDelegate:nil];
    
    NSString* imagePath = goodsImage;
    UIImage*  thumbImage= [UIImage imageNamed:@"share_detault"];
    NSString* ShareUrl  = url;
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",ShareSDKShareContent]
                                       defaultContent:ShareSDKDefaultContent
                                                image:nil
                                                title:ShareSDKTitle
                                                  url:ShareSDKShareUrl
                                          description:[NSString stringWithFormat:@"%@",ShareSDKShareContentDescription]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    // 七乐康 商品图片+商品名称+广告语+商品wap链接
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:contWeixi
                                           title:@"七乐康"
                                             url:ShareUrl
                                      thumbImage:imagePath?[ShareSDK imageWithUrl:imagePath]:[ShareSDK pngImageWithImage:thumbImage]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:contWeixi
                                            title:@"七乐康"
                                              url:ShareUrl
                                       thumbImage:imagePath?[ShareSDK imageWithUrl:imagePath]:[ShareSDK pngImageWithImage:thumbImage]
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
