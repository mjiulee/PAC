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
#import "PNChart.h"

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
    
    UIView* framev = [[UIView alloc] initWithFrame:CGRectMake(10, 170, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-180)];
    framev.layer.masksToBounds = YES;
    framev.layer.borderColor  = XPRGBColor(157, 157, 157, 1.0).CGColor;
    framev.layer.borderWidth  =0.5;
    framev.layer.cornerRadius = 8;
    framev.autoresizingMask   = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    {
        UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(framev.frame),30)];
        labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        labtitle.text = @"警世名言-每天念一遍";
        labtitle.textColor = XPRGBColor(35, 135, 255, 1.0);
        labtitle.font = [UIFont systemFontOfSize:16];
        labtitle.textAlignment = NSTextAlignmentCenter;
        labtitle.backgroundColor = XPRGBColor(220,220,220,0.78);
        [framev addSubview:labtitle];

        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(80,60,CGRectGetWidth(framev.frame)-90,138)];
        //lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lab.numberOfLines = 0;
        lab.text      = @"一年之计在于春，\r一生之计在于勤，\r一日之计在于寅。\r春若不耕，秋无所望；\r寅若不起，日无所办；\r少若不勤，老无所归。";
        lab.textColor = XPRGBColor(27, 57, 57, 1.0);
        lab.font = [UIFont systemFontOfSize:18];
        lab.textAlignment = NSTextAlignmentLeft;
        [framev addSubview:lab];
        
        UILabel* lab2 = [[UILabel alloc] initWithFrame:CGRectMake(40,CGRectGetMaxY(lab.frame)+10,CGRectGetWidth(framev.frame)-90,50)];
        //lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lab2.text      = @"--《白兔记.牧牛》";
        lab2.textColor = XPRGBColor(35, 135, 255, 1.0);
        lab2.font = [UIFont systemFontOfSize:15];
        lab2.textAlignment = NSTextAlignmentRight;
        [framev addSubview:lab2];
    }
    
    [weatherview addSubview:framev];
    return  weatherview;
}
-(UIView*)initialCalanderPage{
    UIView* calanderView = [[UIView alloc] initWithFrame:self.view.bounds];
    calanderView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    CGFloat yof = 170+((CGRectGetHeight(self.view.frame)-180)-(CGRectGetWidth(self.view.frame)-20))/2;
    UIView* cycleView = [[UIView alloc] initWithFrame:CGRectMake(10, yof, CGRectGetWidth(self.view.frame)-20,CGRectGetWidth(self.view.frame)-20)];
    cycleView.layer.borderColor= XPRGBColor(157, 157, 157, 1.0).CGColor;
    cycleView.layer.borderWidth =0.5;
    cycleView.layer.cornerRadius= 8;
    cycleView.clipsToBounds     = YES;
    cycleView.autoresizingMask  = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    /// data prepare
    NSDate* yestoday = [[NSDate date] dateBySubtractingDays:1];
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSUInteger normal_ongoing=0,normal_done=0;
    NSUInteger important_ongoing=0,important_done=0;
    NSUInteger all_total =0,all_done=0,all_notdone = 0;
    {
        // 普通
        normal_ongoing = [app.coreDataMgr taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        normal_done    = [app.coreDataMgr taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        important_ongoing=[app.coreDataMgr taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        important_done   =[app.coreDataMgr taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_important status:XPTask_Status_Done];
        // 全部
       all_total   = (normal_done+normal_ongoing+important_done+important_ongoing);
       all_done    = normal_done+important_done;
       all_notdone = normal_ongoing+important_ongoing;
    }
    {
        UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(cycleView.frame),30)];
        labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        labtitle.text = @"昨天任务完成情况";
        labtitle.textColor = XPRGBColor(35, 135, 255, 1.0);
        labtitle.font = [UIFont systemFontOfSize:16];
        labtitle.textAlignment = NSTextAlignmentCenter;
        labtitle.backgroundColor = XPRGBColor(220,220,220,0.78);
        [cycleView addSubview:labtitle];
        
        CGFloat fpercent = 0.0;
        if (all_total > 0) {
            fpercent = (normal_done+important_done)/all_total;
        }
        PNCircleChart * circleChart
        = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,30,CGRectGetWidth(cycleView.frame),130)
                                      andTotal:[NSNumber numberWithInt:1]
                                    andCurrent:[NSNumber numberWithFloat:fpercent]];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart strokeChart];
        [cycleView addSubview:circleChart];
    }
    
    {
        CGFloat yof = cycleView.frame.size.height - 80;
        for(int i = 0;i < 3;i++)
        {
            UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(40,yof,CGRectGetWidth(cycleView.frame)-80,20)];
            labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (i == 0) {
                labtitle.text = [NSString stringWithFormat:@"普通：%u条，已完成：%u条，未完成：%u",normal_done+normal_ongoing,normal_done,normal_ongoing];
            }else if(i==1){
                labtitle.text = [NSString stringWithFormat:@"重要：%u条，已完成：%u条，未完成：%u",important_ongoing+important_done,important_done,important_ongoing];
            }else{
                labtitle.text = [NSString stringWithFormat:@"全部：%u条，已完成：%u条，未完成：%u",all_total,all_done,all_notdone];
            }
            labtitle.textColor = XPRGBColor(157,157,157, 1.0);
            labtitle.font = [UIFont systemFontOfSize:13];
            labtitle.textAlignment   = NSTextAlignmentLeft;
            labtitle.backgroundColor = kClearColor;
            [cycleView addSubview:labtitle];
            yof +=25;
        }
    }
    
    [calanderView addSubview:cycleView];
    return  calanderView;
}
-(UIView*)initialAutoTaskPage{
    UIView* autoTaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    autoTaskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 170, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-215)
                                                          style:UITableViewStylePlain];
    tableview.layer.borderColor = XPRGBColor(157, 157, 157, 1.0).CGColor;
    tableview.layer.borderWidth = 0.5;
    tableview.layer.cornerRadius= 4;
    tableview.rowHeight  = 50;
    tableview.delegate   = self;
    tableview.dataSource = self;
    tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableview.separatorInset   = UIEdgeInsetsZero;
    tableview.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [autoTaskView addSubview:tableview];
    
    // next
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(CGRectGetWidth(autoTaskView.frame) -80-20,
                           CGRectGetHeight(autoTaskView.frame)-30-5,80,30);
    btn.layer.borderColor = XPRGBColor(25, 133, 255, 1.0).CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius= 4;
    btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
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
            lab.text = @"广州";
            lab.tag  = atag++;
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:lab];
            yoffset += CGRectGetHeight(lab.frame)+5;
        }
        // 日期:
        {
            UILabel* labDate = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,36)];
            labDate.tag  = atag++;
            labDate.numberOfLines = 2;
            labDate.text = [[[NSDate date] dateByAddingDays:pageIndex] localeFormattedDateString];
            labDate.font = [UIFont systemFontOfSize:15];
            labDate.textColor = XPRGBColor(27, 57, 57, 1.0);
            labDate.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:labDate];
            yoffset += CGRectGetHeight(labDate.frame);
            //[labDate sizeToFit];
        }
        // 天气情况:
        {
            yoffset  = 80;
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,30)];
            lab.tag  = atag++;
            lab.text = @"晴";
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = XPRGBColor(27, 57, 57, 1.0);
            lab.textAlignment = NSTextAlignmentLeft;
            [pageview addSubview:lab];
            [lab sizeToFit];
            yoffset += CGRectGetHeight(lab.frame)+5;
            
            UIImageView* weatherimg = [[UIImageView alloc] init];
            weatherimg.frame = CGRectMake(CGRectGetMaxX(lab.frame)+2,
                                          CGRectGetMinY(lab.frame)+(CGRectGetHeight(lab.frame)-15)/2,21,15);
            weatherimg.tag  = atag++;
            [pageview addSubview:weatherimg];
        }
        // 摄氏度：
        {
            UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(20,yoffset,pagewidth-40,26)];
            lab.tag  = atag++;
            lab.text = @"23'C";
            lab.font = [UIFont systemFontOfSize:22];
            lab.textColor = XPRGBColor(35, 135,255, 1.0);
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
        [date    setText:[weatherDict objectForKey:@"date"]];
        [date    sizeToFit];
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
    NSString*taskContent = [self.dialyTaskList objectAtIndex:[indexPath row]];
    [cell setDialyTaskContent:taskContent];
    NSString* ifcheck = (NSString*)objc_getAssociatedObject(taskContent ,&kCharCellCheckKey);
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
    NSString*taskContent = [self.dialyTaskList objectAtIndex:[indexPath row]];
    NSString* ifcheck = (NSString*)objc_getAssociatedObject(taskContent ,&kCharCellCheckKey);
    if (ifcheck == nil)
    {
        NSString *ifcheck = @"check";
        objc_setAssociatedObject(taskContent,&kCharCellCheckKey,ifcheck, OBJC_ASSOCIATION_RETAIN);
        [cell setCheck:YES];
    }else
    {
        objc_setAssociatedObject(taskContent,&kCharCellCheckKey,nil, OBJC_ASSOCIATION_RETAIN);
        [cell setCheck:NO];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc] initWithFrame:CGRectZero];
    headview.autoresizingMask= UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    headview.backgroundColor = XPRGBColor(220,220,220, 0.78);
    
    UILabel* sectionTItle = [UILabel new];
    sectionTItle.frame    = CGRectMake(0, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.backgroundColor = kClearColor;
    sectionTItle.font       = [UIFont systemFontOfSize:15];
    sectionTItle.textColor  = XPRGBColor(25, 133, 255, 1.0);
    sectionTItle.text = @"新的一天，来完成几个日常事项吧";
    sectionTItle.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:sectionTItle];
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


#pragma makr - dataHandel
-(void)getDialyTaskList
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"resource/systemtask"
                                                   ofType:@"plist"];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDate* today = [NSDate date];
    NSArray* todayTask = [dict objectForKey:[NSString stringWithFormat:@"%d",today.weekday]];
    if (todayTask && [todayTask count]) {
        [self.dialyTaskList setArray:todayTask];
    }
}

#pragma mark - function 
-(void)onEnterTaskList:(id)sender{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    
    for (NSString* task in self.dialyTaskList)
    {
        NSString* ifcheck = (NSString*)objc_getAssociatedObject(task ,&kCharCellCheckKey);
        if (ifcheck != nil)
        {
            XPTaskPriorityLevel priority = XPTask_PriorityLevel_normal;
            [app.coreDataMgr insertTask:task
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
