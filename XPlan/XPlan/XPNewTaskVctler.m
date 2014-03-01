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
    //XPUIRadioButton* _radioNormal;
    //XPUIRadioButton* _radioImportant;
    XPUIRadioGroup*  _radioGroupPrio;
    
    UITextView* _tfview;
    UIView* _pikerView;
    UIDatePicker* _timePicker;
}
-(void)navBtnBack:(id)sender;
-(void)onNavRightBtuAction:(id)sender;
-(void)onNextBtnAction:(id)sender;
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
    _tfview = [[UITextView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.navigationController.navigationBar.frame)+10,
                                                                     300, 140)];
    _tfview .textContainerInset = UIEdgeInsetsMake(1, 1, 1, 1);
    _tfview .layer.cornerRadius = 3;
    [self.view addSubview:_tfview];
    
    XPUIRadioButton*_radioNormal = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_tfview .frame)+10,80, 24)];
    _radioNormal.title = @"普通";
    _radioNormal.value = @"0";
    [self.view addSubview:_radioNormal];
    
    XPUIRadioButton*_radioImportant = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(120,CGRectGetMaxY(_tfview .frame)+10,80, 24)];
    _radioImportant.title = @"重要";
    _radioImportant.value = @"1";
    _radioImportant.ifCHeck = YES;
    [self.view addSubview:_radioImportant];
    
    _radioGroupPrio = [[XPUIRadioGroup alloc] initWithRadios:_radioNormal,_radioImportant,nil];
    
    UIButton* btnNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnNext.frame = CGRectMake(CGRectGetMaxX(_radioImportant.frame)+20, CGRectGetMaxY(_tfview .frame),100, 40);
    [btnNext setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnNext setTitle:@"下一个" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(onNextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
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

-(void)onNextBtnAction:(id)sender
{
    //[_tfview setText:@""];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        return;
    }
    // save item to core data
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    
#if IfCoreDataDebug
    [app.coreDataMgr insertTest:_tfview.text date:[NSDate date]];
#elif
    XPT_Task * newTask = [[XPT_Task alloc] init];
    newTask.taskcontent= [NSString stringWithString:_tfview.text];
    newTask.ifdone     = [NSNumber numberWithInteger:0];
    newTask.priority   = [NSNumber numberWithInteger:[[_radioGroupPrio getSelectedValue] integerValue]];
    newTask.create_date= [NSDate date];
    [app.coreDataMgr insertTask:newTask];
#endif
    
    // clean
    [_tfview setText:@""];
    
    [app.coreDataMgr queryTest:1 size:20];
}

@end
