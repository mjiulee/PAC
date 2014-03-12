//
//  XPStartupGuiderVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPStartupGuiderVctler.h"
#import "XPAppDelegate.h"
#import "NSDate+Category.h"

@interface XPStartupGuiderVctler ()
<UIScrollViewDelegate>
{
}
@property(nonatomic,strong) UIScrollView* contentScrollview;
@property(nonatomic,strong) UIView*       headerview;

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
    sclview.delegate      = self;
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
        //pageWeadther.backgroundColor = XPRGBColor(128, 128, 128, 1.0);
        [self.contentScrollview addSubview:pageWeadther];
        xval += CGRectGetWidth(pageWeadther.frame);
    }
    
    {
        UIView* pageCalanderPage = [self initialCalanderPage];
        pageCalanderPage.frame = CGRectMake(xval, 0, CGRectGetWidth(pageCalanderPage.frame), CGRectGetHeight(pageCalanderPage.frame));
        //pageCalanderPage.backgroundColor = XPRGBColor(128, 28, 128, 1.0);
        [self.contentScrollview addSubview:pageCalanderPage];
        xval += CGRectGetWidth(pageCalanderPage.frame);
    }
    
    {
        UIView* pageAutoPage = [self initialAutoTaskPage];
        pageAutoPage.frame = CGRectMake(xval, 0, CGRectGetWidth(pageAutoPage.frame), CGRectGetHeight(pageAutoPage.frame));
        //pageAutoPage.backgroundColor = XPRGBColor(128, 128, 28, 1.0);
        [self.contentScrollview addSubview:pageAutoPage];
        xval += CGRectGetWidth(pageAutoPage.frame);
    }
    self.contentScrollview.contentSize = CGSizeMake(xval, 0);
    
    // 把headerview 浮动在scrollview上
    {
        _headerview = [self getHeaderView];
        [self.contentScrollview addSubview:_headerview];
    }
}
-(UIView*)initialWeatherPage{
    UIView* weatherview = [[UIView alloc] initWithFrame:self.view.bounds];
    weatherview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    /*
    UIView*headerview   = [[UIView alloc] initWithFrame:CGRectMake(10,10, CGRectGetWidth(weatherview.frame)-20,200)];
    headerview.backgroundColor   = [UIColor whiteColor];
    headerview.layer.shadowColor = XPRGBColor(57, 57, 57, 1.0).CGColor;
    headerview.layer.shadowOffset= CGSizeMake(1.0, 1.0);
    headerview.layer.shadowOpacity = 0.5;
    headerview.layer.shadowPath  = [UIBezierPath bezierPathWithRect:headerview.bounds].CGPath;
    //headerview.backgroundColor = XPRGBColor(157, 157, 157, 1.0);
    {
        // city:
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,10,CGRectGetWidth(headerview.frame)-40,20)];
            lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"广州";
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentCenter;
            [headerview addSubview:lab];
        }
        // 日期:
        {
            UILabel* labDate = [[UILabel alloc] initWithFrame:CGRectMake(20,30,CGRectGetWidth(headerview.frame)-40,30)];
            labDate.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            
            labDate.text = [[NSDate date] localeFormattedDateString];
            labDate.font = [UIFont fontWithName:@"Snell Roundhand" size:25];
            labDate.textColor = XPRGBColor(27, 57, 57, 1.0);
            labDate.textAlignment = NSTextAlignmentCenter;
            [headerview addSubview:labDate];
        }
        // 天气情况:
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,65,80,20)];
            lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"晴";
            lab.font = [UIFont systemFontOfSize:20];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:lab];
        }
        {
            UILabel* labup = [[UILabel alloc] initWithFrame:CGRectMake(20,90,60,20)];
            labup.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            labup.text = @"↑ 18'c";
            labup.font = [UIFont systemFontOfSize:15];
            labup.textColor = XPRGBColor(27, 57, 57, 1.0);
            labup.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:labup];
            
            UILabel* labdown = [[UILabel alloc] initWithFrame:CGRectMake(85,90,60,20)];
            labdown.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            labdown.text = @"↓12'c";
            labdown.font = [UIFont systemFontOfSize:15];
            labdown.textColor = XPRGBColor(27, 57, 57, 1.0);
            labdown.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:labdown];
        }
        // 摄氏度：
        {
            
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 110,
                                                                     CGRectGetWidth(headerview.frame)-40,56)];
            lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"23'C";
            lab.font = [UIFont fontWithName:@"Snell Roundhand" size:56];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:lab];
        }
        // 天气列表 TODO:
    }
    [weatherview addSubview:headerview];
    */
    
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

-(UIView*)getHeaderView
{
    UIView*headerview   = [[UIView alloc] initWithFrame:CGRectMake(10,10, CGRectGetWidth(self.view.frame)-20,200)];
    headerview.backgroundColor   = [UIColor whiteColor];
    headerview.layer.shadowColor = XPRGBColor(57, 57, 57, 1.0).CGColor;
    headerview.layer.shadowOffset= CGSizeMake(1.0, 1.0);
    headerview.layer.shadowOpacity = 0.5;
    headerview.layer.shadowPath  = [UIBezierPath bezierPathWithRect:headerview.bounds].CGPath;
    //headerview.backgroundColor = XPRGBColor(157, 157, 157, 1.0);
    {
        // city:
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,10,CGRectGetWidth(headerview.frame)-40,20)];
            lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"广州";
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentCenter;
            [headerview addSubview:lab];
        }
        // 日期:
        {
            UILabel* labDate = [[UILabel alloc] initWithFrame:CGRectMake(20,30,CGRectGetWidth(headerview.frame)-40,30)];
            labDate.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            
            labDate.text = [[NSDate date] localeFormattedDateString];
            labDate.font = [UIFont fontWithName:@"Snell Roundhand" size:25];
            labDate.textColor = XPRGBColor(27, 57, 57, 1.0);
            labDate.textAlignment = NSTextAlignmentCenter;
            [headerview addSubview:labDate];
        }
        // 天气情况:
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,65,80,20)];
            lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"晴";
            lab.font = [UIFont systemFontOfSize:20];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:lab];
        }
        {
            UILabel* labup = [[UILabel alloc] initWithFrame:CGRectMake(20,90,60,20)];
            labup.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            labup.text = @"↑ 18'c";
            labup.font = [UIFont systemFontOfSize:15];
            labup.textColor = XPRGBColor(27, 57, 57, 1.0);
            labup.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:labup];
            
            UILabel* labdown = [[UILabel alloc] initWithFrame:CGRectMake(85,90,60,20)];
            labdown.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            labdown.text = @"↓12'c";
            labdown.font = [UIFont systemFontOfSize:15];
            labdown.textColor = XPRGBColor(27, 57, 57, 1.0);
            labdown.textAlignment = NSTextAlignmentLeft;
            [headerview addSubview:labdown];
        }
    }
    return headerview;
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

#pragma mark -  UIScrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect headframe   = CGRectMake(10,10, CGRectGetWidth(self.view.frame)-20,200);
    headframe.origin.x+= scrollView.contentOffset.x/2;
    NSLog(@"contentOffset.x=%.2f,headframe.x=%.2f",scrollView.contentOffset.x,headframe.origin.x);
    _headerview.frame  = headframe;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        //NSLog(@"contentOffset.x=%.2f",scrollView.contentOffset.x);
        CGRect headframe   = CGRectMake(10,10, CGRectGetWidth(self.view.frame)-20,200);
        [UIView animateWithDuration:0.35 animations:^(){
            _headerview.frame  = headframe;
        }];
    }
}


@end
