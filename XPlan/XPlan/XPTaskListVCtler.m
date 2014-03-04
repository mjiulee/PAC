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

@interface XPTaskListVCtler ()
{
    NSMutableArray* _taskListNormal;
    NSMutableArray* _taskListImportant;
    NSMutableArray* _taskListFinish;
}
// NavButtons
-(void)onNavRightBtuAction:(id)sender;

// Datas
-(void)reLoadData;

//ViewDeck
-(BOOL)openLeftView;
@end

@implementation XPTaskListVCtler

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization，load data From Core Data
        _taskListNormal = [[NSMutableArray alloc] init];
        _taskListImportant = [[NSMutableArray alloc] init];;
        _taskListFinish = [[NSMutableArray alloc] init];;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.view.backgroundColor = [UIColor whiteColor];
    // navs setting
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_menu01"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_menu02"];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(openLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(onNavRightBtuAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // tableview
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //[self.tableView setEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reLoadData];
    [self.tableView reloadData];
}

#pragma mark -tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if(section == 0) count = [_taskListNormal count];
    if(section == 1) count = [_taskListImportant count];
    if(section == 2) count = [_taskListFinish count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTask";
    XPTaskTableViewCell *cell = (XPTaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[XPTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
    }
    
    TaskModel* atask = nil;
    if([indexPath section] == 0) atask = [_taskListNormal objectAtIndex:[indexPath row]];
    else if([indexPath section] == 1) atask = [_taskListImportant objectAtIndex:[indexPath row]];
    else if([indexPath section] == 2) atask = [_taskListFinish objectAtIndex:[indexPath row]];
    
    [cell setTask:atask];
    return cell;
}

#pragma mark- tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
    TaskModel* atask = nil;
    if([indexPath section] == 0) atask = [_taskListNormal objectAtIndex:[indexPath row]];
    else if([indexPath section] == 1) atask = [_taskListImportant objectAtIndex:[indexPath row]];
    else if([indexPath section] == 2) atask = [_taskListFinish objectAtIndex:[indexPath row]];

    CGSize tsize = [XPTaskTableViewCell taskCellSize:atask];
    return tsize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel* atask = nil;
    if([indexPath section] == 0) atask = [_taskListNormal objectAtIndex:[indexPath row]];
    else if([indexPath section] == 1) atask = [_taskListImportant objectAtIndex:[indexPath row]];
    else if([indexPath section] == 2) atask = [_taskListFinish objectAtIndex:[indexPath row]];

    XPNewTaskVctler* updatevc = [[XPNewTaskVctler alloc] init];
    updatevc.viewType    = XPNewTaskViewType_Update;
    updatevc.task2Update = atask;
    [self.navigationController pushViewController:updatevc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray  *titleArray  = @[@"普通",@"重要",@"完成"];
    UIView* headview = [UIView new];
    headview.backgroundColor = [UIColor colorWithRed:200/255.0
                                               green:200/255.0
                                                blue:200/255.0
                                               alpha:1.0];
    headview.alpha = 0.8;
    
    UILabel* sectionTItle = [UILabel new];
    sectionTItle.frame    = CGRectMake(15, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.font       = [UIFont systemFontOfSize:18];
    sectionTItle.textColor  = [UIColor whiteColor];
    sectionTItle.text = titleArray[section];
    [headview addSubview:sectionTItle];
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

#pragma mark - UITableViewDataSource
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//                         withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.section == [toIndexPath section])
    {
        NSInteger se = fromIndexPath.section;
        if (se == 0) {
            [_taskListNormal exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        }else if(se == 1){
            [_taskListImportant exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        }else if(se == 2){
            [_taskListFinish exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
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
        [ToArray insertObject:task2Move atIndex:[toIndexPath row]];
        [tFromArray removeObject:task2Move];
        // TODO:save order  & save status
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
    //NSArray* todaylist = [app.coreDataMgr selectTaskAll];
}

#pragma mark - Navigation
-(void)onNavRightBtuAction:(id)sender{
    XPNewTaskVctler* newTvctl = [[XPNewTaskVctler alloc] init];
    [self.navigationController pushViewController:newTvctl animated:YES];
}

#pragma mark - ViewDeck
-(BOOL)openLeftView{
    if ([self.viewDeckController isSideOpen:IIViewDeckLeftSide]) {
        if ([self.viewDeckController respondsToSelector:@selector(closeLeftViewAnimated:completion:)])
        {
            [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
            }];
        }
    }else{
        if ([self.viewDeckController respondsToSelector:@selector(openLeftViewAnimated:completion:)])
        {
            [self.viewDeckController openLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
            }];
        }
    }
    return YES;
}

@end
