//
//  XPLeftMenuViewCtler.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPLeftMenuViewCtler.h"
#import "XPAppDelegate.h"
#import "XPTaskListVCtler.h"
#import "XPDialyStaticVCtler.h"
#import "XPHistoryListVctler.h"
#import "XPWeatherVctler.h"
#import "XPAboutMeVCtler.h"
#import "XPSettingVctler.h"

@interface XPLeftMenuViewCtler ()
//@property(nonatomic,strong) UINavigationController* dailyVctler;
//@property(nonatomic,strong) UINavigationController* historyVctler;
@end

@implementation XPLeftMenuViewCtler

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    if (section == 1) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSArray  *section1TextArray  = @[@"今日任务",@"历史任务"];
    NSArray  *section2TextArray  = @[@"天气情况",@"提醒设定",@"关于"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([indexPath section] == 0)
    {
        cell.textLabel.text = section1TextArray[[indexPath row]];
    }else if([indexPath section] == 1)
    {
        cell.textLabel.text = section2TextArray[[indexPath row]];
    }
    return cell;
}

#pragma mark- tableviewdelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray  *titleArray  = @[@"任务列表",@"其他"];
    UIView* headview = [UIView new];
    headview.backgroundColor = kClearColor;
    
    UILabel* sectionTItle = [[UILabel alloc] init];
    sectionTItle.frame    = CGRectMake(15, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.font       = [UIFont systemFontOfSize:14];
    sectionTItle.textColor  = [UIColor darkGrayColor];
    sectionTItle.text = titleArray[section];
    [headview addSubview:sectionTItle];
    return headview;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray  *titleArray  = @[@"任务列表",@"统计图标"];
    return [titleArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller)
    {
        if ([indexPath section] == 0 && [indexPath row] == 0)
        {
            XPTaskListVCtler*centervc = [[XPTaskListVCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
            [self.viewDeckController setCenterController:rootNav];
        }else if([indexPath section] == 0 && [indexPath row] == 1)
        {
            XPHistoryListVctler* centervc = [[XPHistoryListVctler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:centervc];
            [self.viewDeckController setCenterController:rootNav];
        }else if([indexPath section] == 1 && [indexPath row] == 0)
        {
            XPWeatherVctler* projStaticVc = [[XPWeatherVctler alloc] initWithNibName:@"XPWeatherVctler" bundle:nil];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:projStaticVc];
            [self.viewDeckController setCenterController:rootNav];
            return;
        }else if([indexPath section] == 1 && [indexPath row] == 1)
        {
            XPSettingVctler* settingvc = [[XPSettingVctler alloc] initWithNibName:@"XPSettingVctler" bundle:nil];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:settingvc];
            [self.viewDeckController setCenterController:rootNav];
            return;
        }else if([indexPath section] == 1 && [indexPath row] == 2)
        {
            XPAboutMeVCtler* projStaticVc = [[XPAboutMeVCtler alloc] init];
            UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:projStaticVc];
            [self.viewDeckController setCenterController:rootNav];
            return;
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
