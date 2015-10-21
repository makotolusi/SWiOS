//
//  OrderRequest.m
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderRequest.h"
#import "OrderModel.h"
#import "HttpHelper.h"
#import "OrderDetailModel.h"
@implementation OrderRequest

+(OrderModel*)orderCheck:(OrderModel*)orderModel{
    orderModel=[[OrderModel alloc] init];
    orderModel.submitPerson=@"lsui";
    orderModel.receiverId=[NSNumber numberWithInteger:222];
    orderModel.receiverInfo=@"lusilusi";
    orderModel.receiverName=@"lusi dawang";
    orderModel.receiverPhone=@"18210324011";
    orderModel.payType=@"WEIXIN";
    orderModel.totalPrice=[NSNumber numberWithInteger:15677];
    orderModel.totalCount=[NSNumber numberWithInteger:50];
    OrderDetailModel *od=[[OrderDetailModel alloc] init];
    od.activityId=[NSNumber numberWithInteger:22];
    od.productCode=@"232342";
    od.count=[NSNumber numberWithInteger:1];
    od.price=[NSNumber numberWithInteger:1000];
    NSArray *aaa=[NSArray arrayWithObjects:[od toDictionary], nil];
    orderModel.orderDetails=aaa;
    NSMutableArray *ods=[NSMutableArray arrayWithObjects:od, nil];

    
    NSDictionary* lu= [orderModel toDictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lu options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dict1 = @{@"content": jsonString};
    [HttpHelper sendPostRequest:@"snapup"
                     parameters: dict1
                        success:^(id response) {
                            NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
                            NSLog(@"获取到的数据为dict：%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
                        } fail:^{ }];
    return nil;
}
@end
