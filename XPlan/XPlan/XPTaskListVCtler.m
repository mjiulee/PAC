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
    NSMutableArray* _taskList;
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
        _taskList = [[NSMutableArray alloc] init];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_taskList count];
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
    }
    
    TaskModel* atask    = [_taskList objectAtIndex:[indexPath row]];
    [cell setTask:atask];
    return cell;
}

#pragma mark- tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel* atask    = [_taskList objectAtIndex:[indexPath row]];
    CGSize tsize = [XPTaskTableViewCell taskCellSize:atask];
    return tsize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskModel* atask    = [_taskList objectAtIndex:[indexPath row]];
    XPNewTaskVctler* updatevc = [[XPNewTaskVctler alloc] init];
    updatevc.viewType    = XPNewTaskViewType_Update;
    updatevc.task2Update = atask;
    [self.navigationController pushViewController:updatevc animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray  *titleArray  = @[@"incoming",@"important",@"done"];
//    UIView* headview = [UIView new];
//    headview.backgroundColor = [UIColor colorWithRed:145/255.0
//                                               green:145/255.0
//                                                blue:145/255.0
//                                               alpha:1.0];
//    UILabel* sectionTItle = [UILabel new];
//    sectionTItle.frame    = CGRectMake(15, 0, 0, 0);
//    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    sectionTItle.font       = [UIFont systemFontOfSize:18];
//    sectionTItle.textColor  = [UIColor whiteColor];
//    sectionTItle.text = titleArray[section];
//    [headview addSubview:sectionTItle];
//    return headview;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - 
-(void)reLoadData{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSArray* todaylist = [app.coreDataMgr selectTaskByDay:[NSDate date]];
    if (todaylist && [todaylist count]) {
        [_taskList removeAllObjects];
        [_taskList setArray:todaylist];
    }
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
