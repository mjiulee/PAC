//
//  XPRootViewCtl.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPRootViewCtl.h"
#import "UIImage+XPUIImage.h"
#import "IIViewDeckController.h"
#import "XPNewTaskVctler.h"
#import "XPNewProjectVctler.h"
#import "XPAppDelegate.h"

@interface XPRootViewCtl ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _taskList;
    NSMutableArray* _projectList;
    UITableView*    _tableview;
}
@property(nonatomic,strong,readonly) UIButton* btnMask;

-(void)setTitleByListType:(XPRootListType)type;
-(BOOL)openLeftView;
-(void)onNavRightBtuAction:(id)sender;
-(void)reLoadData;
@end

@implementation XPRootViewCtl

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _XPListType= XPRootList_List_Type_Normal;
        _taskList = [[NSMutableArray alloc] init];
        _projectList = [[NSMutableArray alloc] init];
        // load data From Core Data
        [self reLoadData];
        
        // view setting
        [self setTitleByListType:_XPListType];
        UIImage* imgnormal   = [UIImage imageNamed:@"nav_btn_menu01"];
        UIImage* imhighLight = [UIImage imageNamed:@"nav_btn_menu02"];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
        [btn setImage:imgnormal   forState:UIControlStateNormal];
        [btn setImage:imhighLight forState:UIControlStateHighlighted];
        [btn addTarget:self
                action:@selector(openLeftView)
      forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftBtn;
        
        //
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(onNavRightBtuAction:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
                                              style:UITableViewStylePlain];
    _tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableview.delegate   = self;
    _tableview.dataSource = self;
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _XPListType == XPRootList_List_Type_Normal?[_taskList count]:[_projectList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (_XPListType == XPRootList_List_Type_Normal) {
        TaskModel* atask    = [_taskList objectAtIndex:[indexPath row]];
        //NSLog(@"task at (%d)=%@",[indexPath row],atask.description);
        cell.textLabel.text = [atask valueForKey:@"brief"];
    }else{
        ProjectModel* aproj    = [_projectList objectAtIndex:[indexPath row]];
        //NSLog(@"task at (%d)=%@",[indexPath row],aproj.description);
        cell.textLabel.text = [aproj valueForKey:@"name"];
    }
    return cell;
}

#pragma mark- tableviewdelegate
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
//    return 44;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_XPListType == XPRootList_List_Type_Normal) {
        TaskModel* atask    = [_taskList objectAtIndex:[indexPath row]];
        XPNewTaskVctler* updatevc = [[XPNewTaskVctler alloc] init];
        updatevc.viewType    = XPNewTaskViewType_Update;
        updatevc.task2Update = atask;
        [self.navigationController pushViewController:updatevc animated:YES];
    }else{
        
    }
}


#pragma mark - functions
-(void)setXPRootListType:(XPRootListType)type
{
    [self setTitleByListType:type];
    _XPListType = type;
    [self reLoadData];
    [_tableview reloadData];
}

-(void)setTitleByListType:(XPRootListType)type
{
    if (type == XPRootList_List_Type_Normal) {
        self.title = @"列表";
    }else{
        self.title = @"项目";
    }
}

-(void)reLoadData{
    XPAppDelegate* app = [XPAppDelegate shareInstance];
    if (_XPListType == XPRootList_List_Type_Normal) {
        NSArray* todaylist = [app.coreDataMgr selectTaskByDay:[NSDate date]];
        
        if (todaylist && [todaylist count]) {
            [_taskList removeAllObjects];
            [_taskList setArray:todaylist];
        }
    }else{
        NSArray* pList = [app.coreDataMgr selectProject:1 size:20];
        if (pList && [pList count]) {
            [_projectList removeAllObjects];
            [_projectList setArray:pList];
        }
    }
}

-(void)onNavRightBtuAction:(id)sender
{
    if (_XPListType == XPRootList_List_Type_Normal) {
        XPNewTaskVctler* newTvctl = [[XPNewTaskVctler alloc] init];
        [self.navigationController pushViewController:newTvctl animated:YES];
    }else{
        XPNewProjectVctler*newTvctl = [[XPNewProjectVctler alloc] init];
        [self.navigationController pushViewController:newTvctl animated:YES];
    }
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
