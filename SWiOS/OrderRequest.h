//
//  OrderRequest.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderModel;
@interface OrderRequest : NSObject

+(OrderModel*)orderCheck:(OrderModel*)orderModel;
@end
