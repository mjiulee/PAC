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
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "XPCheckBoxTableCell.h"
#import <objc/runtime.h>
#import "XPUserDataHelper.h"

// static Strings
static NSString*  const kBaiduAppKey = @"FC6d7d9088a8bea53220434268c189af";
// static Intergers
static NSUInteger const kHeadViewPageTagStartIdx = 9000;
static NSUInteger const kWeatherElementStartIdx  = 100;
static char kCharCellCheckKey;

@interface XPStartupGuiderVctler ()
<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic) BOOL          scolling2Page;
@property(nonatomic) NSUInteger    pageIndex;
@property(nonatomic,strong) UIScrollView* contentScrollview;
@property(nonatomic,strong) UIView*       headerview;
// weather
@property(nonatomic,strong) UIImageView* imageWeather;
@property(nonatomic,strong) UILabel*     labWeather;
@property(nonatomic,strong) UILabel*     labTemperatureNow;
@property(nonatomic,strong) UILabel*     labTemperatureMin;
@property(nonatomic,strong) UILabel*     labTemperatureMax;
// datas
@property(nonatomic,strong) NSMutableArray* dialyTaskList;
-(void)initialScrollViewPages;
-(UIView*)initialWeatherPage;  // 天气
-(UIView*)initialCalanderPage; // 星座日历
-(UIView*)initialAutoTaskPage; // 系统自动分发日常任务

// data handel
-(void)getDialyTaskList;
@end

@implementation XPStartupGuiderVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray* tmtarray = [[NSMutableArray alloc] init];
        self.dialyTaskList = tmtarray;
        [self getDialyTaskList];
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
    [self getWeatherOfToday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
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
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-180)];
    lab.numberOfLines = 0;
    lab.layer.masksToBounds = YES;
    lab.layer.borderColor= XPRGBColor(157, 157, 157, 1.0).CGColor;
    lab.layer.borderWidth=0.5;
    lab.layer.cornerRadius = 8;
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中\r\n这里今日事宜做啥";
    lab.textAlignment = NSTextAlignmentCenter;
    [weatherview addSubview:lab];
    return  weatherview;
}
-(UIView*)initialCalanderPage{
    UIView* calanderView = [[UIView alloc] initWithFrame:self.view.bounds];
    calanderView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-180)];
    lab.numberOfLines = 0;
    lab.layer.borderColor= XPRGBColor(157, 157, 157, 1.0).CGColor;
    lab.layer.borderWidth=0.5;
    lab.layer.cornerRadius = 8;
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中\r\n这里显示星座、日历，以及一些提示语";
    lab.textAlignment = NSTextAlignmentCenter;
    [calanderView addSubview:lab];
    return  calanderView;
}
-(UIView*)initialAutoTaskPage{
    UIView* autoTaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    autoTaskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, CGRectGetWidth(self.view.frame)-20, 15)];
    lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lab.text = @"选择几个日常任务任务吧";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textAlignment = NSTextAlignmentLeft;
    [autoTaskView addSubview:lab];
 
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 200, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-244)
                                                          style:UITableViewStylePlain];
    tableview.layer.borderColor = XPRGBColor(157, 157, 157, 1.0).CGColor;
    tableview.layer.borderWidth = 0.5;
    tableview.layer.cornerRadius= 4;
    tableview.rowHeight  = 50;
    tableview.delegate   = self;
    tableview.dataSource = self;
    tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableview.separatorInset   = UIEdgeInsetsZero;
    [autoTaskView addSubview:tableview];
    
    // next
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(CGRectGetWidth(autoTaskView.frame) -60-20,
                           CGRectGetHeight(autoTaskView.frame)-44-5,60,44);
    btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [btn setTitle:@"进入应用" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onEnterTaskList:) forControlEvents:UIControlEventTouchUpInside];
    [autoTaskView addSubview:btn];
    return  autoTaskView;
}

-(UIView*)getHeaderView
{
    UIView*headerview   = [[UIView alloc] initWithFrame:CGRectMake(10,10, CGRectGetWidth(self.view.frame)*2-20,150)];
    headerview.backgroundColor   = [UIColor whiteColor];
    headerview.layer.shadowColor = XPRGBColor(57, 57, 57, 1.0).CGColor;
    headerview.layer.shadowOffset= CGSizeMake(1.0, 1.0);
    headerview.layer.shadowOpacity = 0.5;
    headerview.layer.shadowPath  = [UIBezierPath bezierPathWithRect:headerview.bounds].CGPath;

    for (NSUInteger i=0 ; i < 4; i ++) {
        UIView* pagev = [self getHeaderviewPage:i];
        pagev.tag = kHeadViewPageTagStartIdx + i;
        [headerview addSubview:pagev];
    }
    return headerview;
}

-(UIView*)getHeaderviewPage:(NSUInteger)pageIndex{
    UIView* pageview = [[UIView alloc] init];
    CGFloat pagewidth= (CGRectGetWidth(self.view.frame)*2-20)/4;
    CGFloat xval = pagewidth*pageIndex;
    CGFloat yval = 0;
    //  pageview.backgroundColor = [UIColor grayColor];
    pageview.frame = CGRectMake(xval, yval,pagewidth,150);
    {
        // city:
        NSUInteger atag   = kWeatherElementStartIdx;
        CGFloat    yoffset= 10;
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,20)];
            //lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.text = @"广州";
            lab.tag  = atag++;
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:lab];
            yoffset += CGRectGetHeight(lab.frame);
        }
        // 日期:
        {
            UILabel* labDate = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,36)];
            //labDate.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            labDate.tag  = atag++;
            labDate.numberOfLines = 2;
            labDate.text = [[NSDate date] localeFormattedDateString];
            labDate.font = [UIFont systemFontOfSize:15];
            labDate.textColor = XPRGBColor(27, 57, 57, 1.0);
            labDate.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:labDate];
            yoffset += CGRectGetHeight(labDate.frame);
            //[labDate sizeToFit];
        }
        // 天气情况:
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,30)];
            //lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.tag  = atag++;
            lab.text = @"晴";
            lab.font = [UIFont systemFontOfSize:16];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:lab];
            [lab sizeToFit];
            yoffset += CGRectGetHeight(lab.frame);
            
            UIImageView* weatherimg = [[UIImageView alloc] init];
            weatherimg.frame = CGRectMake(CGRectGetMaxX(lab.frame)+2,
                                          CGRectGetMinY(lab.frame)+(CGRectGetHeight(lab.frame)-15)/2,21,15);
            weatherimg.tag  = atag++;
            [pageview addSubview:weatherimg];
        }
        // 摄氏度：
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,26)];
            //lab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            lab.tag  = atag++;
            lab.text = @"23'C";
            lab.font = [UIFont fontWithName:@"Snell Roundhand" size:26];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:lab];
        }
    }
    return pageview;
}

-(void)setWeatherToUIElement:(NSArray*)weatherArray
{
    for (NSUInteger i = 0;  i < 4; i ++) {
        UIView* tweatherv = [self.headerview viewWithTag:kHeadViewPageTagStartIdx + i];
        //UILabel* city   = (UILabel*)[tweatherv viewWithTag:kWeatherElementStartIdx+0];
        UILabel* date   = (UILabel*)[tweatherv viewWithTag:kWeatherElementStartIdx+1];
        UILabel*weather = (UILabel*)[tweatherv viewWithTag:kWeatherElementStartIdx+2];
        UIImageView* weatherimg = (UIImageView*)[tweatherv viewWithTag:kWeatherElementStartIdx+3];
        UILabel* temp   = (UILabel*)[tweatherv viewWithTag:kWeatherElementStartIdx+4];

        NSDictionary* weatherDict = [weatherArray objectAtIndex:i];
        [date setText:[weatherDict objectForKey:@"date"]];
        [date sizeToFit];
        [weather setText:[weatherDict objectForKey:@"weather"]];
        [weather sizeToFit];
        weatherimg.frame = CGRectMake(CGRectGetMaxX(weather.frame)+2,weatherimg.frame.origin.y,21,15);
        [weatherimg setImageWithURL:[NSURL URLWithString:[weatherDict objectForKey:@"dayPictureUrl"]]];
        [temp setText:[weatherDict objectForKey:@"temperature"]];
    }
}


#pragma mark - UItableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.dialyTaskList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid = @"autotaskcell";
    XPCheckBoxTableCell *cell = (XPCheckBoxTableCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[XPCheckBoxTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    DiaryTaskModel* task = [self.dialyTaskList objectAtIndex:[indexPath row]];
    [cell setDialyTask:task];
    NSString* ifcheck = (NSString*)objc_getAssociatedObject(task ,&kCharCellCheckKey);
    if (ifcheck == nil){
        [cell setCheck:NO];
    }else {
        [cell setCheck:YES];
    }
    return cell;
}

#pragma mark- tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XPCheckBoxTableCell* cell = (XPCheckBoxTableCell* )[tableView cellForRowAtIndexPath:indexPath];
    DiaryTaskModel* task = [self.dialyTaskList objectAtIndex:[indexPath row]];
    NSString* ifcheck = (NSString*)objc_getAssociatedObject(task ,&kCharCellCheckKey);
    if (ifcheck == nil)
    {
        NSString *ifcheck = @"check";
        objc_setAssociatedObject(task,&kCharCellCheckKey,ifcheck, OBJC_ASSOCIATION_RETAIN);
        [cell setCheck:YES];
    }else
    {
        objc_setAssociatedObject(task,&kCharCellCheckKey,nil, OBJC_ASSOCIATION_RETAIN);
        [cell setCheck:NO];
    }
}

#pragma makr - dataHandel
-(void)getDialyTaskList
{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSDate* today  = [NSDate date];
    NSArray * tary = [app.coreDataMgr queryDialyTask:[today weekday]];
    if (tary && [tary count]) {
        [self.dialyTaskList setArray:tary];
    }
    for (DiaryTaskModel* task in self.dialyTaskList) {
        NSLog(@"task.weakday=%@",task.weekday);
    }
}

#pragma mark - function 
-(void)onEnterTaskList:(id)sender{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    
    for (DiaryTaskModel* task in self.dialyTaskList)
    {
        NSString* ifcheck = (NSString*)objc_getAssociatedObject(task ,&kCharCellCheckKey);
        if (ifcheck != nil)
        {
            XPTaskPriorityLevel priority = XPTask_PriorityLevel_normal;
            [app.coreDataMgr insertTask:task.content
                                   date:[NSDate date]
                                   type:XPTask_Type_User
                                prLevel:priority
                                project:nil];
        }
    }
    [app showTaskListDeckVctler];
}

#pragma mark -  UIScrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollview) {
        CGRect headframe   = CGRectMake(10,10, CGRectGetWidth(self.view.frame)*2-20,150);
        headframe.origin.x+= scrollView.contentOffset.x/2;
        //NSLog(@"contentOffset.x=%.2f,headframe.x=%.2f",scrollView.contentOffset.x,headframe.origin.x);
        _headerview.frame  = headframe;
        NSUInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        self.pageIndex = page;
    }
}

#pragma mark - AFNetworking
-(void)getWeatherOfToday
{
    NSString* str = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_WeatherCity];
    if (!str) {
        str= @"广州市";
        [[XPUserDataHelper shareInstance] setUserDataByKey:XPUserDataKey_WeatherCity value:str];
    }
    
    NSString* urlFormat = @"http://api.map.baidu.com/telematics/v3/weather";
    //?location=%@&output=json&ak=%@
    NSLog(@"url=%@",urlFormat);
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"location",@"json",@"output",kBaiduAppKey,@"ak",nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlFormat parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray * results    = [responseObject objectForKey:@"results"];
        NSDictionary* result = [results objectAtIndex:0];
        NSArray * weathers = [result objectForKey:@"weather_data"];
        [self setWeatherToUIElement:weathers];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
