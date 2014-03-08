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
<UITextViewDelegate>
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增任务";
    // nav left
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_back_1"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_back_2"];
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
    
    CGFloat yvalstart = 25;
    if ([UIDevice isRunningOniPhone]) {
        yvalstart = 15;
    }
    yvalstart += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    //input text view and backgoundview
    UIView* tfviewbg  = [[UIView alloc] initWithFrame:CGRectMake(15,yvalstart,290, 82)];
    tfviewbg.layer.cornerRadius = 3;
    tfviewbg.backgroundColor    = [UIColor whiteColor];
    tfviewbg.layer.borderColor  = XPRGBColor(157,157,157,1).CGColor;
    tfviewbg.layer.borderWidth  = 1;
    [self.view addSubview:tfviewbg];
    
    _tfview = [[UITextView alloc] initWithFrame:CGRectMake(16,yvalstart+2,288, 78)];
    _tfview .textContainerInset = UIEdgeInsetsMake(3, 1, 0, 1);
    _tfview.font = [UIFont systemFontOfSize:15];
//    _tfview.delegate            = self;
//    _tfview.layer.borderColor   = XPRGBColor(157,157,157,1).CGColor;
//    _tfview.layer.borderWidth   = 1;
    _tfview .layer.cornerRadius = 3;
    [self.view addSubview:_tfview];
    
    XPUIRadioButton*_radioNormal = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_tfview .frame)+20,80, 24)];
    _radioNormal.title = @"普通";
    _radioNormal.value = [NSString stringWithFormat:@"%d",XPTask_Type_Normal];
    [self.view addSubview:_radioNormal];
    
    XPUIRadioButton*_radioImportant = [[XPUIRadioButton alloc] initWithFrame:CGRectMake(120,CGRectGetMaxY(_tfview .frame)+20,80, 24)];
    _radioImportant.title = @"重要";
    _radioImportant.value = [NSString stringWithFormat:@"%d",XPTask_Type_Important];
    _radioImportant.ifCHeck = YES;
    [self.view addSubview:_radioImportant];
    
    _radioGroupPrio = [[XPUIRadioGroup alloc] initWithRadios:_radioNormal,_radioImportant,nil];
    
    if (_viewType != XPNewTaskViewType_Update) {
        if (_viewType == XPNewTaskViewType_NewNormal) {
            [_radioNormal setIfCheck:YES];
        }else if(_viewType == XPNewTaskViewType_NewImportant){
            [_radioImportant setIfCheck:YES];
        }
        
        UIButton* btnNext = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btnNext.frame = CGRectMake(CGRectGetMaxX(_radioImportant.frame)+20, CGRectGetMaxY(_tfview .frame)+10,100, 40);
        [btnNext setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
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
    _task2Update.brief = _tfview.text;
    _task2Update.status= [NSNumber numberWithInt:[value integerValue]];
    [app.coreDataMgr updateTask:_task2Update
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


/*#pragma mark - uitextviewdelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView scrollRangeToVisible:range];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}*/

@end
