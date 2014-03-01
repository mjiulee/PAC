//
//  XPUIRadioButton.m
//  XPlan
//
//  Created by mjlee on 14-2-25.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPUIRadioButton.h"

@implementation XPUIRadioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Drawing code
    [super drawRect:rect];
    
    [[UIColor lightGrayColor] set];
    CGRect checkRect = CGRectMake(CGRectGetMinX(rect),
                                  CGRectGetMinY(rect),
                                  CGRectGetHeight(rect),
                                  CGRectGetHeight(rect));
    CGRect titleRect = CGRectMake(CGRectGetMaxX(checkRect),
                                  CGRectGetMinY(checkRect),
                                  CGRectGetWidth(rect)-CGRectGetHeight(rect),
                                  CGRectGetHeight(rect));
    
    CGRect inRc = CGRectMake((checkRect.size.width-10)/2,
                            (checkRect.size.height-10)/2,
                             10,10);
    CGRect ctRc = CGRectMake((checkRect.size.width-10)/2+1,
                             (checkRect.size.height-10)/2+1,
                             8,8);
    
    UIBezierPath * bezierpath =
    [UIBezierPath bezierPathWithRoundedRect:ctRc
                               cornerRadius:ctRc.size.height/2];
    if (_ifCHeck) {
        [[UIColor redColor] set];
        [bezierpath  fill];
    }

    [[UIColor lightGrayColor] set];
    bezierpath =
    [UIBezierPath bezierPathWithRoundedRect:inRc
                               cornerRadius:inRc.size.height/2];

    [bezierpath  stroke];
    
    CGRect outRc = CGRectMake(checkRect.origin.x+1,
                              checkRect.origin.y+1,
                              checkRect.size.width-2,
                              checkRect.size.height-2);
    bezierpath =
    [UIBezierPath bezierPathWithRoundedRect:outRc
                               cornerRadius:outRc.size.height/2];
    bezierpath.lineWidth = 1;
    [bezierpath  stroke];
    
    [[UIColor darkTextColor] set];
    
    CGSize tsize = [_title sizeWithFont:[UIFont systemFontOfSize:14]];
    CGFloat dy = (titleRect.size.height - tsize.height)/2;
    titleRect.origin.y   += dy;
    titleRect.size.height = tsize.height;
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:14]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    originalLocation = [touch locationInView:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    
    float xd = originalLocation.x - currentLocation.x;
    float yd = originalLocation.y - currentLocation.y;
    float distance = sqrt(xd*xd + yd*yd);
    
    if (distance <= 8) {
        [self setIfCHeck:!_ifCHeck];
        [self setNeedsDisplay];
    }
}

@end
