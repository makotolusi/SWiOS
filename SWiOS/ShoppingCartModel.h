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
#import "RegisterModel.h"
@interface ShoppingCartModel : JSONModel
@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@property (nonatomic,strong) NSMutableDictionary *productCode_buyCount;
//@property (assign,nonatomic) NSInteger totalCountBadge;
@property (strong,nonatomic) OrderModel *orderModel;
@property (strong,nonatomic) AddressModel *addressModel;
@property (strong,nonatomic) RegisterModel *registerModel;
@property (copy,nonatomic) NSString *route;
@property (copy,nonatomic) NSString *orderInfoString;
@property (strong,nonatomic) NSDictionary *orderStatus;
+(ShoppingCartModel *)sharedInstance;
+(void)clearCart;
@end
