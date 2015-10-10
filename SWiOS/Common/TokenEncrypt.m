
//
//  KeyEncrypt.m
//  lusi
//
//  Created by 陆思 on 15/9/24.
//  Copyright (c) 2015年 陆思. All rights reserved.
//

#import "TokenEncrypt.h"
#import "NSString+Extension.h"
#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase642.h"
#import "TokenBuilder.h"
@implementation TokenEncrypt

+(NSString*)generateUidWithKey:(NSString **)encryptkey encryptString:(NSString **)encryptString Uid:(NSString*)uid
{
    if(StringIsNullOrEmpty(uid))
    {
        uid=[TokenBuilder generateUUID];
    }
    NSString *str=uid;
    //将其变为长度变为8的整数辈
    if(str.length%8!=0)
        str=[str stringByPaddingToLength:8*(str.length/8+1) withString:@" " startingAtIndex:0];
    NSString *despwd=[[TokenBuilder getUUID] stringByPaddingToLength:8 withString:@" " startingAtIndex:0];
    //对字符的md5
    NSString *md5=[[NSString stringDecodingByMD5:str] stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
    //非对称加密密钥
    RSA *rsa=[[RSA alloc] init];
    NSData *key= [rsa encryptWithString:[NSString stringWithFormat:@"%@%@",despwd,md5]];
    NSString *str_key=[NSString base64Encode:key];
    *encryptkey=str_key;//k
    //原文des加密 c
    NSString *encode=[NSData encryptUseDES:str key:despwd];
    *encryptString=encode;
//    RELEASE_SAFE(rsa);
    return uid;
}

@end
