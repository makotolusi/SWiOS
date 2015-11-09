//
//  OrderModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/22.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface OrderModel : JSONModel

//order info
@property (copy, nonatomic) NSString *orderCode;
@property (copy, nonatomic) NSNumber *submitPerson;
@property (copy, nonatomic) NSString *reviewerName;
@property (copy, nonatomic) NSString *receiverInfo;
@property (assign, nonatomic) int receiverId;
@property (copy, nonatomic) NSString *receiverPhone;
@property (copy, nonatomic) NSString *payType;
@property (copy, nonatomic) NSString *payCode;
@property (strong, nonatomic) NSNumber *totalPrice;
@property (assign, nonatomic) NSInteger totalCount;
@property (strong, nonatomic) NSMutableArray *orderDetails;

@end
