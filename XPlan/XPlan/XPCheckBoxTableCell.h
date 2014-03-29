//
//  XPCheckBoxTableCell.h
//  XPlan
//
//  Created by mjlee on 14-3-23.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPCheckBoxTableCell : UITableViewCell
@property(nonatomic,setter = setCheck:)        BOOL ifCheck;
@property(nonatomic,strong) UILabel* labContent;


-(void)setDialyTaskContent:(NSString*)content;

@end
