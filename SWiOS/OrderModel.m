
//
//  OrderModel.m
//  SWiOS
//
//  Created by 陆思 on 15/10/22.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

-(void)subtractTotalPriceWithSingleProductPrice:(NSDecimalNumber*)productPrice{
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler
                                     decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                     scale:2
                                     raiseOnExactness:NO
                                     raiseOnOverflow:NO
                                     raiseOnUnderflow:NO
                                     raiseOnDivideByZero:YES];
    NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:self.totalPrice.stringValue];
    self.totalPrice=[t1 decimalNumberBySubtracting: productPrice withBehavior:round];
}

-(void)addTotalPriceWithSingleProductPrice:(NSDecimalNumber*)productPrice{
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler
                                     decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                     scale:2
                                     raiseOnExactness:NO
                                     raiseOnOverflow:NO
                                     raiseOnUnderflow:NO
                                     raiseOnDivideByZero:YES];
    NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:self.totalPrice.stringValue];
    self.totalPrice=[t1 decimalNumberByAdding: productPrice withBehavior:round];
}
@end
