//
//  OrderRequest.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartModel.h"
@interface OrderRequest : NSObject

+(ShoppingCartModel*)orderCheck:(void (^)())next;
+(void)orderCancel:(UIView*)view next:(void (^)())next;
@end
