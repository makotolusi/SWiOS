

//
//  TokenBuilder.m
//  lusi
//
//  Created by 陆思 on 15/9/24.
//  Copyright (c) 2015年 陆思. All rights reserved.
//

#import "TokenBuilder.h"
#import "KeychainHelper.h"
#import "SSKeychain.h"
@implementation TokenBuilder

+(NSString*)generateUUID
{
//    NSString *uuid = [[[KeychainHelper shareKeychainHelper] objectForKey:[KeychainHelper secAttrForType:kSecTypeUUid]];
    NSString *uuid =[SSKeychain passwordForService:kSSKeychainWhereKey account:kSSKeychainAccountKey];
  
    if (StringIsNullOrEmpty(uuid)) {
        // 修改获取设备唯一标示方法，采取与BI数据统计相同的设备唯一标示
        uuid = [TokenBuilder getUUID];
//        [[KeychainHelper shareKeychainHelper] setObject:uuid forKey:[KeychainHelper secAttrForType:kSecTypeUUid]];
        [SSKeychain setPassword:uuid forService:kSSKeychainWhereKey account:kSSKeychainAccountKey];
    }
    return uuid;
}

+(NSString*)getUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}


+(NSString*)currentUid
{
//    return [[KeychainHelper shareKeychainHelper] objectForKey:[KeychainHelper secAttrForType:kSecTypeUUid]];
    return [SSKeychain passwordForService:kSSKeychainWhereKey account:kSSKeychainAccountKey];
}
@end
