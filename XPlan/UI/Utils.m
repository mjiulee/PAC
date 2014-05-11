//
//  Utils.m
//  XPlan
//
//  Created by mjlee on 14-5-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (UIImage *)capture:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
