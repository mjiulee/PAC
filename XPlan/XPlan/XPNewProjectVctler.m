//
//  XPNewProjectVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-1.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPNewProjectVctler.h"
#import "XPAppDelegate.h"

@interface XPNewProjectVctler (){
    UITextView* _tfview;
}
-(void)onNavLeftBtnAction:(id)sender;
-(void)onNavRightBtnAction:(id)sender;

@end

@implementation XPNewProjectVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_back_1"];
        UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_back_2"];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        [btn setImage:imhighLight forState:UIControlStateHighlighted];
        [btn addTarget:self
                action:@selector(onNavLeftBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                  target:self
                                                                                  action:@selector(onNavRightBtnAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"新增项目";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView* tfviewbg  = [[UIView alloc] initWithFrame:CGRectMake(9,CGRectGetMaxY(self.navigationController.navigationBar.frame)+9,
                                                                 302, 142)];
    tfviewbg.layer.cornerRadius = 3;
    tfviewbg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tfviewbg];
    _tfview = [[UITextView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.navigationController.navigationBar.frame)+10,
                                                           300, 140)];
    _tfview .textContainerInset = UIEdgeInsetsMake(1, 1, 1, 1);
    _tfview .layer.cornerRadius = 3;
    [self.view addSubview:_tfview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- NavButton actions
-(void)onNavLeftBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNavRightBtnAction:(id)sender{
    // Save to core data [self.navigationController popViewControllerAnimated:YES];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        return;
    }
    // save item to core data
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    [app.coreDataMgr insertProject:_tfview.text];
    [_tfview setText:@""];
}
@end
