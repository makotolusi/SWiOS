//
//  ViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 7/18/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "ViewController.h"
#import "SWMainViewController.h"
#import "SWExploreEntranceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self gotoMain];
}


#pragma mark outlets

- (void)gotoMain
{
    
    SWExploreEntranceViewController *expVC = [[SWExploreEntranceViewController alloc] init];
    
    expVC.title = @"探索";
    
    UINavigationController *v1 = [[UINavigationController alloc] initWithRootViewController:expVC];
    
    UIViewController *grub = [[UIViewController alloc] init];
    
    grub.title = @"抢枪抢";
    
    UINavigationController *v2 = [[UINavigationController alloc] initWithRootViewController:grub];
    
    UIViewController *rescue = [[UIViewController alloc] init];
    
    rescue.title = @"拯救";
    UINavigationController *v3 = [[UINavigationController alloc] initWithRootViewController:rescue];
    
    
    UIViewController *setting = [[UIViewController alloc] init];
    
    setting.title = @"设置";
    UINavigationController *v4 = [[UINavigationController alloc] initWithRootViewController:setting];
    
    
    
    SWMainViewController *main = [[SWMainViewController alloc] \
                                  initWithViewControllers:@[v1,
                                                            v2,
                                                            v3,
                                                            v4]];
    
    [self presentViewController:main animated:YES completion:^{
        
    }];
    
    
}

@end
