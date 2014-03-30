//
//  XPDialyStaticVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDialyStaticVCtler.h"
#import "PNChart.h"
#import "XPAppDelegate.h"

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
    self.title = @"任务统计";
	// Do any additional setup after loading the view.
    // nav left
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0,-10, 0, 0)];
    [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //self.view.backgroundColor = [UIColor redColor];
    
    CGFloat yvalstart     = 0;//CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIScrollView* sclview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yvalstart,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-yvalstart)];
    sclview.showsVerticalScrollIndicator  = NO;
    sclview.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
    sclview.showsHorizontalScrollIndicator= NO;
    sclview.pagingEnabled  = YES;
    sclview.delegate       = (id<UIScrollViewDelegate>)self;
    [self.view addSubview:sclview];
    self.contentScrollview = sclview;
    self.contentScrollview.contentSize = CGSizeMake(CGRectGetWidth(sclview.frame)*2, 0);
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
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    if (self.date2Statistic) {
        // 普通
        _normalOngoing = [app.coreDataMgr taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        _normalDone    = [app.coreDataMgr taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        _importantOngoing=[app.coreDataMgr taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        _importantDone   =[app.coreDataMgr taskCoutByDay:self.date2Statistic prLevel:XPTask_PriorityLevel_important status:XPTask_Status_Done];
        // 全部
        _allTotal   = (_normalDone+_normalOngoing+_importantDone+_importantOngoing);
        _allDone    = _normalDone+_importantDone;
        _allOngoing = _normalOngoing+_importantOngoing;
    }else{
        // 普通
        _normalOngoing = [app.coreDataMgr  getHistoryTaskCount:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        _normalDone    = [app.coreDataMgr  getHistoryTaskCount:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        _importantOngoing=[app.coreDataMgr getHistoryTaskCount:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        _importantDone   =[app.coreDataMgr getHistoryTaskCount:XPTask_PriorityLevel_important status:XPTask_Status_Done];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    if (self.pageIndex != page) {
        self.pageIndex = page;
        [self setPageView:self.pageIndex];
    }
}

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
            /*UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(cycleView.frame),30)];
            labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            labtitle.text = @"今天的任务完成情况";
            labtitle.textColor = XPRGBColor(35, 135, 255, 1.0);
            labtitle.font = [UIFont systemFontOfSize:16];
            labtitle.textAlignment = NSTextAlignmentCenter;
            labtitle.backgroundColor = XPRGBColor(220,220,220,0.78);
            [cycleView addSubview:labtitle];*/
            
            CGFloat fpercent = 0.0;
            if (_allTotal > 0) {
                fpercent = (_normalDone+_importantDone)*1.0/_allTotal;
            }
            PNCircleChart * circleChart
            = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,40,CGRectGetWidth(cycleView.frame),130)
                                          andTotal:[NSNumber numberWithInt:1]
                                        andCurrent:[NSNumber numberWithFloat:fpercent]];
            circleChart.backgroundColor = [UIColor clearColor];
            [circleChart setStrokeColor:PNGreen];
            [circleChart strokeChart];
            [cycleView addSubview:circleChart];
        }
        
        {
            CGFloat yof = cycleView.frame.size.height - 100;
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
    }else if(page == 1)
    {
        UIView* tview = [self.contentScrollview viewWithTag:kScrollViewPageIndex+page];
        if(tview == nil){
            tview = [[UIView alloc] initWithFrame:CGRectMake(10.0+page*CGRectGetWidth(self.contentScrollview.frame),10.0,
                                                             CGRectGetWidth(self.contentScrollview.frame)-20,
                                                             CGRectGetHeight(self.contentScrollview.frame)-20)];
            tview.layer.borderColor= XPRGBColor(157, 157, 157, 1.0).CGColor;
            tview.layer.borderWidth =0.5;
            tview.layer.cornerRadius= 8;
            tview.clipsToBounds     = YES;
            tview.tag = kScrollViewPageIndex+page;
            tview.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
            [self.contentScrollview addSubview:tview];
        }
        
        [[tview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat fpercent = 0.0;
        if (_allTotal > 0) {
            fpercent = (_normalDone+_importantDone)/_allTotal;
        }
        NSString* brief  = @"";
        if (fpercent < 0.1) {
            brief = @"妈蛋，今天你不用干活吗？\r这效率吃屎都抢不过别人啊.\r亲，你这么懒，你爸妈知道不？";
        }else if(fpercent < 0.5){
            brief = @"妈蛋，一天的活才做不到一半.\r亲，你这么混日子,\r还想迎娶高富帅/嫁个白富美不？\r还想就滚回去干活!";
        }else if(fpercent < 0.8){
            brief = @"哎呦，效率不错嘛，亲.\r再接再厉，本屌看好你哦！";
        }else if(fpercent < 0.95){
            brief = @"我插咧，效率爆表啊，亲.\r你这是发粪图强，努力上进，不久当上CEO，迎娶白富美，走向人生巅峰的节奏吗?";
        }else {
            brief = @"我插咧，效率报表啊，亲。\r你这是发粪图强,粪力上进,努力当上CEO,迎娶白富美,走向人生巅峰的节奏吗?";
        }
        
        UILabel* labEmpty = [[UILabel alloc] init];
        labEmpty.font  = [UIFont systemFontOfSize:15];
        labEmpty.textAlignment = NSTextAlignmentCenter;
        labEmpty.numberOfLines = 0;
        if ([UIDevice isRunningOniPhone5]) {
            labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame));
        }else{
            labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame));
        }
        labEmpty.text = brief;
        labEmpty.textColor= XPRGBColor(157,157, 157, 1.0);
        [tview addSubview:labEmpty];
    }
}


@end
