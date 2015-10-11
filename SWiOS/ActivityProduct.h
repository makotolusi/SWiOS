//
//  ActivityProduct.h
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ActivityProduct : BaseModel
@property(nonatomic,strong)NSNumber *activityId;
@property(nonatomic,copy)NSString *productCode;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,strong)NSNumber *rushPrice;
@property(nonatomic,strong)NSNumber *rushQuantity;
@property(nonatomic,copy)NSString *picUrl1;
@property (assign,nonatomic) NSInteger buyCount;
@end
