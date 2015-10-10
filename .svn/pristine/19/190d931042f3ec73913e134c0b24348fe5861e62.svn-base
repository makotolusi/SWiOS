//
//  ZYCScrollableToolbar.m
//  SWiOS
//
//  Created by YuchenZhang on 8/23/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "ZYCScrollableToolbar.h"
#import "UILabel+SWExt.h"


#define ZYCTitleTagFromIdx(index) (0xffA1+index)

#define ZYCTitleIdxFromTag(tag) (tag - 0xffA1)

@interface ZYCScrollableToolbar () <UIScrollViewDelegate>
{
    UIScrollView *m_scrollview;
    
    struct {
        int canDidSelecedAtIndex:1;
    } m_delegateMethodsRec;
}

@property (nonatomic, strong) NSArray *titles;

@end

@implementation ZYCScrollableToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.titles = titles;
    
        [self _initialze];
    }
    
    return self;
}

- (void)_initialze
{
    m_scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
    m_scrollview.showsHorizontalScrollIndicator = NO;
    m_scrollview.showsVerticalScrollIndicator = NO;
    m_scrollview.delegate = self;
    [self addSubview:m_scrollview];
    _titleColor = [UIColor blackColor];
    _selectedTitleColor = [UIColor redColor];
    _titlePadding = 5;
    _titleFont = [UIFont systemFontOfSize:12.0f];
//    
//    __block CGFloat offsetX = 0;
//    
//    [_titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, 60, self.frame.size.height)];
//        
//        l.textColor = _titleColor;
//        l.text = obj;
//        l.font = _titleFont;
//        l.tag = ZYCTitleTagFromIdx(idx);
//        l.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_titleDidTapped:)];
//        
//        [l addGestureRecognizer:tap];
//        
//        [l swFixSize];
//        
//        [m_scrollview addSubview:l];
//        offsetX += l.frame.size.width + _titlePadding;
//    }];
    
//    m_scrollview.contentSize = CGSizeMake(MAX(SCREEN_WIDTH, offsetX), self.bounds.size.height);
    
    [self updateWithTitles:_titles];
    
    _currentSelectingIndex = -1;
    [self doSelectAtIndex:0];
}

- (void)updateWithTitles:(NSArray *)titles
{
    
    int count = 0;
    while (YES) {
        // clear titles drawn before
        NSInteger tag = ZYCTitleTagFromIdx(count);
        UIView *oldBtn = [m_scrollview viewWithTag:tag];
        if (oldBtn == nil) {
            break;
        }
        [oldBtn removeFromSuperview];
        count++;
    }
    
    __block CGFloat offsetX = 0;
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, 60, self.frame.size.height)];
        
        l.textColor = _titleColor;
        l.text = obj;
        l.font = _titleFont;
        l.tag = ZYCTitleTagFromIdx(idx);
        l.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_titleDidTapped:)];
        
        [l addGestureRecognizer:tap];
        
        [l swFixSize];
        
        [m_scrollview addSubview:l];
        offsetX += l.frame.size.width + _titlePadding;
    }];

    
    m_scrollview.contentSize = CGSizeMake(MAX(SCREEN_WIDTH, offsetX), self.bounds.size.height);
    
    if (offsetX < SCREEN_WIDTH) {
        m_scrollview.center = CGPointMake((SCREEN_WIDTH - offsetX * 0.5), m_scrollview.center.y);
    }
    
    _currentSelectingIndex = -1;
    [self doSelectAtIndex:0];
}

- (void)setToolbarDelegate:(id<ZYCScrollableToolbarDelegate>)toolbarDelegate
{
    if (_toolbarDelegate != toolbarDelegate) {
        _toolbarDelegate = toolbarDelegate;
        
        if ([_toolbarDelegate respondsToSelector:@selector(scrollableToolbar:didSelecedAtIndex:)]) {
            m_delegateMethodsRec.canDidSelecedAtIndex = 1;
        }
    }
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    m_scrollview.backgroundColor = backgroundColor;
}


- (void)doSelectAtIndex:(NSInteger)newIndex
{
    if (newIndex == _currentSelectingIndex) {
        // nop
        return;
    }
    
    NSInteger newTag = ZYCTitleTagFromIdx(newIndex);
    NSInteger currentTag = ZYCTitleTagFromIdx(_currentSelectingIndex);
    
    UIView *pendingSelectView = [m_scrollview viewWithTag:newTag];
    UIView *pendingUnSelectView = [m_scrollview viewWithTag:currentTag];
    
    _currentSelectingIndex = newIndex;
    
    
    [self p_updateStyleForTitleView:pendingSelectView isSelecting:YES animated:YES];
    
    [self p_updateStyleForTitleView:pendingUnSelectView isSelecting:NO animated:YES];
    
    
    
}

- (void)p_updateStyleForTitleView:(UIView *)titleView
                  isSelecting:(BOOL)isSelecting
                     animated:(BOOL)animated
{
    
    UILabel *l = (UILabel *)titleView;
    if (isSelecting) {
        
        if (animated) {
            CABasicAnimation *ta = [CABasicAnimation animationWithKeyPath:@"transform"];
            
            ta.duration = 0.2f;
            ta.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            
            
            ta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0)];
            ta.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [titleView.layer addAnimation:ta forKey:@"scales"];
        }
        
        titleView.layer.transform = CATransform3DMakeScale(1.05f, 1.05f, 1.0f);
        
        l.textColor = _selectedTitleColor;
        
    } else {
        
        if (animated) {
            [UIView animateWithDuration:0.24f animations:^{
                titleView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                l.textColor = _titleColor;
            }];
        } else {
            titleView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
            l.textColor = _titleColor;
        }
    }
}

#pragma mark UIScrollViewDelegat


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

#warning pending to add more effects.
}


- (void)p_titleDidTapped:(UITapGestureRecognizer *)tapped
{
    UIView *tappedView = tapped.view;
    NSInteger newIndex = tappedView.tag - 0xffA1;
    
    [self doSelectAtIndex:newIndex];
    
    
    if (m_delegateMethodsRec.canDidSelecedAtIndex) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_toolbarDelegate scrollableToolbar:self
                              didSelecedAtIndex:newIndex];
        });
    }
}


@end
