//
//  XPSettingVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-28.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPSettingVctler.h"
#import "XPUserDataHelper.h"
#import "XPAlarmClockHelper.h"

@interface XPSettingVctler ()

@property(nonatomic,strong) IBOutlet UISegmentedControl* segmentview;
@property(nonatomic,strong) IBOutlet UITextField*  tfview;
@property(nonatomic,strong) IBOutlet UIPickerView* pickerView;
@property(nonatomic,strong) IBOutlet UIButton* setButton;

@property(nonatomic,strong) NSDictionary* morningDict;
@property(nonatomic,strong) NSDictionary* nightDict;

-(IBAction)onSegmentChange:(id)sender;
-(IBAction)onSetButtonAction:(id)sender;
@end

@implementation XPSettingVctler

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
    self.title = @"提醒设置";
    
    // Do any additional setup after loading the view from its nib.
    self.setButton.layer.borderColor = XPRGBColor(25, 133, 255, 1.0).CGColor;
    self.setButton.layer.borderWidth = 0.5;
    self.setButton.layer.cornerRadius= 4;
    
    {
        NSDictionary* dict = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_MorningNotify];
        if (!dict) {
            NSNumber* hourNumber   = [NSNumber numberWithUnsignedInteger:9];
            NSNumber* minuteNumber = [NSNumber numberWithUnsignedInteger:0];
            dict= [NSDictionary dictionaryWithObjectsAndKeys:hourNumber,@"hour", minuteNumber,@"minute",nil];
        }
        self.morningDict = dict;
    }

    {
        NSDictionary* dict =[[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_NightNotify];
        if (!dict) {
            NSNumber* hourNumber   = [NSNumber numberWithUnsignedInteger:19];
            NSNumber* minuteNumber = [NSNumber numberWithUnsignedInteger:0];
            dict= [NSDictionary dictionaryWithObjectsAndKeys:hourNumber,@"hour", minuteNumber,@"minute",nil];
        }
        self.nightDict = dict;
    }
    
    // 设置初始时
    [self onSegmentChange:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XPAlarmClockHelper shareInstance] setupNotification];
}

#pragma mark- UISegmentedControl
-(IBAction)onSegmentChange:(id)sender
{
     // 根据分隔进行时间设置
    NSUInteger hour=0,minute=0;
    [self.pickerView reloadAllComponents];
    if (self.segmentview.selectedSegmentIndex==0) {
        [self getHour:self.morningDict hour:&hour minute:&minute];
        [self.pickerView selectRow:hour   inComponent:0 animated:YES];
        [self.pickerView selectRow:minute   inComponent:1 animated:YES];

        NSString * tipstr = [NSString stringWithFormat:@"应用将在%@点%@分提醒你做每日计划",@(hour),@(minute)];
        [self setText2TextField:tipstr];
    }else{
        [self getHour:self.nightDict hour:&hour minute:&minute];
        [self.pickerView selectRow:hour-12  inComponent:0 animated:YES];
        [self.pickerView selectRow:minute   inComponent:1 animated:YES];
        NSString * tipstr = [NSString stringWithFormat:@"应用将在%@点%@分提醒你做每日总结",@(hour),@(minute)];
        [self setText2TextField:tipstr];
    }
}

-(IBAction)onSetButtonAction:(id)sender
{
    NSUInteger hour   = [self.pickerView selectedRowInComponent:0];
    NSUInteger minute = [self.pickerView selectedRowInComponent:1];
    
    if (self.segmentview.selectedSegmentIndex == 0)
    {
        NSNumber* hourNumber   = [NSNumber numberWithUnsignedInteger:hour];
        NSNumber* minuteNumber = [NSNumber numberWithUnsignedInteger:minute];
        NSDictionary* dict= [NSDictionary dictionaryWithObjectsAndKeys:hourNumber,@"hour", minuteNumber,@"minute",nil];
        [[XPUserDataHelper shareInstance] setUserDataByKey:XPUserDataKey_MorningNotify value:dict];
        self.morningDict = dict;
        
        NSString * tipstr = [NSString stringWithFormat:@"应用将在%@点%@分提醒你做每日计划",@(hour),@(minute)];
        [self setText2TextField:tipstr];
        [OMGToast showWithText:@"早上提醒时间设定成功，\r我们将会在指定时间提醒你。" duration:3];
    }else
    {
        hour += 12;
        NSNumber* hourNumber = [NSNumber numberWithUnsignedInteger:hour];
        NSNumber* minuteNumber = [NSNumber numberWithUnsignedInteger:minute];
        NSDictionary* dict= [NSDictionary dictionaryWithObjectsAndKeys:hourNumber,@"hour", minuteNumber,@"minute",nil];
        [[XPUserDataHelper shareInstance] setUserDataByKey:XPUserDataKey_NightNotify value:dict];
        self.nightDict = dict;

        NSString * tipstr = [NSString stringWithFormat:@"应用将在%@点%@分提醒你做每日总结",@(hour),@(minute)];
        [self setText2TextField:tipstr];
        [OMGToast showWithText:@"下午提醒时间设定成功，\r我们将会在指定时间提醒你。" duration:3];
    }
}

-(void)getHour:(in NSDictionary*) dict hour:(out NSUInteger*)hour minute:(out NSUInteger *)minute
{
    if (!dict) {
        return;
    }
    NSNumber* hourNumber   = [dict objectForKey:@"hour"];
    NSNumber* miniteNumber = [dict objectForKey:@"minute"];
    *hour   = [hourNumber unsignedIntegerValue];
    *minute = [miniteNumber unsignedIntegerValue];
}


-(void)setText2TextField:(NSString*)string
{
    self.tfview.text = string;
}

#pragma mark- UIPickerDataSource&UIPickerDelegaet
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 12;
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
        if (self.segmentview.selectedSegmentIndex ==0 ) {
            title = [NSString stringWithFormat:@"%@点",@(row)];
        }else{
            title = [NSString stringWithFormat:@"%@点",@(row+12)];
        }
    }else{
       title = [NSString stringWithFormat:@"%@分",@(row)];
    }
    return title;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    NSLog(@"select at component:%ld,row=%ld",component,row);
//}


@end
