//
//  ZanRequest.m
//  SWiOS
//
//  Created by 陆思 on 15/11/27.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "ZanRequest.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
@implementation ZanRequest

+(void)addZan:(NSString*)productCode userId:(NSString*)userId next:(void (^)())next{
    NSDictionary *dict1 = @{@"productCode": productCode,@"userId":userId};
    [HttpHelper sendPostRequest:@"CommerceUserServices/addZan"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            NSNumber* success=[result valueForKey:@"success"];
//                            BOOL b=success.boolValue;
                            if(success.boolValue){
                                next();
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        }];
}

+(void)addFavor:(NSString*)productCode userId:(NSString*)userId next:(void (^)())next{
    NSDictionary *dict1 = @{@"productCode": productCode,@"userId":userId};
    [HttpHelper sendPostRequest:@"CommerceUserServices/addFavor"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            NSNumber* success=[result valueForKey:@"success"];
                            if(success.boolValue){
                                next();
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        }];
}

//+(void)countZan:(NSString*)productCode next:(void (^)())next{
//    NSDictionary *dict1 = @{@"productCode": productCode};
//    [HttpHelper sendPostRequest:@"countZan"
//                     parameters: dict1
//                        success:^(id response) {
//                            NSDictionary* result=[response jsonString2Dictionary];
//                            BOOL success=[result valueForKey:@"success"];
//                            if(success){
//                                next();
//                            }
//                            NSLog(@"获取到的数据为dict：%@", result);
//                        } fail:^{
//                            NSLog(@"fail");
//                        }];
//}

@end
