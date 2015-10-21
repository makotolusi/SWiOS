//
//  OrderModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "JSONModel.h"
@interface OrderModel :JSONModel

@property (copy, nonatomic) NSString *orderCode;
@property (copy, nonatomic) NSString *submitPerson;
@property (copy, nonatomic) NSString *receiverName;
@property (copy, nonatomic) NSString *receiverInfo;
@property (strong, nonatomic) NSNumber *receiverId;
@property (copy, nonatomic) NSString *receiverPhone;
@property (copy, nonatomic) NSString *payType;
@property (copy, nonatomic) NSString *payCode;
@property (strong, nonatomic) NSNumber *totalPrice;
@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSArray *orderDetails;
@end
