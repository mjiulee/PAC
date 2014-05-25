//
//  XPDialyStaticVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDialyStaticVCtler.h"
#import "PNChart.h"
#import "Utils.h"
#import <ShareSDK/ShareSDK.h>
#import "XPADAppDelegate.h"

static const NSUInteger kScrollViewPageIndex = 1000;

@interface XPDialyStaticVCtler ()
{
    NSUInteger _normalOngoing;
    NSUInteger _normalDone;
    NSUInteger _importantOngoing;
    NSUInteger _importantDone;
    NSUInteger _allTotal;
    NSUInteger _allDone;
    NSUInteger _allOngoing;
}
@property(nonatomic,strong)UIScrollView*contentScrollview;
@property(nonatomic,strong)PNCircleChart*circleChart;
@property(nonatomic)NSInteger pageIndex;

-(void)onNavLeftBtnAction:(id)sender;
@end

@implementation XPDialyStaticVCtler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // data prepare
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"统计";
	// Do any additional setup after loading the view.
    // nav left
    {
        UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
        //UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        //[btn setImage:imhighLight forState:UIControlStateHighlighted];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    //self.view.backgroundColor = [UIColor redColor];
    if([[XPADAppDelegate shareInstance] sharSdkInitFinish]==YES)
    {
        UIImage* imgnormal   = [UIImage imageNamed:@"share_btn"];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
        [btn addTarget:self action:@selector(onshare:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }

    
    CGFloat yvalstart     = 0;//CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIScrollView* sclview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yvalstart,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-yvalstart)];
    sclview.showsVerticalScrollIndicator  = NO;
    sclview.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
    sclview.showsHorizontalScrollIndicator= NO;
    sclview.pagingEnabled  = YES;
    //sclview.delegate       = (id<UIScrollViewDelegate>)self;
    [self.view addSubview:sclview];
    self.contentScrollview = sclview;
    self.contentScrollview.contentSize = CGSizeMake(CGRectGetWidth(sclview.frame), 0);
    [self prepareForStatistic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setPageView:0];
}

-(void)prepareForStatistic
{
    if (self.date2Statistic) {
        // 普通
        _normalOngoing = [[XPDataManager shareInstance] taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        _normalDone    = [[XPDataManager shareInstance] taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        _importantOngoing=[[XPDataManager shareInstance] taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        _importantDone   =[[XPDataManager shareInstance] taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_important status:XPTask_Status_Done];
        // 全部
        _allTotal   = (_normalDone+_normalOngoing+_importantDone+_importantOngoing);
        _allDone    = _normalDone+_importantDone;
        _allOngoing = _normalOngoing+_importantOngoing;
    }else{
        // 普通
        _normalOngoing = [[XPDataManager shareInstance]  getHistoryTaskCount:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        _normalDone    = [[XPDataManager shareInstance]  getHistoryTaskCount:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        _importantOngoing=[[XPDataManager shareInstance] getHistoryTaskCount:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        _importantDone   =[[XPDataManager shareInstance] getHistoryTaskCount:XPTask_PriorityLevel_important status:XPTask_Status_Done];
        // 全部
        _allTotal   = (_normalDone+_normalOngoing+_importantDone+_importantOngoing);
        _allDone    = _normalDone+_importantDone;
        _allOngoing = _normalOngoing+_importantOngoing;
    }
}

#pragma mark - nav button actions
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  UIScrollviewdelegate
-(void)setPageView:(NSUInteger)page
{
    if (page == 0)
    {
        UIView* cycleView = [self.contentScrollview viewWithTag:kScrollViewPageIndex+page];
        if (cycleView ==nil){
            cycleView = [[UIView alloc] initWithFrame:CGRectMake(10.0,10.0,CGRectGetWidth(self.contentScrollview.frame)-20,
                                                                 CGRectGetHeight(self.contentScrollview.frame)-20)];
            cycleView.tag = kScrollViewPageIndex+page;
            cycleView.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
            cycleView.layer.borderColor= XPRGBColor(157, 157, 157, 1.0).CGColor;
            cycleView.layer.borderWidth =0.5;
            cycleView.layer.cornerRadius= 8;
            cycleView.clipsToBounds     = YES;
            [self.contentScrollview addSubview:cycleView];
        }
        [[cycleView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSLog(@"frame=%@",NSStringFromCGRect(cycleView.frame));
        
        {
            CGFloat fpercent = 0.0;
            if (_allTotal > 0) {
                fpercent = (_normalDone+_importantDone)*1.0/_allTotal;
            }
            CGFloat yval = 40;
            if ([UIDevice isRunningOniPhone5]) {
                yval = 60;
            }
            PNCircleChart * circleChart
            = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,60,CGRectGetWidth(cycleView.frame),130)
                                          andTotal:[NSNumber numberWithInt:1]
                                        andCurrent:[NSNumber numberWithFloat:fpercent]];
            circleChart.backgroundColor = [UIColor clearColor];
            [circleChart setStrokeColor:XPRGBColor(25, 133, 255, 1.0)];
            [circleChart strokeChart];
            [cycleView addSubview:circleChart];
            self.circleChart = circleChart;
        }
        
        {
            CGFloat yof = cycleView.frame.size.height - 100;
            if ([UIDevice isRunningOniPhone5]) {
                yof = cycleView.frame.size.height - 140;
            }
            for(int i = 0;i < 3;i++){
                UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(40,yof,CGRectGetWidth(cycleView.frame),20)];
                labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                if (i == 0) {
                    labtitle.text = [NSString stringWithFormat:@"普通：%u条，已完成：%u条，未完成：%u",_normalDone+_normalOngoing,_normalDone,_normalOngoing];
                }else if(i==1){
                    labtitle.text = [NSString stringWithFormat:@"重要：%u条，已完成：%u条，未完成：%u",_importantDone+_importantOngoing,_importantDone,_importantOngoing];
                }else{
                    labtitle.text = [NSString stringWithFormat:@"全部：%u条，已完成：%u条，未完成：%u",_allTotal,_allDone,_allOngoing];
                }
                labtitle.textColor = XPRGBColor(157,157,157, 1.0);
                labtitle.font = [UIFont systemFontOfSize:13];
                labtitle.textAlignment   = NSTextAlignmentLeft;
                labtitle.backgroundColor = kClearColor;
                [cycleView addSubview:labtitle];
                yof +=25;
            }
        }
    }
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)onshare:(id)sender
{
    CGFloat fpercent = 0.0;
    if (_allTotal > 0) {
        fpercent = (_normalDone+_importantDone)/_allTotal;
    }
    
    NSString* brief  = @"";
    if (fpercent < 0.1) {
        brief = @"妈蛋，今天没干活吗？\r这效率捡钱都抢不过别人啊.";
    }else if(fpercent < 0.5){
        brief = @"妈蛋，一天的活才做不到一半.\r还想迎娶高富帅/嫁个白富美不？\r还想就滚回去干活!";
    }else if(fpercent < 0.8){
        brief = @"哎呦，今天效率不从，再接再厉";
    }else{
        brief = @"喔插咧，效率爆表啊.\r我这是发粪图强，努力上进，不久当上CEO，迎娶白富美，走向人生巅峰的节奏啊！";
    }
    
    UIImage* imagesnap = [self capture];
    //构造分享内容
    id<ISSContent> publishContent =
        [ShareSDK content:[NSString stringWithFormat:@"%@,%@",brief,kUrlAdAppstore]
           defaultContent:[NSString stringWithFormat:@"%@,%@",brief,kUrlAboutXplan]
                    image:[ShareSDK pngImageWithImage:imagesnap]
                    title:@"每天完成一件事"
                      url:kUrlAboutXplan
              description:@"来自’计&划‘应用"
                mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:@"计&划：每日完成一件事"
                                        url:kUrlAdAppstore
                                       site:kUrlAboutXplan
                                    fromUrl:nil
                                    comment:brief
                                    summary:@"来自’计&划‘应用"
                                      image:[ShareSDK pngImageWithImage:imagesnap]
                                       type:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                    playUrl:nil
                                       nswb:nil];
    //定制QQ分享信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:brief
                                title:@"计&划"
                                  url:kUrlAboutXplan
                                image:[ShareSDK pngImageWithImage:imagesnap]];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:brief
                                           title:@"计&划：每日完成一件事"
                                             url:kUrlAboutXplan
                                      thumbImage:[ShareSDK pngImageWithImage:imagesnap]
                                           image:[ShareSDK pngImageWithImage:imagesnap]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:brief
                                            title:@"计&划：每日完成一件事"
                                              url:kUrlAboutXplan
                                       thumbImage:[ShareSDK pngImageWithImage:imagesnap]
                                            image:[ShareSDK pngImageWithImage:imagesnap]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"计&划"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"计&划"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeQQ,
                          ShareTypeCopy,
                          nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:shareList
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
@end
