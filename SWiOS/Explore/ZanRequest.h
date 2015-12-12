//
//  ZanRequest.h
//  SWiOS
//
//  Created by 陆思 on 15/11/27.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZanRequest : NSObject

+(void)addZan:(NSString*)productCode userId:(NSString*)userId next:(void (^)())next;

+(void)addFavor:(NSString*)productCode userId:(NSString*)userId next:(void (^)())next;

@end
