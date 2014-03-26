//
//  XPDialyStaticVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDialyStaticVCtler.h"
#import "PNChart.h"

static const NSUInteger kScrollViewPageIndex = 1000;

@interface XPDialyStaticVCtler ()
@property(nonatomic,strong)UIScrollView*contentScrollview;
@property(nonatomic)NSInteger pageIndex;

-(void)onNavLeftBtnAction:(id)sender;
@end

@implementation XPDialyStaticVCtler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务统计";
	// Do any additional setup after loading the view.
    // nav left
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_back_1"];
    UIImage* imhighLight = [UIImage imageNamed:@"nav_icon_back_2"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, imgnormal.size.width/2, imgnormal.size.height/2);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn setImage:imhighLight forState:UIControlStateHighlighted];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0,-10, 0, 0)];
    [btn addTarget:self action:@selector(onNavLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    if(self.taskDatas)
    {
        CGFloat yvalstart = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UIScrollView* sclview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yvalstart,
                                                                               CGRectGetWidth(self.view.frame),
                                                                               CGRectGetHeight(self.view.frame)-yvalstart)];
        sclview.showsVerticalScrollIndicator  = NO;
        sclview.showsHorizontalScrollIndicator= NO;
        sclview.pagingEnabled  = YES;
        sclview.delegate = self;
        [self.view addSubview:sclview];
        self.contentScrollview = sclview;

        CGFloat xval = 0;
        for (int i =0;i < 3; i ++)
        {
            UIView* tpageview = [[UIView alloc] initWithFrame:CGRectMake(xval,0,
                                                                         CGRectGetWidth(self.contentScrollview.frame),
                                                                         CGRectGetHeight(self.contentScrollview.frame))];
            tpageview.tag = kScrollViewPageIndex+i;
            [self.contentScrollview addSubview:tpageview];
            xval  += CGRectGetWidth(self.contentScrollview.frame);
        }
        self.contentScrollview.contentSize = CGSizeMake(xval,0);
        
        {   // barchar
            UIView* tview = [self.contentScrollview viewWithTag:kScrollViewPageIndex+0];
            {
                NSNumber* important = [self.taskDatas objectForKey:@"important"];
                NSNumber* normal     = [self.taskDatas objectForKey:@"normal"];
                NSNumber* finished  = [self.taskDatas objectForKey:@"finished"];
                
                PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0,30.0,CGRectGetWidth(self.view.frame), 200.0)];
                [barChart setXLabels:@[@"普通",@"重要",@"已完成"]];
                [barChart setYValues:@[normal,important,finished]];
                [barChart strokeChart];
                [tview addSubview:barChart];
            }
        }
        /*
        {   // cycle chart
            UIView* tview = [self.contentScrollview viewWithTag:1];
            if(tview)
            {
                NSNumber* total     = [self.taskDatas objectForKey:@"total"];
                NSNumber* finished  = [self.taskDatas objectForKey:@"finished"];
                CGFloat fpercent = [finished unsignedIntegerValue]/[total floatValue];
                
                PNCircleChart * circleChart
                = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 40.0,CGRectGetWidth(self.view.frame), 100.0)
                                              andTotal:[NSNumber numberWithInt:1]
                                            andCurrent:[NSNumber numberWithFloat:fpercent]];
                circleChart.backgroundColor = [UIColor clearColor];
                [circleChart setStrokeColor:PNGreen];
                [circleChart strokeChart];
                [tview addSubview:circleChart];
            }
        }
        
        {   // 本屌的评论
            /00~10%:爷， xxxx/
            /00~10%:爷， xxxx/
            /50~80%:爷， xxxx/
            /80~95%:爷， xxxx/
            /95~100%:爷，xxxx
            UIView* tview = [self.contentScrollview viewWithTag:2];
            if(tview){
                NSNumber* total    = [self.taskDatas objectForKey:@"total"];
                NSNumber* finished = [self.taskDatas objectForKey:@"finished"];
                CGFloat fpercent = [finished unsignedIntegerValue]/[total floatValue];
                NSString* brief  = @"";
                if (fpercent < 0.1) {
                    brief = @"妈蛋，今天你不用干活吗？\r这效率吃屎都抢不过别人啊.\r亲，你这么懒，你爸妈知道不？";
                }else if(fpercent < 0.5){
                    brief = @"妈蛋，一天的活才做不到一半.\r亲，你这么混日子，还想迎娶高富帅/嫁个白富美不？\r还想就滚回去干活!";
                }else if(fpercent < 0.8){
                    brief = @"哎呦，效率不错嘛，亲.\r再接再厉，本屌看好你哦！";
                }else if(fpercent < 0.95){
                    brief = @"我插咧，效率爆表啊，亲.\r你这是发粪图强，努力上进，不久当上CEO，迎娶白富美，走向人生巅峰的节奏吗?";
                }else {
                    brief = @"我插咧，效率报表啊，亲。\r你这是发粪图强,粪力上进,努力当上CEO,迎娶白富美,走向人生巅峰的节奏吗?";
                }
                
                UILabel* labEmpty = [[UILabel alloc] init];
                labEmpty.font  = [UIFont systemFontOfSize:15];
                labEmpty.textAlignment = NSTextAlignmentCenter;
                labEmpty.numberOfLines = 0;
                if ([UIDevice isRunningOniPhone5]) {
                    labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame)/2);
                }else{
                    labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame)*2/3);
                }
                labEmpty.text = brief;
                labEmpty.textColor= XPRGBColor(157,157, 157, 1.0);
                [tview addSubview:labEmpty];
            }
        }*/
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav button actions
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  UIScrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    if (self.pageIndex != page) {
        self.pageIndex = page;
        [self setPageView:self.pageIndex];
    }
}

-(void)setPageView:(NSUInteger)page
{
    if (page == 0)
    {
        UIView* tview = [self.contentScrollview viewWithTag:kScrollViewPageIndex+page];
        if(tview)
        {
            [[tview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSNumber* important = [self.taskDatas objectForKey:@"important"];
            NSNumber* normal     = [self.taskDatas objectForKey:@"normal"];
            NSNumber* finished  = [self.taskDatas objectForKey:@"finished"];
            
            PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0,30.0,CGRectGetWidth(self.view.frame), 200.0)];
            [barChart setXLabels:@[@"普通",@"重要",@"已完成"]];
            [barChart setYValues:@[normal,important,finished]];
            [barChart strokeChart];
            [tview addSubview:barChart];
        }
    }else if(page == 1)
    {
        UIView* tview = [self.contentScrollview viewWithTag:kScrollViewPageIndex+page];
        if(tview)
        {
            [[tview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSNumber* total     = [self.taskDatas objectForKey:@"total"];
            NSNumber* finished  = [self.taskDatas objectForKey:@"finished"];
            CGFloat fpercent = [finished unsignedIntegerValue]/[total floatValue];
            
            PNCircleChart * circleChart
            = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 40.0,CGRectGetWidth(self.view.frame), 100.0)
                                          andTotal:[NSNumber numberWithInt:1]
                                        andCurrent:[NSNumber numberWithFloat:fpercent]];
            circleChart.backgroundColor = [UIColor clearColor];
            [circleChart setStrokeColor:PNGreen];
            [circleChart strokeChart];
            [tview addSubview:circleChart];
        }
    }else if(page == 2)
    {
        UIView* tview = [self.contentScrollview viewWithTag:kScrollViewPageIndex+page];
        if(tview){
            [[tview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSNumber* total    = [self.taskDatas objectForKey:@"total"];
            NSNumber* finished = [self.taskDatas objectForKey:@"finished"];
            CGFloat fpercent = [finished unsignedIntegerValue]/[total floatValue];
            NSString* brief  = @"";
            if (fpercent < 0.1) {
                brief = @"妈蛋，今天你不用干活吗？\r这效率吃屎都抢不过别人啊.\r亲，你这么懒，你爸妈知道不？";
            }else if(fpercent < 0.5){
                brief = @"妈蛋，一天的活才做不到一半.\r亲，你这么混日子,\r还想迎娶高富帅/嫁个白富美不？\r还想就滚回去干活!";
            }else if(fpercent < 0.8){
                brief = @"哎呦，效率不错嘛，亲.\r再接再厉，本屌看好你哦！";
            }else if(fpercent < 0.95){
                brief = @"我插咧，效率爆表啊，亲.\r你这是发粪图强，努力上进，不久当上CEO，迎娶白富美，走向人生巅峰的节奏吗?";
            }else {
                brief = @"我插咧，效率报表啊，亲。\r你这是发粪图强,粪力上进,努力当上CEO,迎娶白富美,走向人生巅峰的节奏吗?";
            }
            
            UILabel* labEmpty = [[UILabel alloc] init];
            labEmpty.font  = [UIFont systemFontOfSize:15];
            labEmpty.textAlignment = NSTextAlignmentCenter;
            labEmpty.numberOfLines = 0;
            if ([UIDevice isRunningOniPhone5]) {
                labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame)/2);
            }else{
                labEmpty.frame = CGRectMake(20, 0, CGRectGetWidth(tview.frame)-40, CGRectGetHeight(tview.frame)*2/3);
            }
            labEmpty.text = brief;
            labEmpty.textColor= XPRGBColor(157,157, 157, 1.0);
            [tview addSubview:labEmpty];
        }
    }
}


@end
