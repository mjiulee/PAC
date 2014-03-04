//
//  XPTaskTableViewCell.m
//  XPlan
//
//  Created by mjlee on 14-3-2.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPTaskTableViewCell.h"
#import "NSString+DrawHelper.h"
#import "UIImage+XPUIImage.h"

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@interface XPTaskTableViewCell()
<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UILabel*  briefLabel;
@property(nonatomic,strong) UIImageView*  editBtn;
@property(nonatomic,strong) UIScrollView* scrollcontview;
@end


@implementation XPTaskTableViewCell

+(CGSize)taskCellSize:(TaskModel*)task
{
    CGSize tsize = [task.brief sizeThatNeed2Draw:kTaskCellMaxWidth
                                            font:[UIFont systemFontOfSize:kTaskCellFontSize]];
    tsize.height += 8*2;
    if (tsize.height < 44) {
        tsize.height = 44;
    }
    return tsize;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIScrollView* scrollcontview = [[UIScrollView alloc] init];
        scrollcontview.frame = CGRectMake(0, 0, 320, 44);
        scrollcontview.delegate      = self;
        scrollcontview.backgroundColor = [UIColor grayColor];
        scrollcontview.showsHorizontalScrollIndicator = NO;
        scrollcontview.scrollsToTop  = NO;
        scrollcontview.scrollEnabled = YES;
        
        UIView* contentView = [[UIView alloc] initWithFrame:scrollcontview.frame];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *contentViewParent = self;
        if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]){
            // iOS 7
            contentViewParent = [self.subviews objectAtIndex:0];
        }
        NSArray *cellSubviews = [contentViewParent subviews];
        for (UIView * tv in cellSubviews) {
            [contentView addSubview:tv];
        }
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10,8, kTaskCellMaxWidth,28)];
        lab.backgroundColor = kClearColor;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:kTaskCellFontSize];
        lab.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:lab];
        self.briefLabel = lab;
        
        UIImageView* btnEdtie = [[UIImageView alloc] init];
        btnEdtie.frame = CGRectMake(CGRectGetWidth(self.frame)-44, 0, 44, 44);
        btnEdtie.image = [UIImage imageNamed:@"nav_btn_menu01"];
        [contentView addSubview:btnEdtie];
        [contentView bringSubviewToFront:btnEdtie];
        self.editBtn = btnEdtie;
        // add to scrollview
        [scrollcontview addSubview:contentView];
        
        [self insertSubview:scrollcontview atIndex:0];
        self.scrollcontview = scrollcontview;
        scrollcontview.contentSize = CGSizeMake(321, 44);
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
    
    self.briefLabel.frame = CGRectMake(_briefLabel.frame.origin.x,8,kTaskCellMaxWidth,tsize.height);
    self.briefLabel.text  = atask.brief;
    
    tsize.height += 8*2;
    if (tsize.height < 44) {
        tsize.height = 44;
    }
    [self.editBtn setFrame:CGRectMake(CGRectGetMinX(_editBtn.frame),
                                      (tsize.height-CGRectGetHeight(_editBtn.frame))/2,
                                      CGRectGetWidth(_editBtn.frame),
                                      CGRectGetHeight(_editBtn.frame))];
}

-(void)onLongPressGesture:(UIPanGestureRecognizer*)panner{
    UITableView* tableview = (UITableView*)self.superview;
    [tableview setEditing:YES];
}

#pragma mark - UIScrollviewDelegaet
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // TODO:
     [self.scrollcontview setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // TODO:
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // TODO:
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // TODO:
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//}

@end
