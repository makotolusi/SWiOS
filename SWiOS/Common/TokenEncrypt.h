//
//  KeyEncrypt.h
//  lusi
//
//  Created by 陆思 on 15/9/24.
//  Copyright (c) 2015年 陆思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenEncrypt : NSObject
+(NSString*)generateUidWithKey:(NSString **)encryptkey encryptString:(NSString **)encryptString Uid:(NSString*)uuid;
@end
