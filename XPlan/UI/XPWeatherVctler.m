//
//  XPWeatherVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPWeatherVctler.h"
#import "NSDate+Category.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "CityListViewController.h"

static NSString*  const kBaiduAppKey = @"FC6d7d9088a8bea53220434268c189af";

@interface XPWeatherVctler ()
@property(nonatomic,strong)IBOutlet UIScrollView* rootScrollview;
@property(nonatomic,strong)IBOutlet UILabel* labTemperatureMax;
@property(nonatomic,strong)IBOutlet UILabel* labWeekday;
@property(nonatomic,strong)IBOutlet UILabel* labWeather;
@property(nonatomic,strong)IBOutlet UIImageView* imgweather;

@property(nonatomic,strong)IBOutlet UIView* day1View;
@property(nonatomic,strong)IBOutlet UIView* day2View;
@property(nonatomic,strong)IBOutlet UIView* day3View;
@property(nonatomic,strong)NSString* szcity;
@property(nonatomic,strong)UIButton* rightNavBtn;

@property(nonatomic,strong)IBOutlet UILabel* areaNotSuport;

@end

@implementation XPWeatherVctler

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"天气情况";
    self.view.backgroundColor = [UIColor whiteColor];
    // Custom initialization
    NSString* str = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_WeatherCity];
    if (!str) {
        str= @"广州";
    }
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:XPRGBColor(25, 133, 255, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onCityBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.rightNavBtn = btn;
    // set content size
    self.rootScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.day3View.frame)+60);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BOOL needToReload = NO;
    NSString* str = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_WeatherCity];
    if (!str) {
        str= @"广州";
    }
    
    if (!self.szcity)
    {
        self.szcity  = str;
        needToReload = YES;
    }else if (NO == [str isEqualToString:self.szcity])
    {
        self.szcity = str;
        needToReload = YES;
    }
    if (needToReload) {
        [self.rightNavBtn setTitle:self.szcity forState:UIControlStateNormal];
        [self getWeatherOfToday];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
}


#pragma mark - navbutton actions 
-(void)onCityBtnSelect:(id)sender
{
    CityListViewController* citypickervc = [[CityListViewController alloc] init];
    [self.navigationController pushViewController:citypickervc animated:YES];
    //[self showPickerView];
}

#pragma mark - AFNetworking
-(void)getWeatherOfToday
{
    NSString* urlFormat = @"http://api.map.baidu.com/telematics/v3/weather";
    //?location=%@&output=json&ak=%@
    NSLog(@"url=%@",urlFormat);
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:self.szcity,@"location",@"json",@"output",kBaiduAppKey,@"ak",nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlFormat parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        id error = [responseObject objectForKey:@"error"];
        if ([error integerValue] != 0)
        {
            self.rootScrollview.hidden = YES;
            self.areaNotSuport.hidden = NO;
        }else
        {
            self.rootScrollview.hidden = NO;
            self.areaNotSuport.hidden = YES;
            NSArray * results    = [responseObject objectForKey:@"results"];
            NSDictionary* result = [results objectAtIndex:0];
            NSArray * weathers = [result objectForKey:@"weather_data"];
            [self setWeather2Views:weathers];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)setWeather2Views:(NSArray*)arry
{
    NSUInteger counter = 0;
    for (NSDictionary* dict in arry) {
        if (counter == 0)
        {
            self.labTemperatureMax.text = [dict objectForKey:@"temperature"];
            self.labWeekday.text = [dict objectForKey:@"date"];
            self.labWeather.text = [dict objectForKey:@"weather"];
            [self.imgweather setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }else if(counter == 1)
        {
            UILabel* labDate    = (UILabel* )[_day1View viewWithTag:100];
            UILabel* labWeather = (UILabel* )[_day1View viewWithTag:101];
            UILabel* labTempture= (UILabel* )[_day1View viewWithTag:102];
            UIImageView* imageV = (UIImageView* )[_day1View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }else if(counter == 2)
        {
            UILabel* labDate    = (UILabel* )[_day2View viewWithTag:100];
            UILabel* labWeather = (UILabel* )[_day2View viewWithTag:101];
            UILabel* labTempture= (UILabel* )[_day2View viewWithTag:102];
            UIImageView* imageV = (UIImageView* )[_day2View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }else if(counter == 3)
        {
            UILabel* labDate    = (UILabel* )[_day3View viewWithTag:100];
            UILabel* labWeather = (UILabel* )[_day3View viewWithTag:101];
            UILabel* labTempture= (UILabel* )[_day3View viewWithTag:102];
            UIImageView* imageV = (UIImageView* )[_day3View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }
        counter ++;
    }
}

@end
