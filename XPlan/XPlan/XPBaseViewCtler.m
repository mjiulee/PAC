//
//  XPBaseViewCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-5.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPBaseViewCtler.h"

@interface XPBaseViewCtler ()
-(BOOL)openLeftView;
@end

@implementation XPBaseViewCtler

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // view setting
    UIImage* imgnormal   = [UIImage imageNamed:@"nav_icon_menu"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 38,38);
    [btn setImage:imgnormal   forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewDeck
-(BOOL)openLeftView{
    if ([self.viewDeckController isSideOpen:IIViewDeckLeftSide])
    {
        if ([self.viewDeckController respondsToSelector:@selector(closeLeftViewAnimated:completion:)])
        {
            [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                self.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
            }];
        }
    }else
    {
        if ([self.viewDeckController respondsToSelector:@selector(openLeftViewAnimated:completion:)])
        {
            [self.viewDeckController openLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success){
                //self.viewDeckController.panningMode = IIViewDeckAllViewsPanning;
            }];
        }
    }
    return YES;
}
@end
