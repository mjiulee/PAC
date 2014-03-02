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
-(BOOL)openLeftView;
-(void)onNavRightBtuAction:(id)sender;
-(void)reLoadData;
@end

@implementation XPProjectViewCtler

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _taskList = [[NSMutableArray alloc] init];
        _projectList = [[NSMutableArray alloc] init];
        // load data From Core Data
        [self reLoadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    // view setting
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
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                                               CGRectGetHeight(self.view.frame))
                                              style:UITableViewStylePlain];
    _tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    [_tableview setSeparatorInset:UIEdgeInsetsZero];
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
    NSArray* pList = [app.coreDataMgr selectProject:1 size:20];
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
