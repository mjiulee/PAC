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

NSString* const kMyMsgTaskUpdateNotification = @"MyMsg_Task_UpdateNotification";

@interface XPNewTaskVctler ()
<UITextViewDelegate>
{
}
@property(nonatomic)    BOOL ifChange;
@property(nonatomic,strong)    XPUIRadioGroup*  radioGroupPrio;
@property(nonatomic,strong)    UIView*     tfviewbg;
@property(nonatomic,strong)    UITextView* tfview;
@property(nonatomic,strong)    UIView* pikerView;
@property(nonatomic,strong)    XPUIRadioButton*radioNormal;
@property(nonatomic,strong)    XPUIRadioButton*radioImportant;
@property(nonatomic,strong)    UIButton* btnNext;
@property(nonatomic,strong)    UIDatePicker* timePicker;

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
        _ifChange = NO;
        _viewType = XPNewTaskViewType_New;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增任务";
    // nav left
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0,-10, 0, 0)];
    [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    if (_viewType == XPNewTaskViewType_Update)
    {
        self.title = @"修改任务";
        UIBarButtonItem* rightBtn
        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onNavRightBtnAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    //input text view and backgoundview
    _tfviewbg  = [[UIView alloc] initWithFrame:CGRectZero];
    _tfviewbg.layer.cornerRadius = 3;
    _tfviewbg.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    _tfviewbg.backgroundColor    = [UIColor whiteColor];
    _tfviewbg.layer.borderColor  = XPRGBColor(157,157,157,1).CGColor;
    _tfviewbg.layer.borderWidth  = 1;
    [self.view addSubview:_tfviewbg];
    
    _tfview = [[UITextView alloc] initWithFrame:CGRectZero];
    _tfview.textContainerInset = UIEdgeInsetsMake(3, 1, 0, 1);
    _tfview.autoresizingMask   = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    _tfview.font = [UIFont systemFontOfSize:15];
    _tfview .layer.cornerRadius = 3;
    [self.view addSubview:_tfview];
    
    _radioNormal = [[XPUIRadioButton alloc] initWithFrame:CGRectZero];
    _radioNormal.title = @"普通";
    _radioNormal.value = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_normal];
    [self.view addSubview:_radioNormal];
    
    _radioImportant = [[XPUIRadioButton alloc] initWithFrame:CGRectZero];
    _radioImportant.title = @"重要";
    _radioImportant.value = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_important];
    _radioImportant.ifCHeck = YES;
    [self.view addSubview:_radioImportant];
    
    _radioGroupPrio = [[XPUIRadioGroup alloc] initWithRadios:_radioNormal,_radioImportant,nil];
    
    if (_viewType != XPNewTaskViewType_Update) {
        if (_viewType == XPNewTaskViewType_NewNormal) {
            [_radioNormal setIfCheck:YES];
        }else if(_viewType == XPNewTaskViewType_NewImportant){
            [_radioImportant setIfCheck:YES];
        }
        
        _btnNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _btnNext.frame = CGRectZero;
        [_btnNext setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_btnNext setTitle:@"下一个" forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(onNextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnNext];
    }else{
        if (_task2Update) {
            _tfview.text = _task2Update.content;
            int status   = [_task2Update.status integerValue];
            if (status == 0) {
                [_radioNormal setIfCheck:YES];
            }else{
                [_radioImportant setIfCheck:YES];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutWithOrientat:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation
-(void)layoutWithOrientat:(int)orientation
{
    CGFloat yvalstart = 25;
    if ([UIDevice isRunningOniPhone]) {
        yvalstart = 15;
    }
    yvalstart += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    if (orientation == 1)
    {
        _tfviewbg.frame = CGRectMake(15,yvalstart,290, 82);
        _tfview.frame   = CGRectMake(16,yvalstart+2,288,78);
        _radioNormal.frame    = CGRectMake(20,CGRectGetMaxY(_tfview .frame)+20,80, 24);
        _radioImportant.frame = CGRectMake(120,CGRectGetMaxY(_tfview .frame)+20,80, 24);
        _btnNext.frame  = CGRectMake(CGRectGetMaxX(_radioImportant.frame)+20, CGRectGetMaxY(_tfview .frame)+10,100, 40);
    }else if(orientation == 2)
    {
        yvalstart = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 5;
        _tfviewbg.frame = CGRectMake(15,yvalstart,CGRectGetWidth(self.view.frame)-30, 32);
        _tfview.frame   = CGRectMake(16,yvalstart+2,CGRectGetWidth(self.view.frame)-32,28);
        _radioNormal.frame    = CGRectMake(20, CGRectGetMaxY(_tfview .frame)+10,80, 20);
        _radioImportant.frame = CGRectMake(120,CGRectGetMaxY(_tfview .frame)+10,80, 20);
        _btnNext.frame  = CGRectMake(CGRectGetMaxX(self.view.frame)-80,CGRectGetMaxY(_tfview .frame)+4,100,26);
        [_radioNormal setNeedsDisplay];
        [_radioImportant setNeedsDisplay];
    }
}

#pragma mark- navButtons
-(void)onNavLeftBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNavRightBtnAction:(id)sender{
    // Save to core data
    // [self.navigationController popViewControllerAnimated:YES];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        return;
    }
    self.ifChange = YES;
    // save item to core data
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSString* value = [_radioGroupPrio getSelectedValue];
    _task2Update.content = _tfview.text;
    _task2Update.status  = [NSNumber numberWithInt:[value integerValue]];
    [app.coreDataMgr updateTask:_task2Update];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyMsgTaskUpdateNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNextBtnAction:(id)sender
{
    //[_tfview setText:@""];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        return;
    }
    self.ifChange = YES;
    // save item to core data
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSString* value = [_radioGroupPrio getSelectedValue];
    XPTaskPriorityLevel priority;
    if ([value integerValue] == 1)
    {
        priority = XPTask_PriorityLevel_normal;
    }
    
    if([value integerValue] == 2)
    {
        priority = XPTask_PriorityLevel_important;
    }
    
    [app.coreDataMgr insertTask:_tfview.text date:[NSDate date]
                           type:XPTask_Type_User
                        prLevel:priority
                        project:nil];
    [_tfview setText:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyMsgTaskUpdateNotification object:nil];
}
@end
