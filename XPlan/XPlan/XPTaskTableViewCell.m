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
static const CGFloat  kCellScrollMaxOffset = 80;

@interface XPTaskTableViewCell()
<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic)        BOOL      finished;
@property(nonatomic,strong) UILabel*  briefLabel;
@property(nonatomic,strong) UIImageView*  finishimg;
@property(nonatomic,strong) UIScrollView* scrollcontview;
@property(nonatomic,weak)   UITableView*  tableView;
// 选中处理
@property(nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@end


@implementation XPTaskTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableview:(UITableView*)tableview
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tableView = tableview;
        //self.backgroundColor = kWhiteColor;
        _finished = NO;
        
        UIScrollView* scrollcontview = [[UIScrollView alloc] init];
        scrollcontview.frame = CGRectMake(0, 0, 320, tableview.rowHeight);
        scrollcontview.delegate      = self;
        scrollcontview.backgroundColor = kWhiteColor;
        scrollcontview.showsHorizontalScrollIndicator = NO;
        scrollcontview.scrollsToTop  = NO;
        scrollcontview.scrollEnabled = YES;
        
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
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10,4, kTaskCellMaxWidth,tableview.rowHeight-4*2)];
        lab.backgroundColor = kClearColor;
        lab.numberOfLines = 2;
        lab.font = [UIFont systemFontOfSize:kTaskCellFontSize];
        lab.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:lab];
        self.briefLabel = lab;

        // add to scrollview
        [scrollcontview addSubview:contentView];
        [self insertSubview:scrollcontview atIndex:0];
        self.scrollcontview = scrollcontview;
        scrollcontview.contentSize = CGSizeMake(321, 44);
        
        UIImageView* finish = [[UIImageView alloc] initWithFrame:CGRectMake(320-40,11,28,28)];
        finish.image = [UIImage imageNamed:@"icon_check_01"];
        finish.alpha= 0;
        [self addSubview:finish];
        self.finishimg   = finish;
        
        UIView* divLine = [[UIView alloc] initWithFrame:CGRectMake(0,tableview.rowHeight-0.5, CGRectGetWidth(tableview.frame),0.5)];
        divLine.backgroundColor = XPRGBColor(220, 220, 220, 1.0);
        [self addSubview:divLine];
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
    
    if ([atask.status integerValue] == 2) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:atask.content];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        self.briefLabel.attributedText = attributeString;
        self.finished = YES;
    }else{
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:atask.content];
        self.briefLabel.attributedText = attributeString;
        self.finished = NO;
    }
}

//-(void)onLongPressGesture:(UIPanGestureRecognizer*)panner{
//    UITableView* tableview = (UITableView*)self.superview;
//    [tableview setEditing:YES];
//}

#pragma mark - GestureHandel
-(void)onTapHandle:(UITapGestureRecognizer*)tapRecognizer
{
    [self selectCellWithTimedHighlight];
}

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
        // self.showingSelection = YES;
        //[self setSelected:YES];
        [self.tableView selectRowAtIndexPath:cellIndexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
        
        // Make the selection visible
        NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.10
                                                                      target:self
                                                                    selector:@selector(timerEndCellHighlight:)
                                                                    userInfo:cellIndexPath
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
    NSTimer* timer = (NSTimer*)sender;
    NSIndexPath *cellIndexPath = timer.userInfo;
    
    if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.tableView.delegate performSelector:@selector(tableView:didSelectRowAtIndexPath:)
                                      withObject:self.tableView
                                      withObject:cellIndexPath];
    }
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
        [self setHighlighted:NO];
    }
}

#pragma mark - UIScrollviewDelegaet
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x >= kCellScrollMaxOffset && _finished == NO)
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
    }else
    {
        [self.scrollcontview setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_finished) {
       self.finishimg.alpha    = scrollView.contentOffset.x/kCellScrollMaxOffset;
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    // TODO:
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    // TODO:
//}
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{return YES;};

@end
