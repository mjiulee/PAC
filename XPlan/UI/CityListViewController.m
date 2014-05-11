//
//  CityListViewController.m
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import "CityListViewController.h"
#import "XPCheckBoxTableCell.h"
#import "XPUserDataHelper.h"

@interface CityListViewController ()
@property(nonatomic,strong) NSIndexPath* selectedCityIndexPath;
@property(nonatomic,strong) NSString* szcity;
-(void)onNavLeftBtnAction:(id)sender;
@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
        self.szcity = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_WeatherCity];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择城市";
    // nav
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
    //UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    //[btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
    [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;

    // get the city list
    [self getCityData];    
	// Do any additional setup after loading the view.
    self.tableView.autoresizingMask= (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.backgroundColor = XPRGBColor(255, 255, 255, 1.0);
    self.tableView.separatorInset  = UIEdgeInsetsZero;
    self.tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.sectionIndexBackgroundColor = kClearColor;
    
    self.szcity = [[XPUserDataHelper shareInstance] getUserDataByKey:XPUserDataKey_WeatherCity];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[XPUserDataHelper shareInstance] setUserDataByKey:XPUserDataKey_WeatherCity value:self.szcity];
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"resource/citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    bgView.backgroundColor = XPRGBColor(248, 248, 248, 0.88);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 280, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = XPRGBColor(25, 133, 255, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }else{
        titleLabel.text = key;
    }
    [bgView addSubview:titleLabel];
    
    UIView* divLine = [[UIView alloc] initWithFrame:CGRectMake(0,29.5, CGRectGetWidth(tableView.frame), 0.5)];
    divLine.backgroundColor = XPRGBColor(220, 220, 220, 1.0);
    [bgView addSubview:divLine];
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    XPCheckBoxTableCell *cell = (XPCheckBoxTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XPCheckBoxTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    NSString* citystr = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    cell.labContent.text = citystr;
    if ([indexPath isEqual:self.selectedCityIndexPath] || [citystr isEqualToString:self.szcity])
    {
        if (self.selectedCityIndexPath == nil) {
            self.selectedCityIndexPath = indexPath;
        }
        [cell setCheck:YES];
    }else{
        [cell setCheck:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath* tempIndexPath= self.selectedCityIndexPath;
    if (tempIndexPath) {
        XPCheckBoxTableCell* cell = (XPCheckBoxTableCell* )[tableView cellForRowAtIndexPath:tempIndexPath];
        [cell setCheck:NO];
    }
    self.selectedCityIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    XPCheckBoxTableCell* cell = (XPCheckBoxTableCell* )[tableView cellForRowAtIndexPath:self.selectedCityIndexPath];
    [cell setCheck:YES];
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    self.szcity  = [NSString stringWithString:[[_cities objectForKey:key] objectAtIndex:[indexPath row]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
