//
//  XPCheckBoxTableCell.m
//  XPlan
//
//  Created by mjlee on 14-3-23.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPCheckBoxTableCell.h"

@implementation XPCheckBoxTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
