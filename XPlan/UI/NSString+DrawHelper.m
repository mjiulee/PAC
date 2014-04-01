//
//  NSString+DrawHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "NSString+DrawHelper.h"

@implementation NSString (DrawHelper)


-(CGSize)sizeThatNeed2Draw:(CGFloat)width font:(UIFont*)font{
    NSDictionary*attdict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize tsize = [self boundingRectWithSize:CGSizeMake(width, 2000.0)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:attdict
                                      context:nil].size;
    return tsize;
}


@end
