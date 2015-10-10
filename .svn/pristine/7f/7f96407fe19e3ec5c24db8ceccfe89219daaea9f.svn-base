//
//  SWBaseDataProvider.h
//  SWiOS
//
//  Created by YuchenZhang on 9/3/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWBaseDataProvider : NSObject <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) UITableView *targetTable;

@property (nonatomic, assign)NSUInteger currentPageNum;

@property (nonatomic, assign) BOOL isLoading;

- (void)loadNextPage;

@end
