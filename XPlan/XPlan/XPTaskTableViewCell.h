//
//  XPTaskTableViewCell.h
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMoveTableViewCell.h"

#define kTaskCellMaxWidth 300
#define kTaskCellFontSize 15.0

//@interface XPTaskTableViewCell : FMMoveTableViewCell{
@interface XPTaskTableViewCell : UITableViewCell{
}
+(CGSize)taskCellSize:(TaskModel*)task;

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
         tableview:(UITableView*)tableview;

-(void)setTask:(TaskModel*)atask;
@end
