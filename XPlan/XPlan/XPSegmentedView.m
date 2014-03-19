//
//  XPSegmentedView.m
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPSegmentedView.h"
#import "XPMathHelper.h"

@interface XPSegmentedView()
@property(nonatomic)NSUInteger curSelectIndex;
@property(nonatomic)BOOL       selectAnimating;
@property(nonatomic,strong) UIView* indexView;
@end

@implementation XPSegmentedView

-(id)initWithFrame:(CGRect)frame items:(NSString*)firstObj, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor    = XPRGBColor(245, 245, 245, 1.0);
        
        NSMutableArray* tempAry = [[NSMutableArray alloc] init];
        [tempAry addObject:firstObj];

        va_list arglist;
        va_start(arglist, firstObj);
        NSString* item;
        while (YES)
        {
            item = va_arg(arglist, id);
            if (!item) {
                break;
            }
            [tempAry addObject:item];
        }
        va_end(arglist);
        
        // for 设置buttons
        NSUInteger count = [tempAry count];
        if (count > 0)
        {
            CGFloat width  = CGRectGetWidth(frame)/count;
            CGFloat height = CGRectGetHeight(frame);
            UIFont* font   = [UIFont systemFontOfSize:15];
            UIColor* colorNormal = XPRGBColor(57, 57, 57, 1.0);
            UIColor* colorSelect = XPRGBColor(255, 255, 255, 1.0);
            NSUInteger tagidx = 0;
            CGFloat  xval = 0;
            for (NSString* title in tempAry)
            {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(xval,0,width,height);
                [btn.titleLabel setFont:font];
                [btn.titleLabel setNumberOfLines:2];
                [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [btn setTitle:title forState:UIControlStateNormal];
                
                [btn setTitleColor:colorNormal forState:UIControlStateNormal];
                [btn setTitleColor:colorSelect forState:UIControlStateSelected];
                
                [btn addTarget:self
                        action:@selector(onBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                if (tagidx == 0)
                {
                    UIView* indexView   = [UIView new];
                    indexView.frame = CGRectZoom(btn.frame, 2,2);
                    NSLog(@"indexView.frame=%@",NSStringFromCGRect(indexView.frame));
                    indexView.backgroundColor  = [UIColor colorWithRed:249/255.0
                                                                 green:137/255.0
                                                                  blue:50/255.0
                                                                 alpha:1.0];
                    indexView.layer.shadowColor  = XPRGBColor(57,57,57, 1.0).CGColor;
                    indexView.layer.shadowOffset = CGSizeMake(.5,.5);
                    indexView.layer.shadowOpacity= 1;
                    indexView.layer.shadowPath  = [UIBezierPath bezierPathWithRect:indexView.bounds].CGPath;
                    [self addSubview:indexView];
                    
                    self.indexView      = indexView;
                    self.curSelectIndex = 0;
                    [self sendSubviewToBack:indexView];
                }
                btn.tag   = tagidx ++ ;
                xval += width;
            }
        }
    }
    return self;
}

-(void)selectAtIndex:(NSUInteger)index
{
    if (self.curSelectIndex == index) {
        return ;
    }
    
    UIButton* btnTarget = nil;
    for (UIView* tv in [self subviews])
    {
        if ([tv isKindOfClass:[UIButton class]] == NO)
        {
            continue;
        }
        UIButton* tbtn = (UIButton*)tv;
        if (tbtn.tag == index) {
            btnTarget = tbtn;
            break;
        }
    }
    if (btnTarget) {
        [self onBtnAction:btnTarget];
    }
}

-(void)onBtnAction:(id)sender
{
    if (self.selectAnimating)
    {
        return;
    }
    
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag;
    if (tag == self.curSelectIndex)
    {
        return;
    }
    
    for (UIView* tv in [self subviews])
    {
        if ([tv isKindOfClass:[UIButton class]] == NO)
        {
            continue;
        }
        UIButton* tbtn = (UIButton*)tv;
        [tbtn setSelected:NO];
    }
    self.curSelectIndex = btn.tag;
    
    [UIView animateWithDuration:0.25 animations:^(void)
    {
        self.selectAnimating = YES;
        self.indexView.frame = CGRectZoom(btn.frame, 2,2);
    } completion:^(BOOL finish)
    {
        [btn setSelected:YES];
        self.selectAnimating  = NO;
        if (self.segmentedBlock) {
            self.segmentedBlock(tag);
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
