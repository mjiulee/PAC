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

-(void)setIfCheck:(BOOL)check{
    _ifCHeck = check;
    if (_group){
        for(XPUIRadioButton* tradio in  _group.radios){
            if (tradio != self) {
                [tradio privitesetCheck:NO];
            }
        }
    }
}

-(void)privitesetCheck:(BOOL)check{
    _ifCHeck = check;
    [self setNeedsDisplay];
    
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
   
//    if ([[UIDevice currentDevice].systemVersion floatValue ] < 7.0) {
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        NSDictionary*attdict = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:14],NSFontAttributeName,nil];
        CGSize tsize   = [_title sizeWithAttributes:attdict];
        CGFloat dy = (titleRect.size.height - tsize.height)/2;
        titleRect.origin.y   += dy;
        titleRect.size.height = tsize.height;
        [_title drawInRect:titleRect withAttributes:attdict];
    }else{
        /*
        CGSize tsize = [_title sizeWithFont:[UIFont systemFontOfSize:14]];
        CGFloat dy = (titleRect.size.height - tsize.height)/2;
        titleRect.origin.y   += dy;
        titleRect.size.height = tsize.height;
        [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:14]];*/
    }
#endif
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
    
    if (distance <= 8 && !_ifCHeck) {
        [self setIfCheck:!_ifCHeck];
        [self setNeedsDisplay];
    }
}

@end

@implementation XPUIRadioGroup
-(XPUIRadioGroup*)initWithRadios:(id)firstObj, ...
{
    self = [super init];
    if (self) {
         _radios = [[NSMutableArray alloc] init];
        [(XPUIRadioButton*)firstObj setGroup:self];
        [_radios addObject:firstObj];

        va_list arglist;
        va_start(arglist, firstObj);
        id radio;
        while (YES)
        {
            radio = va_arg(arglist, id);
            if (!radio) {
                break;
            }
            [(XPUIRadioButton*)radio setGroup:self];
            [_radios addObject:radio];
        }
        va_end(arglist);
    }
    return self;
}

-(NSString*)getSelectedValue{
    for (XPUIRadioButton* btn in _radios) {
        if ([btn ifCHeck]) {
            return btn.value;
        }
    }
    return @"";
}

@end

