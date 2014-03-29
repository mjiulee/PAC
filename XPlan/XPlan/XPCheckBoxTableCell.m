//
//  XPCheckBoxTableCell.m
//  XPlan
//
//  Created by mjlee on 14-3-23.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPCheckBoxTableCell.h"

@interface XPCheckBoxTableCell()
@property(nonatomic,strong) UIImageView* checkImageview;
@end


@implementation XPCheckBoxTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10,4, 260,42)];
        lab.backgroundColor = kClearColor;
        lab.numberOfLines = 2;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lab];
        self.labContent = lab;
        
        UIImageView* checkv = [[UIImageView alloc] initWithFrame:CGRectMake(320-55,11,28,28)];
        checkv.image  = [UIImage imageNamed:@"icon_check_01"];
        checkv.hidden = YES;
        [self addSubview:checkv];
        self.checkImageview = checkv;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDialyTaskContent:(NSString*)content
{
    self.labContent.text = content;
}

-(void)setCheck:(BOOL)check{
    _ifCheck = check;
    self.checkImageview.hidden = !self.ifCheck;
}

@end
