//
//  ActivityProduct.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityProduct.h"

@implementation ActivityProduct

-(BOOL)isEqual:(id)object{
    
    if ([self hash]==[object hash]) {
        return YES;
    }else
        return NO;
}

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

- (NSUInteger)hash
{
    return NSUINTROTATE([_activityId hash], NSUINT_BIT / 2) ^ [_productCode hash];
}

-(NSNumber*)calProductTotalPriceWithAddCount:(int)addCount{
    NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber alloc] initWithInt:addCount].decimalValue];
    NSDecimalNumber *t2=[NSDecimalNumber decimalNumberWithDecimal:self.rushPrice.decimalValue];
    NSDecimalNumber *sum=[t1 decimalNumberByMultiplyingBy: t2];
    return [[NSNumber alloc] initWithFloat:sum.floatValue];
}


@end
