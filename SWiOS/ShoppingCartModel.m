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
#import "ActivityProduct.h"
#import "UIAlertView+Extension.h"
#import "ShoppingCartLocalDataManager.h"
@implementation ShoppingCartModel

 static ShoppingCartModel *sharedManager;

+(ShoppingCartModel *)sharedInstance
{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ShoppingCartModel alloc] init];
        sharedManager.addressModel=[[AddressModel alloc] init];
        sharedManager.arOfWatchesOfCart = [NSMutableArray array];
        sharedManager.productCode_buyCount = [[NSMutableDictionary
                                               alloc] init];
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

+(void)clearUserCartAll
{
    sharedManager.arOfWatchesOfCart = [NSMutableArray array];
      sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel.orderDetails = [NSMutableArray array];
    sharedManager.registerModel=[[RegisterModel alloc] init];
    sharedManager.addressModel=[[AddressModel alloc] init];
    sharedManager.orderModel.totalPrice=[NSNumber numberWithFloat:0.00f];
    sharedManager.orderModel.totalCount=0;
}

+(void)clearCart
{
    sharedManager.arOfWatchesOfCart = [NSMutableArray array];
    sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel=[[OrderModel alloc] init];
    sharedManager.orderModel.orderDetails = [NSMutableArray array];
    sharedManager.orderModel.totalPrice=[NSNumber numberWithFloat:0.00f];
    sharedManager.orderModel.totalCount=0;
}

+(BOOL)add2CartWithProduct:(ActivityProduct*)product buyCount:(int)buyCount{
    
    if (product.rushQuantity<1) {
        [UIAlertView showMessage:@"库存不足"];
        return NO;
    }
    NSInteger index=-1;
    int total=0;
    if ([sharedManager.arOfWatchesOfCart containsObject:product]) {
        index= [sharedManager.arOfWatchesOfCart indexOfObject:product];
        product=sharedManager.arOfWatchesOfCart[index];
        total=product.buyCount.intValue+buyCount;
    }else {
        [sharedManager.arOfWatchesOfCart addObject:product];
        total=buyCount;
        sharedManager.orderModel.totalCount=sharedManager.orderModel.totalCount+1;
    }
    
    if (product.buyCount==nil) {
        product.buyCount=[[NSNumber alloc] initWithInt:0];
    }
    
    if (total>product.rushQuantity) {
        [UIAlertView showMessage:@"库存不足"];
        return NO;
    }
    
    
    product.buyCount=[[NSNumber alloc] initWithInt:total];
    if (index!=-1) {
        [sharedManager.arOfWatchesOfCart replaceObjectAtIndex:index withObject:product ];
    }
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler
                                     decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                     scale:2
                                     raiseOnExactness:NO
                                     raiseOnOverflow:NO
                                     raiseOnUnderflow:NO
                                     raiseOnDivideByZero:YES];
    NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:sharedManager.orderModel.totalPrice.stringValue];
    NSDecimalNumber *pPrice=[NSDecimalNumber decimalNumberWithDecimal:[product calProductTotalPriceWithAddCount:buyCount].decimalValue];
   
    sharedManager.orderModel.totalPrice=[t1 decimalNumberByAdding: pPrice withBehavior:round];
    [ShoppingCartLocalDataManager insertShoppingCart:product];
    [ShoppingCartLocalDataManager insertOrderModel:sharedManager.orderModel];
    return YES;
}

+(BOOL)removeCartWithProduct:(ActivityProduct*)product count:(int)count{
     int total=0;
    NSInteger index = 0;
    if ([sharedManager.arOfWatchesOfCart containsObject:product]) {
        index= [sharedManager.arOfWatchesOfCart indexOfObject:product];
        product=sharedManager.arOfWatchesOfCart[index];
        total=product.buyCount.intValue-count;
    }
    if (total>0) {
        product.buyCount=[[NSNumber alloc] initWithInt:total];
        
        NSNumber *pPrice=[product calProductTotalPriceWithAddCount:count];
        [sharedManager.orderModel subtractTotalPriceWithSingleProductPrice:[[NSDecimalNumber alloc] initWithDecimal:pPrice.decimalValue]];
        [sharedManager.arOfWatchesOfCart replaceObjectAtIndex:index withObject:product ];
        [ShoppingCartLocalDataManager insertOrderModel:sharedManager.orderModel];
        [ShoppingCartLocalDataManager insertShoppingCart:product];
//        [sharedManager.arOfWatchesOfCart removeObject:product];
        return YES;
    }else
        return NO;
 

}
+(BOOL)removeCartWithProduct:(ActivityProduct*)product{
    NSInteger index = 0;
    if ([sharedManager.arOfWatchesOfCart containsObject:product]) {
        index= [sharedManager.arOfWatchesOfCart indexOfObject:product];
        product=sharedManager.arOfWatchesOfCart[index];
    }
    
    if ( [ShoppingCartLocalDataManager deleteShoppingCartById:product.id.intValue]) {
        NSNumber *pPrice=[product calProductTotalPriceWithAddCount:product.buyCount.intValue];
        [sharedManager.orderModel subtractTotalPriceWithSingleProductPrice:[[NSDecimalNumber alloc] initWithDecimal:pPrice.decimalValue]];
        sharedManager.orderModel.totalCount=sharedManager.orderModel.totalCount-1;
        [ShoppingCartLocalDataManager insertOrderModel:sharedManager.orderModel];
        [sharedManager.arOfWatchesOfCart removeObject:product];
        product.buyCount=nil;
        return YES;
    }else
        return NO;
}
@end
