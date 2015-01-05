//
//  XPStartupGuiderVctler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPStartupGuiderVctler.h"
#import "NSDate+Category.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "XPCheckBoxTableCell.h"
#import <objc/runtime.h>
#import "XPUserDataHelper.h"
#import "PNChart.h"
#import "XPDialyStaticVCtler.h"
#import "XPWeatherVctler.h"

// static Strings
static NSString*  const kBaiduAppKey = @"FC6d7d9088a8bea53220434268c189af";
// static Intergers

@interface XPStartupGuiderVctler ()
{
}
// page1
@property(nonatomic,strong) IBOutlet UIView* yestodayView;
@property(nonatomic,weak)   IBOutlet UIView* chartview;
@property(nonatomic,strong) IBOutlet UIButton* enterBtn;

-(IBAction)enterApp:(id)sender;

@end

@implementation XPStartupGuiderVctler

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
    self.view.backgroundColor = kWhiteColor;
    self.chartview.backgroundColor = [UIColor clearColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getStaticView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - page initial 

-(void)getStaticView
{
        /// data prepare
    NSDate* yestoday = [[NSDate date] dateBySubtractingDays:1];
    NSUInteger normal_ongoing=0,normal_done=0;
    NSUInteger important_ongoing=0,important_done=0;
    NSUInteger all_total =0,all_done=0,all_notdone = 0;
    {
        // 普通
        normal_ongoing   = [[XPDataManager shareInstance] taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_ongoing];
        normal_done      = [[XPDataManager shareInstance] taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_normal status:XPTask_Status_Done];
        // 总要
        important_ongoing=[[XPDataManager shareInstance] taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_important status:XPTask_Status_ongoing];
        important_done   =[[XPDataManager shareInstance] taskCoutByDay:yestoday prLevel:XPTask_PriorityLevel_important status:XPTask_Status_Done];
        // 全部
        all_total   = (normal_done+normal_ongoing+important_done+important_ongoing);
        all_done    = normal_done+important_done;
        all_notdone = normal_ongoing+important_ongoing;
    }
    {
        CGFloat fpercent = 0.0;
        if (all_total > 0) {
            fpercent = (normal_done+important_done)*1.0/all_total;
        }
        CGRect arect = CGRectMake(0,0,CGRectGetWidth(self.chartview.frame),CGRectGetWidth(self.chartview.frame)/3);
        PNCircleChart * circleChart
        = [[PNCircleChart alloc] initWithFrame:arect
                                      andTotal:[NSNumber numberWithInt:1]
                                    andCurrent:[NSNumber numberWithFloat:fpercent]];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart strokeChart];
        [self.chartview addSubview:circleChart];
        circleChart.center = CGPointMake(self.chartview.frame.size.width/2,self.chartview.frame.size.height/3);
    }
    
    {
        CGFloat yof = self.chartview.frame.size.height - 80;
        for(int i = 0;i < 3;i++)
        {
            UILabel* labtitle = [[UILabel alloc] initWithFrame:CGRectMake(10,yof,CGRectGetWidth(self.chartview.frame)-20,20)];
            labtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (i == 0) {
                // 普通：
                labtitle.attributedText = [self getAttributstring:@"普通："
                                                            total:normal_done+normal_ongoing
                                                             done:normal_done
                                                          notdone:normal_ongoing];
            }else if(i==1){
                labtitle.attributedText = [self getAttributstring:@"重要："
                                                            total:important_done+important_ongoing
                                                             done:important_done
                                                          notdone:important_ongoing];
            }else{
                labtitle.attributedText = [self getAttributstring:@"全部："
                                                            total:all_total
                                                             done:all_done
                                                          notdone:all_notdone];
            }
            labtitle.textAlignment   = NSTextAlignmentCenter;
            labtitle.backgroundColor = kClearColor;
            [self.chartview addSubview:labtitle];
            yof +=25;
        }
    }
}

-(NSMutableAttributedString*)getAttributstring:(NSString*)type total:(NSUInteger)total done:(NSUInteger)done notdone:(NSUInteger)notdone
{
    NSMutableAttributedString *atStrNormalType = [[NSMutableAttributedString alloc] initWithString:type];
    [atStrNormalType addAttribute:NSForegroundColorAttributeName
                            value:(id)XPRGBColor(156, 157, 158, 1.0)
                            range:NSMakeRange(0, [atStrNormalType length])];
    [atStrNormalType addAttribute:NSFontAttributeName
                            value:(id)[UIFont systemFontOfSize:13]
                            range:NSMakeRange(0, [atStrNormalType length])];
    // 条
    NSMutableAttributedString *atstrUnit = [[NSMutableAttributedString alloc] initWithString:@"条，"];
    [atstrUnit addAttribute:NSForegroundColorAttributeName
                      value:(id)XPRGBColor(156, 157, 158, 1.0)
                      range:NSMakeRange(0, [atstrUnit length])];
    [atstrUnit addAttribute:NSFontAttributeName
                      value:(id)[UIFont systemFontOfSize:13]
                      range:NSMakeRange(0, [atstrUnit length])];
    
    // 已完成
    NSMutableAttributedString *atStrDoneType = [[NSMutableAttributedString alloc] initWithString:@"已完成："];
    [atStrDoneType addAttribute:NSForegroundColorAttributeName
                          value:(id)XPRGBColor(156, 157, 158, 1.0)
                          range:NSMakeRange(0, [atStrDoneType length])];
    [atStrDoneType addAttribute:NSFontAttributeName
                          value:(id)[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, [atStrDoneType length])];
    
    // 未完成
    NSMutableAttributedString *atStrNotDoneType = [[NSMutableAttributedString alloc] initWithString:@"未完成："];
    [atStrNotDoneType addAttribute:NSForegroundColorAttributeName
                             value:(id)XPRGBColor(156, 157, 158, 1.0)
                             range:NSMakeRange(0, [atStrNotDoneType length])];
    [atStrNotDoneType addAttribute:NSFontAttributeName
                             value:(id)[UIFont systemFontOfSize:13]
                             range:NSMakeRange(0, [atStrNotDoneType length])];
    // numberType
    NSMutableAttributedString *strNormal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%u",total]];
    [strNormal addAttribute:NSForegroundColorAttributeName
                      value:(id)XPRGBColor(35,137, 255, 1.0)
                      range:NSMakeRange(0, [strNormal length])];
    [strNormal addAttribute:NSFontAttributeName
                      value:(id)[UIFont systemFontOfSize:13]
                      range:NSMakeRange(0, [strNormal length])];
    
    // numberType
    NSMutableAttributedString *strDone = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%u",done]];
    [strDone addAttribute:NSForegroundColorAttributeName
                    value:(id)XPRGBColor(35,137, 255, 1.0)
                    range:NSMakeRange(0, [strDone length])];
    [strDone addAttribute:NSFontAttributeName
                    value:(id)[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, [strDone length])];
    // numberType
    NSMutableAttributedString *strNotDone = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%u",notdone]];
    [strNotDone addAttribute:NSForegroundColorAttributeName
                       value:(id)XPRGBColor(35,137, 255, 1.0)
                       range:NSMakeRange(0, [strNotDone length])];
    [strNotDone addAttribute:NSFontAttributeName
                       value:(id)[UIFont systemFontOfSize:13]
                       range:NSMakeRange(0, [strNotDone length])];
    
    [atStrNormalType appendAttributedString:strNormal];
    [atStrNormalType appendAttributedString:atstrUnit];
    [atStrNormalType appendAttributedString:atStrDoneType];
    [atStrNormalType appendAttributedString:strDone];
    [atStrNormalType appendAttributedString:atstrUnit];
    [atStrNormalType appendAttributedString:atStrNotDoneType];
    [atStrNormalType appendAttributedString:strNotDone];
    
    return atStrNormalType;
}

-(IBAction)enterApp:(id)sender{
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(showTaskListDeckVctler)])
    {
        [[UIApplication sharedApplication].delegate performSelector:@selector(showTaskListDeckVctler)];
    }
}

@end
