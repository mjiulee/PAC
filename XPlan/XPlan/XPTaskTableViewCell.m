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
static const CGFloat  kCellScrollMaxOffset = 100;

@interface XPTaskTableViewCell()
<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UILabel*  briefLabel;
@property(nonatomic,strong) UILabel*  labFinish;
@property(nonatomic,strong) UIImageView*  editBtn;
@property(nonatomic,strong) UIScrollView* scrollcontview;
@property(nonatomic,weak)   UITableView*  tableView;
// 选中处理
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, assign, getter = isShowingSelection) BOOL showingSelection;

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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableview:(UITableView*)tableview;

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tableView = tableview;
        
        UIScrollView* scrollcontview = [[UIScrollView alloc] init];
        scrollcontview.frame = CGRectMake(0, 0, 320, 44);
        scrollcontview.delegate      = self;
        scrollcontview.backgroundColor = [UIColor grayColor];
        scrollcontview.showsHorizontalScrollIndicator = NO;
        scrollcontview.scrollsToTop  = NO;
        scrollcontview.scrollEnabled = YES;
        
        UILabel* finish = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-44, 0, 44, 44)];
        finish.backgroundColor = kClearColor;
        finish.numberOfLines = 0;
        finish.font = [UIFont systemFontOfSize:kTaskCellFontSize];
        finish.textAlignment = NSTextAlignmentCenter;
        finish.textColor = kWhiteColor;
        finish.alpha= 0;
        [scrollcontview addSubview:finish];
        self.labFinish = finish;
        
        UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHandle:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [scrollcontview addGestureRecognizer:tapGestureRecognizer];

        
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
        lab.backgroundColor = kClearColor;
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
    if (self.scrollcontview.contentInset.right >= kCellScrollMaxOffset) {
       self.scrollcontview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.briefLabel.text  = atask.brief;
}

-(void)onLongPressGesture:(UIPanGestureRecognizer*)panner{
    UITableView* tableview = (UITableView*)self.superview;
    [tableview setEditing:YES];
}

#pragma mark - GestureHandel
-(void)onTapHandle:(UITapGestureRecognizer*)tapRecognizer{
    [self selectCellWithTimedHighlight];
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//}

#pragma mark - selecthandel
- (void)selectCell
{
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
        [self.tableView selectRowAtIndexPath:cellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
        [self.tableView deselectRowAtIndexPath:cellIndexPath animated:NO];
    }
}

- (void)selectCellWithTimedHighlight
{
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
        self.showingSelection = YES;
        [self setSelected:YES];
        [self.tableView selectRowAtIndexPath:cellIndexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
        
        // Make the selection visible
        NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.20
                                                                      target:self
                                                                    selector:@selector(timerEndCellHighlight:)
                                                                    userInfo:nil
                                                                     repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)highlightCell
{
    [self setHighlighted:YES];
}

- (void)timerEndCellHighlight:(id)sender
{
    self.showingSelection = NO;
    [self setSelected:NO];
}

#pragma mark UITableViewCell overrides
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _tableView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected
{
    [self updateHighlight:selected animated:NO];
}

#pragma mark - Highlighting methods
- (void)updateHighlight:(BOOL)highlight animated:(BOOL)animated;
{
    if (highlight) {
        [self setHighlighted:YES animated:animated];
    } else {
        // We are unhighlighting
        if (!self.isShowingSelection) {
            // Make sure we only deselect if we are done showing the selection with a highlight
            [self setHighlighted:NO];
        }
    }
}

#pragma mark - UIScrollviewDelegaet
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentInset.right >= kCellScrollMaxOffset) {
        return;
    }
    [self.scrollcontview setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // TODO:
    NSLog(@"scrollView.contentOffset.x=%0.2f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x >= kCellScrollMaxOffset)
    {
        if (scrollView.contentInset.right >= kCellScrollMaxOffset) {
            return;
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, kCellScrollMaxOffset);
        if (_tableView.dataSource && [_tableView.dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
            [_tableView.dataSource tableView:_tableView
                          commitEditingStyle:UITableViewCellEditingStyleNone
                           forRowAtIndexPath:cellIndexPath];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // TODO:
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // TODO:
}

@end
