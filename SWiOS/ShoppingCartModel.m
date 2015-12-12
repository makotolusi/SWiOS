//
//  ShoppingCartModel.m
//  SWiOS
//
//  Created by 陆思 on 15/10/11.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartModel.h"
#import "OrderModel.h"
#import "NSString+Extension.h"
@implementation ShoppingCartModel

 static ShoppingCartModel *sharedManager;

+(ShoppingCartModel *)sharedInstance
{
   
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
       sharedManager.orderStatus = @{@"PAID":@"已支付",@"WAITING_PAYMENT":@"待支付",@"CANCEL":@"取消支付"};
    });
    
    return sharedManager;
}

+(void)loadAddressModel{
    if (!StringIsNullOrEmpty(sharedManager.registerModel.addr)) {
        NSArray *aTest = [sharedManager.registerModel.addr componentsSeparatedByString:@";"];
        if (aTest.count>=6) {
            sharedManager.addressModel.name=aTest[0];
            sharedManager.addressModel.phone=aTest[1];
            sharedManager.addressModel.code=aTest[2];
            sharedManager.addressModel.city=aTest[3];
            sharedManager.addressModel.address=aTest[4];
            sharedManager.addressModel.index=((NSString*)aTest[5]).intValue;
        }
  
    }
}

+(void)clearCart
{
    sharedManager.arOfWatchesOfCart = [NSMutableArray array];
//     sharedManager.orderModel.totalPrice=[NSNumber numberWithFloat:0.00f];
      sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel.orderDetails = [NSMutableArray array];
    sharedManager.orderModel.totalPrice=[NSNumber numberWithFloat:0.00f];
}
@end
