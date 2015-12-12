//
//  ActivityProduct.h
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface ActivityProduct : JSONModel

@property(nonatomic,assign)NSNumber* id;
@property(nonatomic,strong)NSNumber *activityId;
@property(nonatomic,copy)NSString *productCode;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,strong)NSNumber *rushPrice;
@property(nonatomic,assign)int rushQuantity;
@property(nonatomic,copy)NSString *picUrl1;
@property  (strong,nonatomic) NSNumber<Optional> *buyCount;

-(NSNumber*)calProductTotalPriceWithAddCount:(int)addCount;
@end
