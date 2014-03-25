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

@property(nonatomic,strong)IBOutlet UIView* ViewForPicker;
@property(nonatomic,strong)IBOutlet UIPickerView* cityPicker;
@property(nonatomic)       BOOL showingPicker;

-(void)hiddenPickerView;
-(void)showPickerView;

-(IBAction)cancel:(id)sender;
-(IBAction)selectOk:(id)sender;

@end

@implementation XPWeatherVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showingPicker = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"天气情况";
    // Custom initialization
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onCityBtnSelect:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
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
#pragma mark - pickerview
-(void)hiddenPickerView
{
    if (NO == [self.ViewForPicker isDescendantOfView:self.view])
    {
        return;
    }
    
    if (self.showingPicker == NO) {
        return;
    }
    [UIView animateWithDuration:0.35 animations:^()
    {
        self.showingPicker = NO;
        self.ViewForPicker.frame
        = CGRectMake(0, self.view.frame.size.height,self.ViewForPicker.frame.size.width, self.ViewForPicker.frame.size.height);
    }completion:^(BOOL finished){
        [self.ViewForPicker removeFromSuperview];
    }];
}

-(void)showPickerView
{
    if (YES == [self.ViewForPicker isDescendantOfView:self.view])
    {
        return;
    }
    
    if (self.showingPicker == YES) {
        return;
    }
    self.ViewForPicker.frame
    = CGRectMake(0, self.view.frame.size.height,self.ViewForPicker.frame.size.width, self.ViewForPicker.frame.size.height);
    [self.view addSubview:self.ViewForPicker];
    
    [UIView animateWithDuration:0.35 animations:^(){
        self.showingPicker = YES;
        self.ViewForPicker.frame = CGRectMake(0, self.view.frame.size.height-self.ViewForPicker.frame.size.height, self.ViewForPicker.frame.size.width, self.ViewForPicker.frame.size.height);
    }completion:^(BOOL finished){
    }];
}

-(IBAction)cancel:(id)sender
{
    [self hiddenPickerView];
}

-(IBAction)selectOk:(id)sender
{
    // TODO:
    [self hiddenPickerView];
}



#pragma mark - UIPickerviewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 24;
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - UIPickerviewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth(pickerView.frame)-10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = [NSString stringWithFormat:@"%d:00",row];
    return title;
}


@end
