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

@interface XPNewTaskVctler ()<UITextViewDelegate>{
}
@property(nonatomic)           BOOL ifChange;
@property(nonatomic,strong) XPUIRadioGroup*  radioGroupPrio;
@property(nonatomic,weak) IBOutlet UIView*     tfviewbg;
@property(nonatomic,weak) IBOutlet UITextView* tfview;
@property(nonatomic,weak) IBOutlet XPUIRadioButton*radioNormal;
@property(nonatomic,weak) IBOutlet XPUIRadioButton*radioImportant;
@property(nonatomic,weak) IBOutlet UISwitch* notifySwith;

@property(nonatomic,weak) IBOutlet UIButton* btnNext;
@property(nonatomic,weak) IBOutlet UIView*   pikerView;
@property(nonatomic,weak) IBOutlet UIDatePicker* timePicker;

-(void)onNavLeftBtnAction:(id)sender;
-(IBAction)onNavRightBtnAction:(id)sender;
-(IBAction)onNextBtnAction:(id)sender;
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
    {
        UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
        //UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        //[btn setImage:imhighLight forState:UIControlStateHighlighted];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }

    if (_viewType == XPNewTaskViewType_Update){
        self.title = @"修改任务";
    }
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    if (_viewType == XPNewTaskViewType_Update){
        [btn setTitle:@"修改" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"创建" forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn addTarget:self action:@selector(onNavRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;

    _tfviewbg.layer.cornerRadius = 3;
    _tfview .layer.cornerRadius = 3;
    _tfview.textContainerInset = UIEdgeInsetsMake(3, 1, 0, 1);
    _tfview.font = [UIFont systemFontOfSize:15];
    
    _radioNormal.backgroundColor    = [UIColor clearColor];
    _radioImportant.backgroundColor = [UIColor clearColor];
    _radioNormal.title    = @"普通";
    _radioNormal.value    = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_normal];
    _radioImportant.title = @"重要";
    _radioImportant.value = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_important];
    _radioImportant.ifCHeck = YES;
    _radioGroupPrio=[[XPUIRadioGroup alloc] initWithRadios:_radioNormal,_radioImportant,nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- navButtons
-(void)onNavLeftBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNavRightBtnAction:(id)sender{
    // Save to core data
    if (_viewType == XPNewTaskViewType_Update){
        if (!_tfview.text || [_tfview.text length] <= 0) {
            [OMGToast showWithText:@"请输入任务内容" topOffset:146];
            return;
        }
        self.ifChange = YES;
        // save item to core data
        NSString* value = [_radioGroupPrio getSelectedValue];
        _task2Update.content = _tfview.text;
        _task2Update.prLevel = [NSNumber numberWithInt:[value integerValue]];
        [[XPDataManager shareInstance] updateTask:_task2Update];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMyMsgTaskUpdateNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self onNextBtnAction:nil];
    }
}

-(void)onNextBtnAction:(id)sender
{
    //[_tfview setText:@""];
    if (!_tfview.text || [_tfview.text length] <= 0) {
        [OMGToast showWithText:@"请输入任务内容" topOffset:146];
        return;
    }
    self.ifChange = YES;
    // save item to core data
    NSString* value = [_radioGroupPrio getSelectedValue];
    XPTaskPriorityLevel priority;
    if ([value integerValue] == 1){
        priority = XPTask_PriorityLevel_normal;
    }
    
    if([value integerValue] == 2){
        priority = XPTask_PriorityLevel_important;
    }
    
    [[XPDataManager shareInstance] insertTask:_tfview.text
                                         date:[NSDate date]
                                         type:XPTask_Type_User
                                      prLevel:priority
                                      project:nil];
    [_tfview setText:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyMsgTaskUpdateNotification object:nil];
    [OMGToast showWithText:@"任务添加成功，你可以继续编辑下一个任务" topOffset:self.view.frame.size.height-275];
}
@end
