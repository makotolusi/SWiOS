
//
//  Activate.m
//  SWiOS
//
//  Created by 陆思 on 15/9/25.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "Activate.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
#import "TokenBuilder.h"
@implementation Activate

- (BOOL)Notactivated
{
    NSLog(@"app token is %@",[TokenBuilder currentUid]);
    // 如果已经激活过了，直接调用成功的方法
    if (StringNotNullAndEmpty([TokenBuilder currentUid])) {
        return NO;
    }else
        return YES;
}


- (void)sendActiveRequest:(void (^)())next
{
    //设备信息
    NSString *deviceName =[UIDevice currentDevice].model;
    NSString *os =[NSString stringWithFormat:@"iOS-%@", [UIDevice currentDevice].systemVersion];
    NSString *resolution =[NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].scale*[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].scale*[UIScreen mainScreen].bounds.size.height];
    //to json string
    NSDictionary *dic = @{@"deviceName": deviceName,@"os":os,@"resolution":resolution};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    NSDictionary *dict1 = @{@"content": jsonString};
    [HttpHelper sendPostRequest:@"doActivate"
                parameters: dict1
                success:^(id response) {
//                    NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
                    next();
                } fail:^{ }];
}

@end
