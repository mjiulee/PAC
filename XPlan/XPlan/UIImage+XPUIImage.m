//
//  UIImage+XPUIImage.m
//  XPlan
//
//  Created by mjlee on 14-2-21.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "UIImage+XPUIImage.h"

@implementation UIImage (XPUIImage)
+(UIImage*)imageNamed:(NSString*)picname{
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"resource/%@",picname]
                                                     ofType:@"png"];
    //NSLog(@"path=%@",path);
    return [UIImage imageWithContentsOfFile:path];
}

@end
