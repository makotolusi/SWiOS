//
//  ShoppingCartModel.m
//  SWiOS
//
//  Created by 陆思 on 15/10/11.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartModel.h"
#import "OrderModel.h"
@implementation ShoppingCartModel

+(ShoppingCartModel *)sharedInstance
{
    static ShoppingCartModel *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ShoppingCartModel alloc] init];
        sharedManager.addressModel=[[AddressModel alloc] init];
        sharedManager.arOfWatchesOfCart = [NSMutableArray array];
        sharedManager.productCode_buyCount = [[NSMutableDictionary alloc] init];
        sharedManager.orderModel=[[OrderModel alloc] init];
        sharedManager.orderModel.orderDetails = [NSMutableArray array];
        sharedManager.orderModel.totalPrice=[NSNumber numberWithFloat:0.00f];
        sharedManager.registerModel=[[RegisterModel alloc] init];
        //test code user info
        sharedManager.orderModel.submitPerson=[NSNumber numberWithInteger:222];
        sharedManager.orderModel.receiverInfo=@"lusi";
        sharedManager.orderModel.reviewerName=@"lusi king";
        sharedManager.orderModel.receiverPhone=@"18210324011";
        sharedManager.orderModel.payType=@"ZHIFUBAO";
    });
    
    return sharedManager;
}
@end
