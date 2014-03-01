//
//  XPNewTaskVctler.m
//  XPlan
//
//  Created by mjlee on 14-2-25.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPNewTaskVctler.h"
#import "UIImage+XPUIImage.h"
#import "XPUIRadioButton.h"

@interface XPNewTaskVctler ()
{
    UIView* _pikerView;
    UIDatePicker* _timePicker;
}
-(void)navBtnBack:(id)sender;
-(void)onNavRightBtuAction:(id)sender;
@end

@implementation XPNewTaskVctler

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
                action:@selector(navBtnBack:)
      forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
        
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                  target:self
                                                                                  action:@selector(onNavRightBtuAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增任务";
	// Do any additional setup after loading the view.
    
    UIView* tfviewbg  = [[UIView alloc] initWithFrame:CGRectMake(9,CGRectGetMaxY(self.navigationController.navigationBar.frame)+9,
                                                                 302, 142)];
    tfviewbg.layer.cornerRadius = 3;
    tfviewbg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tfviewbg];
    UITextView* tfview= [[UITextView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.navigationController.navigationBar.frame)+10,
                                                                     300, 140)];
    tfview.textContainerInset = UIEdgeInsetsMake(1, 1, 1, 1);
    tfview.layer.cornerRadius = 3;
    [self.view addSubview:tfview];
    
    {
        XPUIRadioButton* tbutton = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(20,
                                                                                     CGRectGetMaxY(tfview.frame)+10,
                                                                                     80, 24)];
        tbutton.title = @"普通";
        [self.view addSubview:tbutton];
    }
    
    {
        XPUIRadioButton* tbutton = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(120,
                                                                                     CGRectGetMaxY(tfview.frame)+10,
                                                                                     80, 24)];
        tbutton.title = @"重要";
        tbutton.ifCHeck = YES;
        [self.view addSubview:tbutton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navBtnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNavRightBtuAction:(id)sender{
    // Save to core data
    [self.navigationController popViewControllerAnimated:YES];
}

@end
