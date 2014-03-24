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

-(void)onNavLeftBtnAction:(id)sender;
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
    // Custom initialization
    self.rootScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.day3View.frame)+100);
    // get weather
    [self getWeatherOfToday];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
}


#pragma mark - navbutton actions 
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AFNetworking
-(void)getWeatherOfToday
{
    NSString* urlFormat = @"http://api.map.baidu.com/telematics/v3/weather";
    //?location=%@&output=json&ak=%@
    NSLog(@"url=%@",urlFormat);
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:@"广州",@"location",@"json",@"output",kBaiduAppKey,@"ak",nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlFormat parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray * results    = [responseObject objectForKey:@"results"];
        NSDictionary* result = [results objectAtIndex:0];
        NSArray * weathers = [result objectForKey:@"weather_data"];
        [self setWeather2Views:weathers];
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
            UILabel* labDate    = [_day1View viewWithTag:100];
            UILabel* labWeather = [_day1View viewWithTag:101];
            UILabel* labTempture= [_day1View viewWithTag:102];
            UIImageView* imageV = [_day1View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }else if(counter == 2)
        {
            UILabel* labDate    = [_day2View viewWithTag:100];
            UILabel* labWeather = [_day2View viewWithTag:101];
            UILabel* labTempture= [_day2View viewWithTag:102];
            UIImageView* imageV = [_day2View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }else if(counter == 3)
        {
            UILabel* labDate    = [_day3View viewWithTag:100];
            UILabel* labWeather = [_day3View viewWithTag:101];
            UILabel* labTempture= [_day3View viewWithTag:102];
            UIImageView* imageV = [_day3View viewWithTag:103];
            
            labDate.text = [dict objectForKey:@"date"];
            labWeather.text = [dict objectForKey:@"weather"];
            labTempture.text = [dict objectForKey:@"temperature"];
            [imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"dayPictureUrl"]]];
        }
        counter ++;
    }
}


@end
