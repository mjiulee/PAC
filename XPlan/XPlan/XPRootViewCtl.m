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

@interface XPRootViewCtl ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableview;
}
@property(nonatomic,strong,readonly) UIButton* btnMask;

-(void)setTitleByListType:(XPRootListType)type;
-(BOOL)openLeftView;
-(void)onNavRightBtuAction:(id)sender;
@end

@implementation XPRootViewCtl

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _XPListType= XPRootList_List_Type_Normal;
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

#pragma mark - UItableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSArray  *cellTitle  = @[@"task-item-01",@"task-item-02"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = cellTitle[[indexPath row]];
    return cell;
}

#pragma mark- tableviewdelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray  *titleArray  = @[@"incoming",@"important",@"done"];
    UIView* headview = [UIView new];
    headview.backgroundColor = [UIColor colorWithRed:145/255.0
                                               green:145/255.0
                                                blue:145/255.0
                                               alpha:1.0];
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
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - functions
-(void)setXPRootListType:(XPRootListType)type
{
    [self setTitleByListType:type];
    _XPListType = type;
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

-(void)onNavRightBtuAction:(id)sender
{
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
