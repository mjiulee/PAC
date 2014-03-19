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
@property(nonatomic,strong) UIScrollView *            rootScrollview;
@property(nonatomic,strong) XPHistoryTaskDataHelper * dataHelper;
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
        UIBarButtonItem* rightBtn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(onNavRightBtuAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史任务";
    // data helper init
    XPHistoryTaskDataHelper * dataHelper = [[XPHistoryTaskDataHelper alloc] init];
    self.dataHelper = dataHelper;
	// Do any additional setup after loading the view.
    __weak typeof(self) _weakself = self;
    XPSegmentedView* segview= [[XPSegmentedView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                                                                CGRectGetWidth(self.view.frame), 36)
                                                               items:@"普通",@"重要",@"已完成",nil];
    segview.backgroundColor     = [UIColor whiteColor];
    segview.layer.shadowColor   = XPRGBColor(157, 157, 157, 1.0).CGColor;
    segview.layer.shadowOffset  = CGSizeMake(0,1);
    segview.layer.shadowOpacity = 1.0;
    segview.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:segview.bounds] CGPath];
    
    [self.view addSubview:segview];
    self.segmentView = segview;
    self.segmentView.segmentedBlock = ^(NSUInteger selidx){
        [_weakself onSegmentVSelectChange:selidx];
    };

    //
    UIScrollView* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segview.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(segview.frame))];
    scrollview.delegate      = self;
    scrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.scrollEnabled = NO;
    [self.view addSubview:scrollview];
    self.rootScrollview = scrollview;
    
    for (int i = 0; i < 3; i ++) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(scrollview.frame), 0,
                                                                               CGRectGetWidth(scrollview.frame),
                                                                               CGRectGetHeight(scrollview.frame))];
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.rowHeight  = 54;
        tableView.tag        = kTableViewTagStartIdx + i;
        [scrollview addSubview:tableView];
    }
    scrollview.contentSize = CGSizeMake(3*CGRectGetWidth(scrollview.frame), CGRectGetHeight(scrollview.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.segmentView];
    if (self.segmentView.curSelectIndex < 0)
    {
        [self.segmentView selectAtIndex:0];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - UItableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tagidx = tableView.tag - kTableViewTagStartIdx;
    NSInteger count  = 0;
    if(tagidx == 0) count = [self.dataHelper.listNormal    count];
    if(tagidx == 1) count = [self.dataHelper.listImportant count];
    if(tagidx == 2) count = [self.dataHelper.listFinished  count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * sCellIdentifier = @"TaskCell";
    XPTaskTableViewCell *cell = (XPTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[XPTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier tableview:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    TaskModel* atask = nil;
    NSInteger tagidx = tableView.tag - kTableViewTagStartIdx;
    if(tagidx == 0) atask = [self.dataHelper.listNormal    objectAtIndex:[indexPath row]];
    if(tagidx == 1) atask = [self.dataHelper.listImportant objectAtIndex:[indexPath row]];
    if(tagidx == 2) atask = [self.dataHelper.listFinished  objectAtIndex:[indexPath row]];
    [cell setTask:atask];
    cell.shouldIndentWhileEditing = NO;
    cell.showsReorderControl      = NO;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel* atask = nil;
    NSInteger tagidx = tableView.tag - kTableViewTagStartIdx;
    if(tagidx == 0) {
        atask = [self.dataHelper.listNormal    objectAtIndex:[indexPath row]];
        atask.status   = [NSNumber numberWithInt:XPTask_Type_Finish];
        XPAppDelegate* app = [XPAppDelegate shareInstance];
        [app.coreDataMgr updateTask:atask project:nil];

        [self.dataHelper.listFinished addObject:atask];
        [self.dataHelper.listNormal removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        UITableView* finishTable = (UITableView*)[self.rootScrollview viewWithTag:kTableViewTagStartIdx+2];
        if(finishTable){
            [finishTable performSelector:@selector(reloadData) withObject:nil];
        }
    }
    if(tagidx == 1){
        atask = [self.dataHelper.listImportant objectAtIndex:[indexPath row]];
        atask.status   = [NSNumber numberWithInt:XPTask_Type_Finish];
        XPAppDelegate* app = [XPAppDelegate shareInstance];
        [app.coreDataMgr updateTask:atask project:nil];
        [self.dataHelper.listFinished addObject:atask];
        [self.dataHelper.listImportant removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        UITableView* finishTable = (UITableView*)[self.rootScrollview viewWithTag:kTableViewTagStartIdx+2];
        if(finishTable){
            [finishTable performSelector:@selector(reloadData) withObject:nil];
        }
    }
}

#pragma mark- tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel* atask = nil;
    NSInteger tagidx = tableView.tag - kTableViewTagStartIdx;
    if(tagidx == 0) atask = [self.dataHelper.listNormal    objectAtIndex:[indexPath row]];
    if(tagidx == 1) atask = [self.dataHelper.listImportant objectAtIndex:[indexPath row]];
    if(tagidx == 2) return;
   
    XPNewTaskVctler* updatevc = [[XPNewTaskVctler alloc] init];
    updatevc.viewType    = XPNewTaskViewType_Update;
    updatevc.task2Update = atask;
    [self.navigationController pushViewController:updatevc animated:YES];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -  UIScrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollview) {
        NSUInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width/2)/scrollView.frame.size.width)+1;
        NSLog(@"page=%d",page);
        [self.segmentView selectAtIndex:page];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

#pragma mark - segment select change 
-(void)onSegmentVSelectChange:(NSUInteger)selIdx
{
    [self.rootScrollview setContentOffset:CGPointMake(selIdx*CGRectGetWidth(self.rootScrollview.frame), 0) animated:NO];
}

-(void)onNavRightBtuAction:(id)sender{
    NSUInteger total = [self.dataHelper.listFinished count] + [self.dataHelper.listImportant count] + [self.dataHelper.listNormal count];
    NSUInteger fnish = [self.dataHelper.listFinished count];
    NSUInteger normal= [self.dataHelper.listNormal count];
    NSUInteger important = [self.dataHelper.listImportant count];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:total]     forKey:@"total"];
    [dict setObject:[NSNumber numberWithInt:fnish]     forKey:@"finished"];
    [dict setObject:[NSNumber numberWithInt:normal]    forKey:@"normal"];
    [dict setObject:[NSNumber numberWithInt:important] forKey:@"important"];
    
    XPDialyStaticVCtler* diarystv = [[XPDialyStaticVCtler alloc] init];
    diarystv.taskDatas = dict;
    [self.navigationController  pushViewController:diarystv animated:YES];
}

@end
