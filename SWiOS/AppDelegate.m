//
//  AppDelegate.m
//  SWiOS
//
//  Created by YuchenZhang on 7/18/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SWMainViewController.h"
#import "SWExploreEntranceViewController.h"
#import "SWBuyBuyBuyViewController.h"
#import "SWIntroductionViewController.h"
#import "Activate.h"
#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    
    // clean key for only once login
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LAST_RUN_VERSION_KEY];
    
    if([self isFirstLoad]){
        
        SWIntroductionViewController *vc = [[SWIntroductionViewController alloc]init];
        self.window.rootViewController = vc;
        
    }else{
        
        [NSThread sleepForTimeInterval:3.0];

        SWMainViewController *mainContorll = [[SWMainViewController alloc]initWithViewControllers:nil];
        self.window.rootViewController = mainContorll;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    
    if (!lastRunVersion) {
        return YES;
        // App is being run for first time
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
        // App has been updated since last run
    }
    return NO;
}

@end
