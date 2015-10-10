//
//  TokenBuilder.h
//  lusi
//
//  Created by 陆思 on 15/9/24.
//  Copyright (c) 2015年 陆思. All rights reserved.
//

#import <Foundation/Foundation.h>
//判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str==nil || [(str) isEqual:[NSNull null]] ||[str isEqualToString:@""])
@interface TokenBuilder : NSObject

+(NSString*)generateUUID;
+(NSString*)getUUID;
+(NSString*)currentUid;
@end
