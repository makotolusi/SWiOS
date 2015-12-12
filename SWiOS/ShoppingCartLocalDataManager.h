//
//  ShoppingCartLocalDataManager.h
//  SWiOS
//
//  Created by 陆思 on 15/12/3.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityProduct.h"
@class OrderModel;
@interface ShoppingCartLocalDataManager : NSObject

+ (BOOL)creatShoppingCartTable;
+ (BOOL)creatOrderModelTable;

+ (BOOL)insertShoppingCart:(ActivityProduct*)product;

+ (NSMutableArray*)getAllShoppingCart;

+ (BOOL)deleteShoppingCartById:(int)objId;

+ (OrderModel*)getAllOrderModel;

+ (BOOL)insertOrderModel:(OrderModel*)order;

@end
