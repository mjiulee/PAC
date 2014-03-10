//
//  XPTaskListVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPTaskListVCtler.h"
#import "XPNewTaskVctler.h"
#import "IIViewDeckController.h"
#import "XPTaskTableViewCell.h"
#import "FMMoveTableView.h"
#import "FMMoveTableViewCell.h"

static int kHeadViewBtnStartIdx = 1000;

@interface XPTaskListVCtler ()
{
    NSMutableArray* _taskListNormal;
    NSMutableArray* _taskListImportant;
    NSMutableArray* _taskListFinish;
}
// NavButtons
-(void)onNavRightBtuAction:(id)sender;
// View Buttons
-(void)onAddTaskButtonAction:(id)sender;
// Datas
-(void)reLoadData;
//ViewDeck
//-(BOOL)openLeftView;
@end

@implementation XPTaskListVCtler
static NSString *sCellIdentifier;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Instruct the system to stop generating device orientation notifications.
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization，load data From Core Data
        _taskListNormal = [[NSMutableArray alloc] init];
        _taskListImportant = [[NSMutableArray alloc] init];;
        _taskListFinish = [[NSMutableArray alloc] init];;
        
        sCellIdentifier = @"MoveCell";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"今日任务";
    // tableview
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[FMMoveTableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight  = 64;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
    [self reLoadData];
    [self.tableView reloadData];
}

#pragma mark -tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if(section == 0) count = [_taskListNormal count];
    if(section == 1) count = [_taskListImportant count];
    if(section == 2) count = [_taskListFinish count];

    //#warning Implement this check in your table data source
    // 1. A row is in a moving state
    // 2. The moving row is not in it's initial section
    if (tableView.movingIndexPath && tableView.movingIndexPath.section != tableView.initialIndexPathForMovingRow.section)
    {

        if (section == tableView.movingIndexPath.section) {
            count++;
        }
        else if (section == tableView.initialIndexPathForMovingRow.section) {
            count--;
        }
    }
    
    return count;
}

- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPTaskTableViewCell *cell = (XPTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[XPTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier tableview:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.selectionStyle= UITableViewCellSelectionStyleNone;
    }
    
    if ([tableView indexPathIsMovingIndexPath:indexPath])
	{
		[cell prepareForMove];
	}
	else
	{
        //#warning Implement this check in your table view data source
		if (tableView.movingIndexPath != nil) {
            indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
		}
        TaskModel* atask = nil;
        if([indexPath section] == 0){
            atask = [_taskListNormal objectAtIndex:[indexPath row]];
        }else if([indexPath section] == 1){
            atask = [_taskListImportant objectAtIndex:[indexPath row]];
        }else if([indexPath section] == 2){
            atask = [_taskListFinish objectAtIndex:[indexPath row]];
        }
        [cell setTask:atask];
        cell.shouldIndentWhileEditing = NO;
        cell.showsReorderControl      = NO;
	}
    return cell;
}

#pragma mark- tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskModel* atask = nil;
    if([indexPath section] == 0) atask = [_taskListNormal objectAtIndex:[indexPath row]];
    else if([indexPath section] == 1) atask = [_taskListImportant objectAtIndex:[indexPath row]];
    else if([indexPath section] == 2)return;
    
    XPNewTaskVctler* updatevc = [[XPNewTaskVctler alloc] init];
    updatevc.viewType    = XPNewTaskViewType_Update;
    updatevc.task2Update = atask;
    [self.navigationController pushViewController:updatevc animated:YES];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray  *titleArray  = @[@"普通",@"重要",@"完成"];
    UIView* headview = [[UIView alloc] initWithFrame:CGRectZero];
    headview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    headview.backgroundColor = [UIColor whiteColor];
    headview.layer.borderWidth = 0.5;
    headview.layer.borderColor = [XPRGBColor(157, 157, 157, 0.8) CGColor];
    headview.alpha = 0.85;
    
    UILabel* sectionTItle = [UILabel new];
    sectionTItle.frame    = CGRectMake(15, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.backgroundColor = kClearColor;
    sectionTItle.font       = [UIFont systemFontOfSize:18];
    sectionTItle.textColor  = [UIColor darkTextColor];
    sectionTItle.text = titleArray[section];
    [headview addSubview:sectionTItle];
    
    if (section != 2) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btn.tag   = kHeadViewBtnStartIdx + section;
        btn.frame = CGRectMake(CGRectGetWidth(tableView.frame)-50, 0, 40, 40);
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        [btn addTarget:self action:@selector(onAddTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:btn];
    }
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	//Uncomment these lines to enable moving a row just within it's current section
	//if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
	//	proposedDestinationIndexPath = sourceIndexPath;
	//}
	return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger se = indexPath.section;
    if (se == 0)
    {
        // save to core data
        TaskModel * task2Done = [_taskListNormal objectAtIndex:[indexPath row]];
        task2Done.status   = [NSNumber numberWithInt:XPTask_Type_Finish];
        [_taskListNormal removeObjectAtIndex:[indexPath row]];
        [self performSelector:@selector(reloadListByStatus:) withObject:nil afterDelay:0.5];
    }else if(se == 1)
    {
        // save to core data
        TaskModel * task2Done = [_taskListImportant objectAtIndex:[indexPath row]];
        task2Done.status   = [NSNumber numberWithInt:XPTask_Type_Finish];
        XPAppDelegate* app = [XPAppDelegate shareInstance];
        [app.coreDataMgr updateTask:task2Done
                            project:nil];
        [_taskListImportant removeObjectAtIndex:[indexPath row]];
        NSLog(@"important.count=%d",[_taskListImportant count]);
        [self performSelector:@selector(reloadListByStatus:) withObject:nil afterDelay:0.5];
    }else if(se == 2){
        [_taskListFinish removeObjectAtIndex:[indexPath row]];
    }

    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - UITableViewDataSource
// Override to support conditional rearranging of the table view.
- (BOOL)moveTableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.section == [toIndexPath section])
    {
        NSInteger se = fromIndexPath.section;
        if (se == 0) {
            [_taskListNormal exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        }else if(se == 1){
            [_taskListImportant exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        }
    }else
    {
        NSInteger se = fromIndexPath.section;
        NSMutableArray* tFromArray = nil;
        NSMutableArray* ToArray = nil;
        se == 0?(tFromArray=_taskListNormal):(se==1?(tFromArray=_taskListImportant):(tFromArray=_taskListFinish));
        se = toIndexPath.section;
        se == 0?(ToArray=_taskListNormal):(se==1?(ToArray=_taskListImportant):(ToArray=_taskListFinish));
        
        if (!tFromArray || !ToArray) {
            return;
        }
        TaskModel* task2Move = [tFromArray objectAtIndex:[fromIndexPath row]];
        // remove to array
        [ToArray insertObject:task2Move atIndex:[toIndexPath row]];
        // save to core data
        XPAppDelegate* app = [XPAppDelegate shareInstance];
        if ([toIndexPath section] == 1)
        {
            task2Move.status = [NSNumber numberWithInt:XPTask_Type_Important];
        }else
        {
            task2Move.status = [NSNumber numberWithInt:XPTask_Type_Normal];
        }
        [app.coreDataMgr updateTask:task2Move
                            project:nil];
        
        [tFromArray removeObject:task2Move];
    }
}

#pragma mark - 
-(void)reLoadData{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    {   // Normal
        NSArray* normalList = [app.coreDataMgr selectTaskByDay:[NSDate date] status:0];
        if (normalList && [normalList count]) {
            [_taskListNormal removeAllObjects];
            [_taskListNormal setArray:normalList];
        }else{
            [_taskListNormal removeAllObjects];
        }
    }
    
    {
        NSArray* importantList = [app.coreDataMgr selectTaskByDay:[NSDate date] status:1];
        if (importantList && [importantList count]) {
            [_taskListImportant removeAllObjects];
            [_taskListImportant setArray:importantList];
        }else{
            [_taskListImportant removeAllObjects];
        }
    }
    
    {
        NSArray* finishList = [app.coreDataMgr selectTaskByDay:[NSDate date] status:2];
        if (finishList && [finishList count]) {
            [_taskListFinish removeAllObjects];
            [_taskListFinish setArray:finishList];
        }else{
            [_taskListFinish removeAllObjects];
        }
    }
}

-(void)reloadListByStatus:(int)status
{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSArray* finishList = [app.coreDataMgr selectTaskByDay:[NSDate date] status:2];
    if (finishList && [finishList count]) {
        [_taskListFinish removeAllObjects];
        [_taskListFinish setArray:finishList];
    }else{
        [_taskListFinish removeAllObjects];
    }
    NSIndexSet* inset = [[NSIndexSet alloc] initWithIndex:2];
    [self.tableView reloadSections:inset
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Navigation
-(void)onNavRightBtuAction:(id)sender{
    
}

#pragma mark - view Buttons
-(void)onAddTaskButtonAction:(id)sender{
    UIButton* btn = (UIButton*)sender;

    XPNewTaskVctler* newTvctl = [[XPNewTaskVctler alloc] init];
    if (btn.tag == kHeadViewBtnStartIdx) {
        newTvctl.viewType = XPNewTaskViewType_NewNormal;
    }else{
        newTvctl.viewType = XPNewTaskViewType_NewImportant;
    }
    [self.navigationController pushViewController:newTvctl animated:YES];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}

@end
