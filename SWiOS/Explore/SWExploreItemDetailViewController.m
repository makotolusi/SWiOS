//
//  SWExploreItemDetailViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 9/3/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExploreItemDetailViewController.h"

@interface SWExploreItemDetailViewController()

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation SWExploreItemDetailViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawViews
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"探索" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [item setTintColor:[UIColor redColor]];
    
    self.title = _itemInfo.itemName;
 
//    self.navigationItem.leftBarButtonItem = item;
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_contentView];
    
    _bigImageView = [[YCAsyncImageView alloc] initWithFrame:_bigImageFrame];
    _bigImageView.url = _itemInfo.bigImageURL;
    [_contentView addSubview:_bigImageView];
    
    
    
}


@end
