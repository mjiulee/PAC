//
//  NSString+DrawHelper.h
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DrawHelper)
/*
 * @params
 * @width -- 指定的宽度
 * @return
 */
-(CGSize)sizeThatNeed2Draw:(CGFloat)width font:(UIFont*)font;
@end
