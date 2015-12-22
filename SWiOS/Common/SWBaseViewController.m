//
//  SWBaseViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"
#import "MobClick.h"
#import "UILabel+Extension.h"
@implementation SWBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //title
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [t midLabel];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = self.title;
    self.navigationItem.titleView=t;
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateViews];
     [MobClick beginLogPageView:_pageName];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:_pageName];
}

- (void)drawViews
{
  
}

- (void)updateViews
{
    
}

@end
