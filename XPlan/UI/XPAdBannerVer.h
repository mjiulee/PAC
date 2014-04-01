//
//  XPAdBannerVer.h
//  XPlan
//
//  Created by mjlee on 14-3-27.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

typedef void (^CloseAdBannerview)(void);
typedef void (^AdViewDidReceive)(void);

@interface XPAdBannerVer : GADBannerView
@property(nonatomic,copy) CloseAdBannerview closeBlock;
@property(nonatomic,copy) AdViewDidReceive  adViewReceive;
- (id)initWithFrame:(CGRect)frame controler:(UIViewController*)controler;
@end
