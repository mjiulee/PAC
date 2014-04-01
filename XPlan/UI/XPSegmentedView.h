//
//  XPSegmentedView.h
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XPSegmentedSelectBlock)(NSUInteger selectIdx);

@interface XPSegmentedView : UIView
@property(nonatomic)     NSInteger curSelectIndex;
@property(nonatomic,copy)XPSegmentedSelectBlock segmentedBlock;

-(id)initWithFrame:(CGRect)frame items:(NSString*)firstObj, ...NS_REQUIRES_NIL_TERMINATION;
-(void)selectAtIndex:(NSUInteger)index;
@end
