//
//  UIWindow+Extension].m
//  SWiOS
//
//  Created by 陆思 on 15/11/2.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "SWMainViewController.h"
@implementation UIWindow (Extension)

+(void)showTabBar:(BOOL)hidden{
    //root tab view
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    SWMainViewController *mainController=(SWMainViewController*)window.rootViewController;
    mainController.tabBarView.hidden=!hidden;
}
@end
