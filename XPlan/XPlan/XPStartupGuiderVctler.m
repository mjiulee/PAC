//
//  XPStartupGuiderVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPStartupGuiderVctler.h"
#import "XPAppDelegate.h"

@interface XPStartupGuiderVctler ()
@property(nonatomic,strong) UIScrollView* contentScrollview;

-(void)initialScrollViewPages;
-(UIView*)initialWeatherPage;  // 天气
-(UIView*)initialCalanderPage; // 星座日历
-(UIView*)initialAutoTaskPage; // 系统自动分发日常任务
@end

@implementation XPStartupGuiderVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
	// Do any additional setup after loading the view.
    UIScrollView* sclview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sclview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sclview.showsVerticalScrollIndicator = NO;
    sclview.showsHorizontalScrollIndicator = NO;
    sclview.pagingEnabled = YES;
    [self.view addSubview:sclview];
    self.contentScrollview = sclview;
    
    [self initialScrollViewPages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - page initial 
-(void)initialScrollViewPages{
    CGFloat xval = 0;
    {
        UIView* pageWeadther = [self initialWeatherPage];
        pageWeadther.frame = CGRectMake(xval, 0, CGRectGetWidth(pageWeadther.frame), CGRectGetHeight(pageWeadther.frame));
        [self.contentScrollview addSubview:pageWeadther];
        xval += CGRectGetWidth(pageWeadther.frame);
    }
    
    {
        UIView* pageCalanderPage = [self initialCalanderPage];
        pageCalanderPage.frame = CGRectMake(xval, 0, CGRectGetWidth(pageCalanderPage.frame), CGRectGetHeight(pageCalanderPage.frame));
        [self.contentScrollview addSubview:pageCalanderPage];
        xval += CGRectGetWidth(pageCalanderPage.frame);
    }
    
    {
        UIView* pageAutoPage = [self initialAutoTaskPage];
        pageAutoPage.frame = CGRectMake(xval, 0, CGRectGetWidth(pageAutoPage.frame), CGRectGetHeight(pageAutoPage.frame));
        [self.contentScrollview addSubview:pageAutoPage];
        xval += CGRectGetWidth(pageAutoPage.frame);
    }
    
    self.contentScrollview.contentSize = CGSizeMake(xval, 0);
}
-(UIView*)initialWeatherPage{
    UIView* weatherview = [[UIView alloc] initWithFrame:self.view.bounds];
    weatherview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:self.view.bounds];
    lab.numberOfLines = 0;
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中\r\n这里显示天气，以及一些提示语";
    lab.textAlignment = NSTextAlignmentCenter;
    [weatherview addSubview:lab];
    return  weatherview;
}
-(UIView*)initialCalanderPage{
    UIView* calanderView = [[UIView alloc] initWithFrame:self.view.bounds];
    calanderView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:self.view.bounds];
    lab.numberOfLines = 0;
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中\r\n这里显示星座、日历，以及一些提示语";
    lab.textAlignment = NSTextAlignmentCenter;
    [calanderView addSubview:lab];
    return  calanderView;
}
-(UIView*)initialAutoTaskPage{
    UIView* autoTaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    autoTaskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:self.view.bounds];
    lab.numberOfLines = 0;
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中\r\n这里自动生成一个日常任务，给用户当做日常进行";
    lab.textAlignment = NSTextAlignmentCenter;
    [autoTaskView addSubview:lab];
    
    // next
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(CGRectGetWidth(autoTaskView.frame) -60-20,
                           CGRectGetHeight(autoTaskView.frame)-44-20,
                           60,44);
    btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [btn setTitle:@"进入应用" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onEnterTaskList:) forControlEvents:UIControlEventTouchUpInside];
    [autoTaskView addSubview:btn];
    return  autoTaskView;
}

#pragma mark - status bar hidden
- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - function 
-(void)onEnterTaskList:(id)sender{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    [app showTaskListDeckVctler];
}


@end
