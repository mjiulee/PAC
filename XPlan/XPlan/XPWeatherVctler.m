//
//  XPWeatherVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPWeatherVctler.h"

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
//    _day1View.layer.borderWidth =0.5;
//    _day1View.layer.borderColor =XPRGBColor(157, 157, 157, 1).CGColor;
//    _day2View.layer.borderWidth =0.5;
//    _day2View.layer.borderColor =XPRGBColor(157, 157, 157, 1).CGColor;
//    _day3View.layer.borderWidth =0.5;
//    _day3View.layer.borderColor =XPRGBColor(157, 157, 157, 1).CGColor;
    
    self.rootScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.day3View.frame)+100);
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

@end
