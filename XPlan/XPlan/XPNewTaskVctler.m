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
#import "TaskModel.h"

@interface XPNewTaskVctler ()
{
    //XPUIRadioButton* _radioNormal;
    //XPUIRadioButton* _radioImportant;
    XPUIRadioGroup*  _radioGroupPrio;
    
    UITextView* _tfview;
    UIView* _pikerView;
    UIDatePicker* _timePicker;
}
-(void)onNavLeftBtnAction:(id)sender;
-(void)onNavRightBtnAction:(id)sender;
-(void)onNextBtnAction:(id)sender;
@end

@implementation XPNewTaskVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewType = XPNewTaskViewType_New;
        UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_back_1"];
        UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_back_2"];
        
        // nav left
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        [btn setImage:imhighLight forState:UIControlStateHighlighted];
        [btn addTarget:self
                action:@selector(onNavLeftBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增任务";
	// Do any additional setup after loading the view.
    if (_viewType == XPNewTaskViewType_Update)
    {
        self.title = @"修改任务";
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                  target:self
                                                                                  action:@selector(onNavRightBtnAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    CGFloat yvalstart = 9;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        yvalstart += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    }
    UIView* tfviewbg  = [[UIView alloc] initWithFrame:CGRectMake(9,yvalstart,302, 82)];
    tfviewbg.layer.cornerRadius = 3;
    tfviewbg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tfviewbg];
    _tfview = [[UITextView alloc] initWithFrame:CGRectMake(10,yvalstart+1,300, 80)];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        _tfview .textContainerInset = UIEdgeInsetsMake(1, 1, 1, 1);
    }
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
    
    if (_viewType == XPNewTaskViewType_New) {
        UIButton* btnNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btnNext.frame = CGRectMake(CGRectGetMaxX(_radioImportant.frame)+20, CGRectGetMaxY(_tfview .frame),100, 40);
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [btnNext setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }
        [btnNext setTitle:@"下一个" forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(onNextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNext];
    }else{
        if (_task2Update) {
            _tfview.text = _task2Update.brief;
            int status   = [_task2Update.status integerValue];
            if (status == 0) {
                [_radioNormal setIfCheck:YES];
            }else{
                [_radioImportant setIfCheck:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNavLeftBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNavRightBtnAction:(id)sender{
    // Save to core data
    // [self.navigationController popViewControllerAnimated:YES];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        return;
    }
    // save item to core data
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSString* value = [_radioGroupPrio getSelectedValue];

    [app.coreDataMgr updateTask:_task2Update
                          brief:_tfview.text
                         status:[value integerValue]
                        project:nil];
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
    NSString* value = [_radioGroupPrio getSelectedValue];

    [app.coreDataMgr insertTask:_tfview.text
                         status:[value integerValue]
                           date:[NSDate date]
                        project:nil];
    [_tfview setText:@""];
}

@end
