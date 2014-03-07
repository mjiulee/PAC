//
//  XPProjectStaticVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPProjectStaticVctler.h"

@interface XPProjectStaticVctler ()

@end

@implementation XPProjectStaticVctler

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
    // Do any additional setup after loading the view.
    self.title = @"项目统计图表";
    UILabel* lab = [[UILabel alloc] initWithFrame:self.view.bounds];
    lab.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    lab.text = @"开发中";
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
