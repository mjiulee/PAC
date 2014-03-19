//
//  XPHistoryListVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPHistoryListVctler.h"
#import "XPSegmentedView.h"

@interface XPHistoryListVctler ()
{
}
@property(nonatomic,strong) XPSegmentedView * segmentView;
@end

@implementation XPHistoryListVctler

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
    XPSegmentedView* segview= [[XPSegmentedView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                                                                CGRectGetWidth(self.view.frame), 36)
                                                               items:@"普通",@"重要",@"已完成",nil];
    [self.view addSubview:segview];
    self.segmentView = segview;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
