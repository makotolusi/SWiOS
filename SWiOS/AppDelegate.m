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
#import "ShoppingCartModel.h"
#import "RegisterViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TradeFinishViewController.h"
#import "UILabel+Extension.h"
#import "MobClick.h"
#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //key
     [MobClick startWithAppkey:@"55d426b067e58eac68001678" reportPolicy:BATCH   channelId:@""];
    
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    
    //version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //uid
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    if([self isFirstLoad]){//[self isFirstLoad]
    
        SWIntroductionViewController *vc = [[SWIntroductionViewController alloc]init];
        self.window.rootViewController = vc;
        
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       id phoneNum=[defaults objectForKey:USER_LOGIN_PHONE_NUM];
        if (phoneNum) {
            SWMainViewController *mainContorll = [[SWMainViewController alloc]initWithViewControllers:nil];
            self.window.rootViewController = mainContorll;
        }else {
            RegisterViewController * mvc = [[RegisterViewController alloc]init];
            self.window.rootViewController = mvc;
        }
       
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED{
    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        [[AlipaySDK defaultService]
//         processOrderWithPaymentResult:url
//         standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"result = %@",resultDic);//返回的支付结果 //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接 口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方法 里面处理跟 callback 一样的逻辑】
//         }];
//        //        [[AlipaySDK defaultService] processAuth_V2Result:url
//        //                                         standbyCallback:^(NSDictionary *resultDic) {
//        //                                             NSLog(@"result = %@",resultDic);
//        //                                             NSString *resultStr = resultDic[@"result"];
//        //                                             NSLog(@"result = %@",resultStr);
//        //                                         }];
    }
    else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0){
//    [WXApi handleOpenURL:url delegate:self];
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return YES;
}


@end
