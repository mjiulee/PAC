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
#import "ShareUtils.h"

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
        _date2Statistic = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (nil != self.date2Statistic) {
        self.title = @"今日统计";
    }else{
        self.title = @"全部统计";
    }
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
//    NSNumber* finished = [[[UIApplication sharedApplication] delegate] performSelector:@selector(sharSdkInitFinish)];
//    if([finished boolValue] ==YES )
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
            cycleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.contentScrollview.frame),
                                                                 CGRectGetHeight(self.contentScrollview.frame))];
            cycleView.tag = kScrollViewPageIndex+page;
            cycleView.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
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
            
            CGRect tf = CGRectMake(0,35,CGRectGetWidth(cycleView.frame),115);
            if ([UIDevice isRunningOniPhone5]) {
                tf = CGRectMake(0,60,CGRectGetWidth(cycleView.frame),130);
            }
            
            PNCircleChart * circleChart
            = [[PNCircleChart alloc] initWithFrame:tf
                                          andTotal:[NSNumber numberWithInt:1]
                                        andCurrent:[NSNumber numberWithFloat:fpercent]];
            circleChart.backgroundColor = [UIColor clearColor];
            [circleChart setStrokeColor:XPRGBColor(25, 133, 255, 1.0)];
            [circleChart strokeChart];
            [cycleView addSubview:circleChart];
            self.circleChart = circleChart;
            self.circleChart.center = CGPointMake(cycleView.center.x,circleChart.center.y);
        }
        
        {
            CGFloat yof = cycleView.frame.size.height - 140;
            if ([UIDevice isRunningOniPhone5]) {
                yof = cycleView.frame.size.height - 160;
            }
            for(int i = 0;i < 3;i++){
                UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,yof,CGRectGetWidth(cycleView.frame),20)];
                labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                if (i == 0) {
                    // 普通：
                    labtitle.attributedText = [self getAttributstring:@"普通："
                                                                total:_normalDone+_normalOngoing
                                                                 done:_normalDone
                                                              notdone:_normalOngoing];
                }else if(i==1){
                    labtitle.attributedText = [self getAttributstring:@"重要："
                                                                total:_importantDone+_importantOngoing
                                                                 done:_importantDone
                                                              notdone:_importantOngoing];
                }else{
                    labtitle.attributedText = [self getAttributstring:@"全部："
                                                                total:_allTotal
                                                                 done:_allDone
                                                              notdone:_allOngoing];
                }
                labtitle.textAlignment   = NSTextAlignmentCenter;
                labtitle.backgroundColor = kClearColor;
                [cycleView addSubview:labtitle];
                yof +=25;
            }
        }
    }
}

-(NSMutableAttributedString*)getAttributstring:(NSString*)type total:(NSUInteger)total done:(NSUInteger)done notdone:(NSUInteger)notdone
{
    NSMutableAttributedString *atStrNormalType = [[NSMutableAttributedString alloc] initWithString:type];
    [atStrNormalType addAttribute:NSForegroundColorAttributeName
                            value:(id)XPRGBColor(156, 157, 158, 1.0)
                            range:NSMakeRange(0, [atStrNormalType length])];
    [atStrNormalType addAttribute:NSFontAttributeName
                            value:(id)[UIFont systemFontOfSize:13]
                            range:NSMakeRange(0, [atStrNormalType length])];
    // 条
    NSMutableAttributedString *atstrUnit = [[NSMutableAttributedString alloc] initWithString:@"条,"];
    [atstrUnit addAttribute:NSForegroundColorAttributeName
                      value:(id)XPRGBColor(156, 157, 158, 1.0)
                      range:NSMakeRange(0, [atstrUnit length])];
    [atstrUnit addAttribute:NSFontAttributeName
                      value:(id)[UIFont systemFontOfSize:13]
                      range:NSMakeRange(0, [atstrUnit length])];

    // 已完成
    NSMutableAttributedString *atStrDoneType = [[NSMutableAttributedString alloc] initWithString:@"已完成："];
    [atStrDoneType addAttribute:NSForegroundColorAttributeName
                          value:(id)XPRGBColor(156, 157, 158, 1.0)
                          range:NSMakeRange(0, [atStrDoneType length])];
    [atStrDoneType addAttribute:NSFontAttributeName
                          value:(id)[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, [atStrDoneType length])];

    // 未完成
    NSMutableAttributedString *atStrNotDoneType = [[NSMutableAttributedString alloc] initWithString:@"未完成："];
    [atStrNotDoneType addAttribute:NSForegroundColorAttributeName
                             value:(id)XPRGBColor(156, 157, 158, 1.0)
                             range:NSMakeRange(0, [atStrNotDoneType length])];
    [atStrNotDoneType addAttribute:NSFontAttributeName
                             value:(id)[UIFont systemFontOfSize:13]
                             range:NSMakeRange(0, [atStrNotDoneType length])];
    // numberType
    NSMutableAttributedString *strNormal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(total)]];
    [strNormal addAttribute:NSForegroundColorAttributeName
                      value:(id)XPRGBColor(35,137, 255, 1.0)
                      range:NSMakeRange(0, [strNormal length])];
    [strNormal addAttribute:NSFontAttributeName
                      value:(id)[UIFont systemFontOfSize:13]
                      range:NSMakeRange(0, [strNormal length])];

    // numberType
    NSMutableAttributedString *strDone = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(done)]];
    [strDone addAttribute:NSForegroundColorAttributeName
                    value:(id)XPRGBColor(35,137, 255, 1.0)
                    range:NSMakeRange(0, [strDone length])];
    [strDone addAttribute:NSFontAttributeName
                    value:(id)[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, [strDone length])];
    // numberType
    NSMutableAttributedString *strNotDone = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(notdone)]];
    [strNotDone addAttribute:NSForegroundColorAttributeName
                       value:(id)XPRGBColor(35,137, 255, 1.0)
                       range:NSMakeRange(0, [strNotDone length])];
    [strNotDone addAttribute:NSFontAttributeName
                       value:(id)[UIFont systemFontOfSize:13]
                       range:NSMakeRange(0, [strNotDone length])];
    
    [atStrNormalType appendAttributedString:strNormal];
    [atStrNormalType appendAttributedString:atstrUnit];
    [atStrNormalType appendAttributedString:atStrDoneType];
    [atStrNormalType appendAttributedString:strDone];
    [atStrNormalType appendAttributedString:atstrUnit];
    [atStrNormalType appendAttributedString:atStrNotDoneType];
    [atStrNormalType appendAttributedString:strNotDone];
    
    return atStrNormalType;
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
                                    NSLog(@"分享失败,错误码:%@,错误描述:%@", @([error errorCode]), [error errorDescription]);
                                }
                            }];
}
@end
