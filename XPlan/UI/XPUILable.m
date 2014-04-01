//
//  XPLable.m
//  XPlan
//
//  Created by mjlee on 14-3-10.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPUILable.h"

@implementation XPUILable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.StrikeThrough){
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGFloat red[4] = {.68f,.60f, .68f,0.8f}; //红色
        //CGFloat black[4] = {0.0f, 0.0f, 0.0f, 0.5f};//黑色
        CGContextSetStrokeColor(c, red);
        CGContextSetLineWidth(c, 0.5);
        CGContextBeginPath(c);
        //画直线
        //CGFloat halfWayUp = rect.size.height/2 + rect.origin.y;
        //CGContextMoveToPoint(c, rect.origin.x, halfWayUp );//开始点
        //CGContextAddLineToPoint(c, rect.origin.x + rect.size.width, halfWayUp);//结束点
        //画斜线
        NSDictionary*attdict = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil];
        CGSize tsize   = [self.text sizeWithAttributes:attdict];
        
        CGFloat height = rect.size.height/self.numberOfLines;
        CGFloat width  = tsize.width;
        for (int i = 0; i < self.numberOfLines; i++){
            CGContextMoveToPoint(c, rect.origin.x, height );
            if (width < tsize.width) {
                CGContextAddLineToPoint(c, (rect.origin.x + rect.size.width), height);//斜线
            }else{
                CGContextAddLineToPoint(c, (rect.origin.x + width), height);//斜线
            }
            height += height;
            width  -= rect.size.width;
        }
        CGContextStrokePath(c);
    }
    [super drawRect:rect];
}*/
@end
