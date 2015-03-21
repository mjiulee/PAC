//
//  XPWeeklyViewCtler.m
//  XPlan
//
//  Created by mjlee on 15/2/11.
//  Copyright (c) 2015年 mjlee. All rights reserved.
//

#import "XPWeeklyViewCtler.h"
#import "OMGToast.h"
#import "XPWeeklyTableViewCell.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface XPWeeklyViewCtler ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,weak) IBOutlet UITableView* tableview;
@property(nonatomic ,strong)NSString* cellIdentifier;
// datahelper
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchRtvctlerWeekly;
// selected
@property(nonatomic ,strong)NSMutableArray* selectedList;
@end

@implementation XPWeeklyViewCtler

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"周报助手";
    self.selectedList = [NSMutableArray new];
    {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                  target:self
                                                                                  action:@selector(onSendMail)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    _cellIdentifier = @"XPWeeklyTableViewCellId";
    [self.tableview registerNib:[UINib nibWithNibName:@"XPWeeklyTableViewCell" bundle:nil]
         forCellReuseIdentifier:self.cellIdentifier];

    // Do any additional setup after loading the view from its nib.
    self.managedObjectContext = [XPDataManager shareInstance].managedObjectContext;
    NSError *error;
    if (![self.fetchRtvctlerWeekly performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    count = [[self.fetchRtvctlerWeekly sections] count];
    if (count > 2) { // 只读取近2周的内容
        count = 2;
    }
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController* ptrfrtctler = nil;
    ptrfrtctler = self.fetchRtvctlerWeekly;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[ptrfrtctler sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    cell.textLabel.font         = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines= 2;
    
    NSFetchedResultsController* ptrfrtctler = self.fetchRtvctlerWeekly;
    TaskModel *atask = [ptrfrtctler objectAtIndexPath:indexPath];
    if([atask.status integerValue] == 2) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:atask.content];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        cell.textLabel.attributedText = attributeString;
    }else{
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:atask.content];
        cell.textLabel.attributedText = attributeString;
    }
    BOOL selected = [self.selectedList containsObject:atask];
    if (selected) {
        cell.checkImageFlag.image = [UIImage imageNamed:@"btn_select_s"];
    }else{
        cell.checkImageFlag.image = [UIImage imageNamed:@"btn_select_n"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc] initWithFrame:CGRectZero];
    headview.autoresizingMask= UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    headview.backgroundColor = XPRGBColor(248, 248, 248, 0.88);
    
    UILabel* sectionTItle = [UILabel new];
    sectionTItle.frame    = CGRectMake(18, 0, 0, 0);
    sectionTItle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sectionTItle.backgroundColor = kClearColor;
    sectionTItle.font       = [UIFont systemFontOfSize:18];
    sectionTItle.textColor  = XPRGBColor(25, 133, 255, 1.0);
    
    NSFetchedResultsController* ptrfrtctler = self.fetchRtvctlerWeekly;
    id <NSFetchedResultsSectionInfo> theSection = [[ptrfrtctler sections] objectAtIndex:section];
    sectionTItle.text = [theSection name];;
    [headview addSubview:sectionTItle];
    
    UIView* divLine = [[UIView alloc] initWithFrame:CGRectMake(0,29, CGRectGetWidth(tableView.frame),1)];
    divLine.backgroundColor = XPRGBColor(220, 220, 220, 1.0);
    [headview addSubview:divLine];
    return headview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSFetchedResultsController* ptrfrtctler = self.fetchRtvctlerWeekly;
    TaskModel *atask = [ptrfrtctler objectAtIndexPath:indexPath];
    if ([self.selectedList containsObject:atask]) {
        [self.selectedList removeObject:atask];
    }else{
        [self.selectedList addObject:atask];
    }
    [self.tableview reloadData];
}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchRtvctlerWeekly{
    if (_fetchRtvctlerWeekly != nil)
    {
        return _fetchRtvctlerWeekly;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskModel"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:40];
    
    // Sort using the timeStamp property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreate" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchRtvctlerWeekly = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.managedObjectContext
                                                                 sectionNameKeyPath:@"sectionIdWeakly"
                                                                          cacheName:nil];
    _fetchRtvctlerWeekly.delegate = self;
    
    return _fetchRtvctlerWeekly;
}


#pragma mark - onSendMail
-(void)onSendMail{
    if (self.selectedList.count<=0) {
        [OMGToast showWithText:@"请先选择工作内容" topOffset:self.view.frame.size.height-100];
        return;
    }
    NSMutableString* bodyOfMessage = [NSMutableString new];
    int count = 1;
    for (TaskModel* atask in self.selectedList) {
        NSString* ifDone = @"未完成";
        if([atask.status integerValue] == 2) {
            ifDone = @"完成";
        }
        [bodyOfMessage appendFormat:@"%d、%@【%@】\r\n",count,atask.content,ifDone];
        count ++;
    }
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail]){
        [controller.navigationBar setTintColor:[UIColor redColor]];
        [controller setSubject:@"周报"];
        [controller setMessageBody:bodyOfMessage isHTML:NO];
        controller.mailComposeDelegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:^{
        } ];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"此设备不能发送邮件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result != MFMailComposeResultSent){
        [controller dismissViewControllerAnimated:YES completion:^{
            [OMGToast showWithText:@"周报尚未发送成功" topOffset:self.view.frame.size.height-100];
        }];
    }else{
        [controller dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
@end
