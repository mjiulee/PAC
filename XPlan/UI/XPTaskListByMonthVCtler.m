//
//  XPTaskListVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPTaskListByMonthVCtler.h"
#import "XPNewTaskVctler.h"
#import "IIViewDeckController.h"
#import "XPTaskTableViewCell.h"
#import "XPDialyStaticVCtler.h"
#import "XPAdBannerVer.h"
#import "XPSegmentedView.h"

//static int kHeadViewBtnStartIdx = 1000;

@interface XPTaskListByMonthVCtler ()
<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger _segmentIndex;
}

@property(nonatomic,strong) XPAdBannerVer* adBannerview;
@property(nonatomic,strong) UITableView*   tableview;
@property(nonatomic,strong) XPSegmentedView* segmentview;

@property (nonatomic) NSFetchedResultsController *fetchRtvctlerDialy;
@property (nonatomic) NSFetchedResultsController *fetchRtvctlerMonthly;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation XPTaskListByMonthVCtler

-(void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // data load from core date
        _segmentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史任务";
    
    self.managedObjectContext = [XPDataManager shareInstance].managedObjectContext;
    NSError *error;
	if (![self.fetchRtvctlerDialy performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    if (![self.fetchRtvctlerMonthly performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}

    CGFloat width   = CGRectGetWidth(self.view.frame);
    CGFloat heidht  = CGRectGetHeight(self.view.frame);
    CGFloat yoffset = 10;//CGRectGetMaxY(self.navigationController.navigationBar.frame)+8;
    
    __weak typeof(self) _weakself = self;
    XPSegmentedView* segview= [[XPSegmentedView alloc] initWithFrame:CGRectMake(15,yoffset,width-30,22)
                                                               items:@"按天",@"按月",nil];
    segview.backgroundColor     = XPRGBColor(248, 248, 248, 0.88);
    [self.view addSubview:segview];
    self.segmentview = segview;
    self.segmentview.segmentedBlock = ^(NSUInteger selidx){
        [_weakself onSegmentVSelectChange:selidx];
    };
    yoffset += CGRectGetHeight(segview.frame)+10;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,yoffset,width,heidht-yoffset)];
    tableView.dataSource = self;
    tableView.delegate   = self;
    tableView.rowHeight  = 50;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableview = tableView;
    self.tableview.backgroundColor = [UIColor whiteColor];

    
    if( kIfShowGoogleAdBanner == 1)
    {
        __block typeof(self) wself = self;
        self.adBannerview = [[XPAdBannerVer alloc] initWithFrame:CGRectMake(0, 0,kGADAdSizeBanner.size.width,
                                                                            kGADAdSizeBanner.size.height)
                                                       controler:self];
        
        self.adBannerview.closeBlock = ^(){
            wself.tableview.tableHeaderView = nil;
        };
        self.adBannerview.adViewReceive = ^(){
            wself.tableview.tableHeaderView = wself.adBannerview;
        };
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - segment changel
-(void)onSegmentVSelectChange:(NSUInteger)index{
    if (_segmentIndex == index) {
        return;
    }
    _segmentIndex = index;
    [self.tableview reloadData];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = 1;
    if (_segmentIndex == 0) {
        count = [[self.fetchRtvctlerDialy sections] count];
    }else{
        count = [[self.fetchRtvctlerMonthly sections] count];
    }
	return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController* ptrfrtctler = nil;
    if (_segmentIndex == 0) {
        ptrfrtctler = self.fetchRtvctlerDialy;
    }else{
        ptrfrtctler = self.fetchRtvctlerMonthly;
    }
    
	id <NSFetchedResultsSectionInfo> sectionInfo = [[ptrfrtctler sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /*
     Use a default table view cell to display the event's title.
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 2;
    }
    
    NSFetchedResultsController* ptrfrtctler = nil;
    if (_segmentIndex == 0) {
        ptrfrtctler = self.fetchRtvctlerDialy;
    }else{
        ptrfrtctler = self.fetchRtvctlerMonthly;
    }
    
	TaskModel *event = [ptrfrtctler objectAtIndexPath:indexPath];
	cell.textLabel.text = event.content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc] initWithFrame:CGRectZero];
    headview.autoresizingMask= UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    headview.backgroundColor = XPRGBColor(248, 248, 248, 0.88);
    
    UILabel* sectionTItle = [UILabel new];
    sectionTItle.frame    = CGRectMake(18, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.backgroundColor = kClearColor;
    sectionTItle.font       = [UIFont systemFontOfSize:18];
    sectionTItle.textColor  = XPRGBColor(25, 133, 255, 1.0);
    
    NSFetchedResultsController* ptrfrtctler = nil;
    if (_segmentIndex == 0) {
        ptrfrtctler = self.fetchRtvctlerDialy;
    }else{
        ptrfrtctler = self.fetchRtvctlerMonthly;
    }
    
	id <NSFetchedResultsSectionInfo> theSection = [[ptrfrtctler sections] objectAtIndex:section];
    sectionTItle.text = [theSection name];;
    [headview addSubview:sectionTItle];
    
    UIView* divLine = [[UIView alloc] initWithFrame:CGRectMake(0,29, CGRectGetWidth(tableView.frame),1)];
    divLine.backgroundColor = XPRGBColor(220, 220, 220, 1.0);
    [headview addSubview:divLine];
    return headview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchRtvctlerDialy
{
    if (_fetchRtvctlerDialy != nil)
    {
        return _fetchRtvctlerDialy;
    }
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskModel"
                                              inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
	// Sort using the timeStamp property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreate" ascending:NO];
	[fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchRtvctlerDialy = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                              managedObjectContext:self.managedObjectContext
                                                                sectionNameKeyPath:@"sectionIdDaily"
                                                                         cacheName:nil];
    _fetchRtvctlerDialy.delegate = self;
    
	return _fetchRtvctlerDialy;
}

- (NSFetchedResultsController *)fetchRtvctlerMonthly
{
    if (_fetchRtvctlerMonthly != nil)
    {
        return _fetchRtvctlerMonthly;
    }
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskModel"
                                              inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    
	// Sort using the timeStamp property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreate" ascending:NO];
	[fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchRtvctlerMonthly = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                              managedObjectContext:self.managedObjectContext
                                                                sectionNameKeyPath:@"sectionIdMonthly"
                                                                         cacheName:nil];
    _fetchRtvctlerMonthly.delegate = self;
    
	return _fetchRtvctlerMonthly;
}
@end
