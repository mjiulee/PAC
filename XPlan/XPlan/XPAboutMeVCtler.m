//
//  XPAboutMeVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAboutMeVCtler.h"

@interface XPAboutMeVCtler ()
-(void)onNavLeftBtnAction:(id)sender;
@property(nonatomic,strong) IBOutlet UIImageView* usericon;
@end

@implementation XPAboutMeVCtler

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
    self.title = @"关于";
    self.usericon.image = [UIImage imageNamed:@"myself"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - navbutton actions
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
