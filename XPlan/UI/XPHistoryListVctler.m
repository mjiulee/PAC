//
//  XPHistoryListVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPHistoryListVctler.h"
#import "XPSegmentedView.h"
#import "XPHistoryTaskDataHelper.h"
#import "XPTaskTableViewCell.h"
#import "XPNewTaskVctler.h"
#import "XPDialyStaticVCtler.h"

static const NSUInteger kTableViewTagStartIdx = 1000;

@interface XPHistoryListVctler ()
<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
}
@property(nonatomic,strong) XPSegmentedView *         segmentView;
@property(nonatomic,strong) UITableView*              tableview;
@property(nonatomic,strong) XPHistoryTaskDataHelper * dataHelper;
@property(nonatomic,strong) UIView*                   EmptyView;
@property(nonatomic,strong) UILabel*                  labEmpty;

// functions
-(void)onNavRightBtuAction:(id)sender;
-(void)onSegmentVSelectChange:(NSUInteger)selIdx;     //void SegmentView Select Change
@end

@implementation XPHistoryListVctler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,7,30,30);
        btn.layer.cornerRadius = 15;
        btn.layer.borderWidth  = 2.5;
        btn.layer.borderColor  = [UIColor whiteColor].CGColor;
        
        //[btn setImage:imgnormal forState:UIControlStateNormal];
        [[btn titleLabel] setFont:[UIFont boldSystemFontOfSize:10]];
        [btn setTitle:@"统计" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onNavRightBtuAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全部任务";
    // data helper init
    XPHistoryTaskDataHelper * dataHelper = [[XPHistoryTaskDataHelper alloc] init];
    self.dataHelper = dataHelper;
	// Do any additional setup after loading the view.
    
    CGFloat width   = CGRectGetWidth(self.view.frame);
    CGFloat heidht  = CGRectGetHeight(self.view.frame);
    CGFloat yoffset = 10;//CGRectGetMaxY(self.navigationController.navigationBar.frame)+8;
    
    __weak typeof(self) _weakself = self;
    XPSegmentedView* segview= [[XPSegmentedView alloc] initWithFrame:CGRectMake(10,yoffset,width-20,30)
                                                               items:@"普通",@"重要",@"已完成",nil];
    segview.backgroundColor     = XPRGBColor(248, 248, 248, 0.88);
    [self.view addSubview:segview];
    self.segmentView = segview;
    self.segmentView.segmentedBlock = ^(NSUInteger selidx){
        [_weakself onSegmentVSelectChange:selidx];
    };
    yoffset += CGRectGetHeight(segview.frame)+10;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,yoffset,width,heidht-yoffset)];
    tableView.dataSource = self;
    tableView.delegate   = self;
    tableView.rowHeight  = 50;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    tableView.tag        = kTableViewTagStartIdx;
    [self.view addSubview:tableView];
    self.tableview = tableView;
    
    {
        UIView* emptyv = [[UIView alloc] init];
        emptyv.frame = tableView.frame;
        [self.view addSubview:emptyv];
        self.EmptyView = emptyv;
        
        UILabel* labEmpty = [[UILabel alloc] init];
        labEmpty.tag   = 100;
        labEmpty.font  = [UIFont systemFontOfSize:15];
        labEmpty.textAlignment = NSTextAlignmentCenter;
        labEmpty.numberOfLines = 0;
        if ([UIDevice isRunningOniPhone5]) {
            labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(self.EmptyView.frame)-40, CGRectGetHeight(self.EmptyView.frame)/2);
        }else{
            labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(self.EmptyView.frame)-40, CGRectGetHeight(self.EmptyView.frame)*2/3);
        }
        labEmpty.textColor= XPRGBColor(157,157, 157, 1.0);
        [self.EmptyView addSubview:labEmpty];
        self.labEmpty = labEmpty;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.segmentView.curSelectIndex < 0){
        [self.segmentView selectAtIndex:0];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - UItableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger tagidx = self.segmentView.curSelectIndex;
    NSInteger count  = 1;
    if(tagidx == 0) count = [self.dataHelper hasNextPage:XPTask_PriorityLevel_normal]?2:1;
    if(tagidx == 1) count = [self.dataHelper hasNextPage:XPTask_PriorityLevel_important]?2:1;
    if(tagidx == 2) count = [self.dataHelper hasNextPage:XPTask_PriorityLevel_all]?2:1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tagidx = self.segmentView.curSelectIndex;
    NSInteger count  = 0;
    if (section == 0) {
        if(tagidx == 0) count = [self.dataHelper.listNormal    count];
        if(tagidx == 1) count = [self.dataHelper.listImportant count];
        if(tagidx == 2) count = [self.dataHelper.listFinished  count];
        if (count <= 0)
        {
            if ([self.dataHelper checkIfHadHistoryTask:XPTask_PriorityLevel_normal])
            {
                self.labEmpty.text  = @"恭喜你，你的任务都完成了。\r您是高效的人，本屌看好你哦~";
            }else
            {
                self.labEmpty.text  = @"我插咧，爷！\r你高吗？你富吗？你帅吗？\r您不用干活的吗？\r不是高富帅就赶紧滚回去干活。";
            }
            [self.EmptyView setHidden:NO];
        }else{
            [self.EmptyView setHidden:YES];
        }
    }else{
        count = 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        static NSString * sCellIdentifier = @"TaskCell";
        XPTaskTableViewCell *cell = (XPTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
        if (!cell) {
            cell = [[XPTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier tableview:tableView];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        TaskModel* atask = nil;
        NSInteger tagidx = self.segmentView.curSelectIndex;
        if(tagidx == 0) atask = [self.dataHelper.listNormal    objectAtIndex:[indexPath row]];
        if(tagidx == 1) atask = [self.dataHelper.listImportant objectAtIndex:[indexPath row]];
        if(tagidx == 2) atask = [self.dataHelper.listFinished  objectAtIndex:[indexPath row]];
        [cell setTask:atask];
        return cell;
    }else
    {
        static NSString * sCellIdentifier = @"loadingcell";
        UITableViewCell*cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIActivityIndicatorView* active  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            active.tag = 100;
            active.backgroundColor = [UIColor whiteColor];
            active.frame = CGRectMake(145,7,30,30);
            [cell addSubview:active];
            [active startAnimating];
        }
        UIActivityIndicatorView* active = (UIActivityIndicatorView*)[cell viewWithTag:100];
        if (active) {
            [active startAnimating];
        }
        [self performSelector:@selector(getNextPage)
                   withObject:nil
                   afterDelay:0.25];
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel* atask = nil;
    NSInteger tagidx = self.segmentView.curSelectIndex;
    if(tagidx == 0) {
        atask = [self.dataHelper.listNormal    objectAtIndex:[indexPath row]];
        atask.status   = [NSNumber numberWithInt:XPTask_Status_Done];
        atask.dateDone = [NSDate date];
        [[XPDataManager shareInstance] updateTask:atask];

        [self.dataHelper.listFinished addObject:atask];
        [self.dataHelper.listNormal removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    if(tagidx == 1){
        atask = [self.dataHelper.listImportant objectAtIndex:[indexPath row]];
        atask.status   = [NSNumber numberWithInt:XPTask_Status_Done];
        atask.dateDone = [NSDate date];
        [[XPDataManager shareInstance] updateTask:atask];
        [self.dataHelper.listFinished addObject:atask];
        [self.dataHelper.listImportant removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark- tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getNext page
-(void)getNextPage
{
    NSUInteger tabIdx =  self.segmentView.curSelectIndex;
    XPTaskPriorityLevel priority = XPTask_PriorityLevel_normal;
    if (tabIdx == 0) {
        priority = XPTask_PriorityLevel_normal;
    }else if(tabIdx == 1){
        priority = XPTask_PriorityLevel_important;
    }else{
        priority = XPTask_PriorityLevel_all;
    }
    [self.dataHelper getNextPage:priority];
    [self.tableview reloadData];
}

#pragma mark - segment select change 
-(void)onSegmentVSelectChange:(NSUInteger)selIdx
{
    [self.tableview reloadData];
}

-(void)onNavRightBtuAction:(id)sender{
    XPDialyStaticVCtler* diarystv = [[XPDialyStaticVCtler alloc] init];
    [self.navigationController  pushViewController:diarystv animated:YES];
}

@end
