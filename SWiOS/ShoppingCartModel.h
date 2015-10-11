//
//  ShoppingCartModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/11.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject
@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@property (nonatomic,strong) NSMutableDictionary *producCode_buyCount;
@property (assign,nonatomic) NSInteger totalCountBadge;
@property (assign,nonatomic) NSInteger totalSalePrice;

+(ShoppingCartModel *)sharedInstance;
@end
