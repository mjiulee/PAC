//
//  XPProjectViewCtler.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPProjectViewCtler.h"
#import "UIImage+XPUIImage.h"
#import "IIViewDeckController.h"
#import "XPNewProjectVctler.h"
#import "XPAppDelegate.h"
#import "NSString+DrawHelper.h"


@interface XPProjectViewCtler ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _taskList;
    NSMutableArray* _projectList;
    UITableView*    _tableview;
}
@property(nonatomic,strong,readonly) UIButton* btnMask;
-(void)onNavRightBtuAction:(id)sender;
-(void)reLoadData;
@end

@implementation XPProjectViewCtler

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _taskList = [[NSMutableArray alloc] init];
        _projectList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"项目列表";
    self.view.backgroundColor = [UIColor whiteColor];
    // nav setting
    UIBarButtonItem* rightBtn =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNavRightBtuAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // tableview
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                                               CGRectGetHeight(self.view.frame))
                                              style:UITableViewStylePlain];
    _tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableview];
    [_tableview reloadData];
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
    [_tableview reloadData];
}

#pragma mark - UItableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_projectList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    ProjectModel* aproj    = [_projectList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [aproj valueForKey:@"name"];
    return cell;
}

#pragma mark- tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - functions
-(void)reLoadData{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    NSArray* pList = [app.coreDataMgr selectProject:0 size:20];
    if (pList && [pList count]) {
        [_projectList removeAllObjects];
        [_projectList setArray:pList];
    }
}

-(void)onNavRightBtuAction:(id)sender
{
    XPNewProjectVctler*newTvctl = [[XPNewProjectVctler alloc] init];
    [self.navigationController pushViewController:newTvctl animated:YES];
}

@end
