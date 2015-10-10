//
//  SWBaseDataProvider.m
//  SWiOS
//
//  Created by YuchenZhang on 9/3/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWBaseDataProvider.h"

@interface SWBaseDataProvider ()
{

}
@end

@implementation SWBaseDataProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray new];
        
    }
    return self;
}

- (void)loadNextPage
{
    NSLog(@"you should load next page");
    _currentPageNum++;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat sizeHeight = scrollView.frame.size.height - (scrollView.contentSize.height - offsetY);
    
    NSLog(@"%f", sizeHeight);
    
    if (sizeHeight > 70 && _isLoading == NO) {
        [self loadNextPage];
    }
}

@end
