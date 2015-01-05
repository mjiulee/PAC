//
//  XPAdBannerVer.m
//  XPlan
//
//  Created by mjlee on 14-3-27.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAdBannerVer.h"
#import "UIImage+XPUIImage.h"

@interface XPAdBannerVer()<GDTMobBannerViewDelegate>
//@property(nonatomic,strong) GADBannerView* adBannerView;
@property(nonatomic,strong) GDTMobBannerView* adBannerView;
@property(nonatomic,strong) UIButton* closedBtn;
@end


@implementation XPAdBannerVer

- (id)initWithFrame:(CGRect)frame controler:(UIViewController*)controler
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        GDTMobBannerView* bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0,
                                                                         GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                         GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                       appkey:@"1101260559"
                                                  placementId:@"9079537216057354614"];
//                                                                        appkey:@"100720253"
//                                                                   placementId:@"9079537207574943610"];

        // Specify the ad unit ID.
        //bannerView.frame    = CGRectMake(0, 0, CGRectGetWidth(bannerView.frame), CGRectGetHeight(bannerView.frame));
        //bannerView.adUnitID = @"a15332320048fb4";
        //bannerView.delegate = (id<GADBannerViewDelegate>)self;
        //bannerView.rootViewController = controler;
        [self addSubview:bannerView];
        self.adBannerView = bannerView;
        self.adBannerView.delegate = self; // 设置Delegate
        self.adBannerView.currentViewController = controler; //设置当前的ViewController
        self.adBannerView.interval      = 30; //【可选】设置刷新频率;默认30秒
        self.adBannerView.isGpsOn       = NO; //【可选】开启GPS定位;默认关闭
        self.adBannerView.showCloseBtn  = YES; //【可选】展示关闭按钮;默认显示
        self.adBannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        [self addSubview:self.adBannerView]; //添加到当前的view中
        [self.adBannerView loadAdAndShow]; //加载广告并展示

        // Initiate a generic request to load it with an ad.
        //GADRequest *request = [GADRequest request];
        //request.testDevices = [NSArray arrayWithObjects:
        //                       @"MY_SIMULATOR_IDENTIFIER",
        //                       @"02fb3b5b76310a2b2362aaf0f30623bc",
        //                       nil];
        //[self.adBannerView loadRequest:request];
        
//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"btn_close_01"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"btn_close_02"] forState:UIControlStateHighlighted];
//        btn.frame = CGRectMake(frame.size.width-38,(frame.size.height-24)/2,24,24);
//        [btn addTarget:self action:@selector(onClosed:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
    }
    return self;
}

//-(void)onClosed:(UIButton* )btn
//{
//    if (self.closeBlock) {
//        self.closeBlock();
//    }
//}

//#pragma mark -
//- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
//{
//    if (self.adViewReceive) {
//        [self bringSubviewToFront:self.closedBtn];
//        self.adViewReceive();
//    }
//}
//
//- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
//{
//    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
//}

- (void)bannerViewMemoryWarning
{
    NSLog(@"%s",__FUNCTION__);
}

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"%s",__FUNCTION__);
    if (self.adViewReceive) {
        [self bringSubviewToFront:self.closedBtn];
        self.adViewReceive();
    }
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(int)errCode
{
    NSLog(@"%s,errcode=%d",__FUNCTION__,errCode);
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条曝光回调
//
// 详解:banner条曝光时回调该方法
- (void)bannerViewWillExposure
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条点击回调
//
// 详解:banner条被点击时回调该方法
- (void)bannerViewClicked
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose
{
    NSLog(@"%s",__FUNCTION__);
    if (self.closeBlock) {
        self.closeBlock();
    }
}


@end
