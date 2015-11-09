//
//  NSString+Extension.h
//  iTrends
//
//  Created by wujin on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取一个字符串转换为URL
#define URL(str) [NSURL URLWithString:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]

//判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str==nil || [(str) isEqual:[NSNull null]] ||[str isEqualToString:@""])
//判断字符串不为空并且不为空字符串
#define StringNotNullAndEmpty(str) (str!=nil && ![(str) isEqual:[NSNull null]] &&![str isEqualToString:@""])
//快速格式化一个字符串
#define _S(str,...) [NSString stringWithFormat:str,##__VA_ARGS__]

@class MREntitiesConverter;
@interface NSString (Extension)

//返回字符串经过md5加密后的字符
+(NSString*)stringDecodingByMD5:(NSString*)str;

- (NSString *) stringFromMD5;

-(NSString*)md5DecodingString;

//返回经base64编码过后的数据
+ (NSString*) base64Encode:(NSData *)data;
-(NSString*)base64Encode;

//返回经base64解码过后的数据
+ (NSString*) base64Decode:(NSString *)string;
-(NSString*)base64Decode;
+(BOOL)validateMobile:(NSString *)mobileNum;

-(instancetype)jsonString2Dictionary;
@end
