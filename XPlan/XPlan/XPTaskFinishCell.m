//
//  XPTaskFinishCell.m
//  XPlan
//
//  Created by mjlee on 14-3-7.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPTaskFinishCell.h"

@interface XPTaskFinishCell()
@end

@implementation XPTaskFinishCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10,8, 300,28)];
        lab.backgroundColor = kClearColor;
        lab.numberOfLines = 0;
        lab.backgroundColor = kClearColor;
        lab.font = [UIFont systemFontOfSize:15.0];
        lab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lab];
        self.labBrief = lab;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
