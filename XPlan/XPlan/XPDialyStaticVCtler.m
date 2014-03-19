//
//  XPDialyStaticVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDialyStaticVCtler.h"
#import "PNChart.h"

@interface XPDialyStaticVCtler ()
-(void)onNavLeftBtnAction:(id)sender;
@end

@implementation XPDialyStaticVCtler

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
    self.title = @"任务统计";
	// Do any additional setup after loading the view.
    // nav left
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_back_1"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_back_2"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0,-10, 0, 0)];
    [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    if(self.taskDatas)
    {
        NSNumber* total     = [self.taskDatas objectForKey:@"total"];
        NSNumber* finished  = [self.taskDatas objectForKey:@"finished"];
        CGFloat fpercent = [finished unsignedIntegerValue]/[total floatValue];
        
        PNCircleChart * circleChart
        = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, CGRectGetWidth(self.view.frame), 100.0)
                                      andTotal:[NSNumber numberWithInt:1]
                                    andCurrent:[NSNumber numberWithFloat:fpercent]];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart strokeChart];
        [self.view addSubview:circleChart];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav button actions
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
