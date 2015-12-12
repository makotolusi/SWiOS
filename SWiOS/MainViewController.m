//
//  MainViewController.m
//  SWiOS
//
//  Created by 李乐 on 15/8/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "MainViewController.h"

#import "SWExploreEntranceViewController.h"
#import "SWBuyBuyBuyViewController.h"
#import "SWBaseNavigationController.h"
#import "TabBarView.h"




@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initViewController];
    [self _initTabbarViewWithPng];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_initViewController{
    
    SWExploreEntranceViewController *ex = [[SWExploreEntranceViewController alloc]init];
    SWBuyBuyBuyViewController *buy = [[SWBuyBuyBuyViewController alloc]init];
    
    ex.title = @"探索";
    buy.title = @"抢抢抢";
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:ex];
    
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:buy];
    
    NSArray *views = @[nav1, nav2];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:2];
    
    
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SWBaseNavigationController *bc = [[SWBaseNavigationController alloc]initWithRootViewController:obj];
        [viewControllers addObject:bc];
        
    }];
    
    
    self.viewControllers = viewControllers;
    
    [self.tabBar setHidden:YES];
    
}

-(void)_initTabbarViewWithPng{
    
    self.view.backgroundColor = DEFAULT_BG_COLOR;
    
    
    NSArray *backgroud = @[@"magnifier",@"buy"];
    NSArray *heightBackgroud = @[@"magnifier_highlighted",@"buy_highlighted"];
    
    _buttons = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *backImage = backgroud[idx];
        NSString *heightImage = heightBackgroud[idx];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        [button addTarget:self
                   action:@selector(selectedTab:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:heightImage] forState:UIControlStateSelected];
        [button setShowsTouchWhenHighlighted:YES];
        
        if (0 == idx) {
            button.selected = YES;
        }
        
        [_buttons insertObject:button atIndex:idx];
        
    }];
    // tab bar
    _tabBarView = [[TabBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSWTabBarViewHeight)
                                            buttons:[_buttons copy]
                                             target:self];
    
    _tabBarView.center = CGPointMake(_tabBarView.frame.size.width / 2,
                                     
                                     self.view.bounds.size.height - kSWTabBarViewHeight / 2);
    
    [self.view addSubview:_tabBarView];
    
}


- (void)selectedTab:(UIButton *)button

{
    
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.selected = NO;
        
    }];
    
    self.selectedIndex = button.tag;
    if (button.selected) {
        button.selected = NO;
    }else{
        button.selected = YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
