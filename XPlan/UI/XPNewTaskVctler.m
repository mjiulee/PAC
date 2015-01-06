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
#import "XPAlarmClockHelper.h"
#import "Utils.h"
#import "CocoaSecurity.h"


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
@property(nonatomic,weak) IBOutlet UIPickerView* pickerView;
@property(nonatomic,weak) IBOutlet UILabel*  labNotifyTime;
@property(nonatomic,weak) IBOutlet UILabel*  labSelectTime;

-(void)onNavLeftBtnAction:(id)sender;
-(IBAction)onNavRightBtnAction:(id)sender;
-(IBAction)onNextBtnAction:(id)sender;
-(IBAction)onSwitchChange:(id)sender;
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

    {
        _labNotifyTime.hidden = YES;
        _pickerView.hidden    = YES;
        _labSelectTime.hidden = YES;
        NSUInteger hour=0,minute=0;
        [self.pickerView reloadAllComponents];
        NSDate* dateNow = [NSDate date];
        hour   = (dateNow.hour+2-1);
        minute = dateNow.minute;
        [self.pickerView selectRow:hour   inComponent:0 animated:YES];
        [self.pickerView selectRow:minute   inComponent:1 animated:YES];
    }

    _tfviewbg.layer.cornerRadius = 3;
    _tfview .layer.cornerRadius = 3;
    _tfview.textContainerInset = UIEdgeInsetsMake(3, 1, 0, 1);
    _tfview.font = [UIFont systemFontOfSize:15];
    
    _radioNormal.backgroundColor    = [UIColor clearColor];
    _radioImportant.backgroundColor = [UIColor clearColor];
    _radioNormal.title    = @"普通";
    _radioNormal.value    = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_normal];
    _radioNormal.ifCHeck = YES;

    _radioImportant.title = @"重要";
    _radioImportant.value = [NSString stringWithFormat:@"%d",XPTask_PriorityLevel_important];
    _radioGroupPrio=[[XPUIRadioGroup alloc] initWithRadios:_radioNormal,_radioImportant,nil];
    if (_viewType != XPNewTaskViewType_Update)
    {
        if (_viewType == XPNewTaskViewType_NewNormal){
            [_radioNormal setIfCheck:YES];
        }else if(_viewType == XPNewTaskViewType_NewImportant){
            [_radioImportant setIfCheck:YES];
        }
    }else{
        if (_task2Update){
            _tfview.text = _task2Update.content;
            NSUInteger priority   = [_task2Update.prLevel unsignedIntegerValue];
            if (priority != 2) {
                [_radioNormal setIfCheck:YES];
            }else{
                [_radioImportant setIfCheck:YES];
            }
            
            if([_task2Update.neednotify boolValue]){
                _notifySwith.on = YES;
                NSUInteger hour  = _task2Update.notifydate.hour-1;
                NSUInteger minit = _task2Update.notifydate.minute;
                [self.pickerView reloadAllComponents];
                [self.pickerView selectRow:hour  inComponent:0 animated:YES];
                [self.pickerView selectRow:minit inComponent:1 animated:YES];
                _labNotifyTime.hidden = NO;
                _pickerView.hidden = NO;
                _labSelectTime.hidden = NO;
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tfview becomeFirstResponder];
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
            [OMGToast showWithText:@"请输入任务内容" topOffset:self.view.frame.size.height-265];
            return;
        }
        self.ifChange = YES;
        // save item to core data
        NSString* value = [_radioGroupPrio getSelectedValue];
        _task2Update.content = _tfview.text;
        _task2Update.prLevel = [NSNumber numberWithInt:[value integerValue]];
        NSNumber* needNotify = [NSNumber numberWithBool:_notifySwith.on];
        NSDate*   notifyDate = nil;
        NSString* notifyname = _task2Update.notifyname;
        if (notifyname && notifyname.length) {
            // 取消
            [[XPAlarmClockHelper shareInstance] cancelTaskNotification:notifyname];
        }
        if(_notifySwith.on){
            notifyDate = [self getNotifyDate];
            CocoaSecurityResult *rtsec = [CocoaSecurity md5:_tfview.text];
            notifyname = rtsec.hex;
            // 设置提醒
            if (notifyname && notifyname.length) {
                _task2Update.notifyname = notifyname;
                NSString* msg = [NSString stringWithFormat:@"您的任务:%@,快到时间了，记得完成哦",_task2Update.content];
                [[XPAlarmClockHelper shareInstance] setTaskNotify:notifyDate message:msg name:notifyname];
            }
        }
        _task2Update.notifydate = notifyDate;
        _task2Update.neednotify = needNotify;
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
        [OMGToast showWithText:@"请输入任务内容" topOffset:self.view.frame.size.height-265];
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
    NSNumber* needNotify = [NSNumber numberWithBool:_notifySwith.on];
    NSDate*   notifyDate = nil;
    NSString* notifyname = nil;
    if(_notifySwith.on){
        notifyDate = [self getNotifyDate];
        CocoaSecurityResult *rtsec = [CocoaSecurity md5:_tfview.text];
        notifyname = rtsec.hex;
        // 设置提醒
        if (notifyname && notifyname.length) {
            NSString* msg = [NSString stringWithFormat:@"您的任务:\"%@\"还没完成，记得完成哦",_tfview.text];
            [[XPAlarmClockHelper shareInstance] setTaskNotify:notifyDate message:msg name:notifyname];            
        }
    }
    [[XPDataManager shareInstance] insertTask:_tfview.text
                                         date:[NSDate date]
                                     ifnotify:needNotify
                                   notifytime:notifyDate
                                   notifyname:notifyname
                                         type:XPTask_Type_User
                                      prLevel:priority
                                      project:nil];
    [_tfview setText:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyMsgTaskUpdateNotification object:nil];
    [OMGToast showWithText:@"任务添加成功，你可以继续编辑下一个任务" topOffset:self.view.frame.size.height-265];
}

-(IBAction)onSwitchChange:(id)sender{
    NSLog(@"switch:%@",@(_notifySwith.on));
    if (_notifySwith.on) {
        _labNotifyTime.hidden = NO;
        _pickerView.hidden    = NO;
        _labSelectTime.hidden = NO;
        [self.view endEditing:YES];
    }else{
        _labNotifyTime.hidden = YES;
        _pickerView.hidden    = YES;
        _labSelectTime.hidden = YES;
        [self.tfview becomeFirstResponder];
    }
}

#pragma mark- UIPickerDataSource&UIPickerDelegaet
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 24;
            break;
        case 1:
            return 60;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth(pickerView.frame)/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title = @"";
    if (component == 0) {
        title = [NSString stringWithFormat:@"%@点",@(row)];
    }else{
        title = [NSString stringWithFormat:@"%@分",@(row)];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger hour   = [self.pickerView selectedRowInComponent:0];
    NSUInteger minute = [self.pickerView selectedRowInComponent:1];
    NSString * tipstr = [NSString stringWithFormat:@"程序将会在%@时%@分给您提醒",@(hour),@(minute)];
    _labNotifyTime.text = tipstr;
}

-(NSDate*)getNotifyDate{
    NSUInteger hour   = [self.pickerView selectedRowInComponent:0];
    NSUInteger minute = [self.pickerView selectedRowInComponent:1];
    NSDate* today = [NSDate date];
    NSDate* morningcall = [today dateWithHour:hour mintus:minute];
    return morningcall;
}

@end
