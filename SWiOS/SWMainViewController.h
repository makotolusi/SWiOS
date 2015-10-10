//
//  SWMainViewController.h
//  SWiOS
//
//  Created by YuchenZhang on 7/19/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTabBarView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(UIButton *)buttons
                       target:(id)target;

@end

@interface SWMainViewController : UIViewController

@property (nonatomic, strong) UIViewController *selectingViewController;

@property (nonatomic, strong) NSMutableArray *viewControlers;

@property (nonatomic, strong) SWTabBarView *tabBarView;

- (instancetype)initWithViewControllers:(NSArray *)controllers;

@end
