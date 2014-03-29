//
//  XPAboutMeVCtler.m
//  XPlan
//
//  Created by mjlee on 14-3-19.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPAboutMeVCtler.h"

@interface XPAboutMeVCtler ()
-(void)onNavLeftBtnAction:(id)sender;
@property(nonatomic,strong)UIWebView* webview;
@end

@implementation XPAboutMeVCtler

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
    self.title = @"关于";

    CGFloat yof  = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGRect frame = CGRectMake(0,yof, CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-yof);
    UIWebView* webv = [[UIWebView alloc] initWithFrame:frame];
    webv.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    webv.scrollView.contentSize = CGSizeMake(webv.frame.size.width,0);
    [self.view addSubview:webv];
    self.webview = webv;
    
    NSString *basePath = [[NSBundle mainBundle] resourcePath];
    basePath = [NSString stringWithFormat:@"%@/resource",basePath];
    NSURL *   baseURL  = [NSURL fileURLWithPath:basePath];

    NSError* error;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"resource/about" ofType:@"html"];
    NSString* htmlstr  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    [self.webview loadHTMLString:htmlstr baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - navbutton actions
-(void)onNavLeftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
