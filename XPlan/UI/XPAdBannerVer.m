//
//  XPAdBannerVer.m
//  XPlan
//
//  Created by mjlee on 14-3-27.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAdBannerVer.h"
#import "UIImage+XPUIImage.h"

@interface XPAdBannerVer()
@property(nonatomic,strong) GADBannerView* adBannerView;
@property(nonatomic,strong) UIButton* closedBtn;
@end


@implementation XPAdBannerVer

- (id)initWithFrame:(CGRect)frame controler:(UIViewController*)controler
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        // Specify the ad unit ID.
        bannerView.frame    = CGRectMake(0, 0, CGRectGetWidth(bannerView.frame), CGRectGetHeight(bannerView.frame));
        bannerView.adUnitID = @"a15332320048fb4";
        bannerView.delegate = (id<GADBannerViewDelegate>)self;
        bannerView.rootViewController = controler;
        [self addSubview:bannerView];
        self.adBannerView = bannerView;
        // Initiate a generic request to load it with an ad.
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:
                               @"MY_SIMULATOR_IDENTIFIER",
                               @"MY_DEVICE_IDENTIFIER",
                               nil];
        [self.adBannerView loadRequest:request];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"btn_close_01"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_close_02"] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(frame.size.width-38,(frame.size.height-24)/2,24,24);
        [btn addTarget:self action:@selector(onClosed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)onClosed:(UIButton* )btn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark -
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    if (self.adViewReceive) {
        [self bringSubviewToFront:self.closedBtn];
        self.adViewReceive();
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}
@end
