//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"

#import "SVGloble.h"
#import "SVTopScrollView.h"

#define POSITIONID (int)(scrollView.contentOffset.x/SCREEN_WIDTH)

@implementation SVRootScrollView

@synthesize viewNameArray;

+ (SVRootScrollView *)shareInstance {
    static SVRootScrollView *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0,
                                                         kSWHeadBarViewHeight,
                                                         SCREEN_WIDTH,[SVGloble shareInstance].globleHeight)];
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews
{
    _count=[viewNameArray count];
    for (int i = 0; i < [viewNameArray count]; i++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+SCREEN_WIDTH*i, 0, SCREEN_WIDTH, [SVGloble shareInstance].globleHeight-44)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:50.0];
//        label.tag = 200 + i;
//        if (i == 0) {
//            label.text = [viewNameArray objectAtIndex:i];
//        }
//        [self addSubview:label];
        UITableView* table=viewNameArray[i];
        table.frame=CGRectMake(0+SCREEN_WIDTH*i, 0, SCREEN_WIDTH, [SVGloble shareInstance].globleHeight);
//        _lastContent.frame=CGRectMake(0+SCREEN_WIDTH*2, 0, SCREEN_WIDTH, [SVGloble shareInstance].globleHeight);
        [self addSubview:table];
//        [self addSubview:_lastContent];
    }
    self.contentSize = CGSizeMake(SCREEN_WIDTH*[viewNameArray count], [SVGloble shareInstance].globleHeight);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
    
  
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self loadData];
}

-(void)loadData
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/viewNameArray.count)/pagewidth)+1;
    UILabel *label = (UILabel *)[self viewWithTag:page+200];
    label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:page]];
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[SVTopScrollView shareInstance] setButtonUnSelect];
    [SVTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[SVTopScrollView shareInstance] setButtonSelect];
    [[SVTopScrollView shareInstance] setScrollViewContentOffset];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
