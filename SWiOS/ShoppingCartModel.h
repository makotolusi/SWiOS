//
//  ShoppingCartModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/11.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "OrderModel.h"
#import "AddressModel.h"
@interface ShoppingCartModel : JSONModel
@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@property (nonatomic,strong) NSMutableDictionary *productCode_buyCount;
@property (nonatomic,strong) NSMutableDictionary *activity_product_index;
//@property (assign,nonatomic) NSInteger totalCountBadge;
@property (strong,nonatomic) OrderModel *orderModel;
@property (strong,nonatomic) AddressModel *addressModel;

+(ShoppingCartModel *)sharedInstance;
@end
