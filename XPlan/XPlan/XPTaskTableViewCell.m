//
//  XPTaskTableViewCell.m
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPTaskTableViewCell.h"
#import "NSString+DrawHelper.h"

@interface XPTaskTableViewCell()
<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UILabel* briefLabel;
@property(nonatomic,strong) UIPanGestureRecognizer* panner;
@end


@implementation XPTaskTableViewCell

+(CGSize)taskCellSize:(TaskModel*)task
{
    CGSize tsize = [task.brief sizeThatNeed2Draw:kTaskCellMaxWidth
                                            font:[UIFont systemFontOfSize:kTaskCellFontSize]];
    tsize.height += 8*2;
    if (tsize.height < 44) {
        tsize.height
        = 44;
    }
    return tsize;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10,8, kTaskCellMaxWidth,28)];
        lab.backgroundColor = kClearColor;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:kTaskCellFontSize];
        lab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lab];
        self.briefLabel = lab;
        
        UIPanGestureRecognizer* panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        panner.cancelsTouchesInView = YES;
        panner.delegate = self;
        [self addGestureRecognizer:panner];
        self.panner = panner;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTask:(TaskModel*)atask
{
    CGSize tsize = [atask.brief sizeThatNeed2Draw:kTaskCellMaxWidth
                                             font:[UIFont systemFontOfSize:kTaskCellFontSize]];

    if (tsize.height < 28) {
        tsize.height = 28;
    }
    self.briefLabel.frame = CGRectMake(_briefLabel.frame.origin.x,8,
                                           kTaskCellMaxWidth,
                                           tsize.height);
    self.briefLabel.text  = atask.brief;
}

-(void)panned:(UIPanGestureRecognizer*)panner{
    
}

#pragma mark - 
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//}

@end
