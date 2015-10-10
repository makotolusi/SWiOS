//
//  SWBaseViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"

@implementation SWBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateViews];
}

- (void)drawViews
{
    
}

- (void)updateViews
{
    
}

@end
