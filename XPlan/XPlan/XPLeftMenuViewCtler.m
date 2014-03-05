//
//  XPLeftMenuViewCtler.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPLeftMenuViewCtler.h"
#import "XPAppDelegate.h"
#import "XPProjectViewCtler.h"
#import "XPTaskListVCtler.h"
#import "XPDialyStaticVCtler.h"

@interface XPLeftMenuViewCtler ()

@end

@implementation XPLeftMenuViewCtler

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.automaticallyAdjustsScrollViewInsets = YES;
        //self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSArray  *section1TextArray  = @[@"今日任务",@"任务项目"];
    NSArray  *section2TextArray  = @[@"今日统计计图标",@"项目统计图标"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([indexPath section] == 0)
    {
        cell.textLabel.text = section1TextArray[[indexPath row]];
    }else
    {
        cell.textLabel.text = section2TextArray[[indexPath row]];
    }
    return cell;
}

#pragma mark- tableviewdelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray  *titleArray  = @[@"任务列表",@"统计图标"];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray  *titleArray  = @[@"任务列表",@"统计图标"];
    return [titleArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller){
        if ([indexPath section] == 0 && [indexPath row] == 0)
        {
            XPTaskListVCtler*centervc = [[XPTaskListVCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
            [self.viewDeckController setCenterController:rootNav];
        }else if([indexPath section] == 0 && [indexPath row] == 1)
        {
            XPProjectViewCtler* centervc = [[XPProjectViewCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
            [self.viewDeckController setCenterController:rootNav];
        }else if([indexPath section] == 1 && [indexPath row] == 0){
            XPDialyStaticVCtler* dialystaticVc = [[XPDialyStaticVCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:dialystaticVc];
            [self.viewDeckController setCenterController:rootNav];
        }else if([indexPath section] == 1 && [indexPath row] == 1){
            XPDialyStaticVCtler* dialystaticVc = [[XPDialyStaticVCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:dialystaticVc];
            [self.viewDeckController setCenterController:rootNav];
        }
    }];
}

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
