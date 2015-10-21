//
//  OrderDetailModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface OrderDetailModel : JSONModel
@property (strong, nonatomic) NSNumber *activityId;
@property (copy, nonatomic) NSString *productCode;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *stock;
@end
