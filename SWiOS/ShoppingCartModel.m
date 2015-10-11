//
//  ShoppingCartModel.m
//  SWiOS
//
//  Created by 陆思 on 15/10/11.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

+(ShoppingCartModel *)sharedInstance
{
    static ShoppingCartModel *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ShoppingCartModel alloc] init];
        sharedManager.arOfWatchesOfCart = [NSMutableArray array];
        sharedManager.producCode_buyCount = [[NSMutableDictionary alloc] init];
    });
    
    return sharedManager;
}
@end
