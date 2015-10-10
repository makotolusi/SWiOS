//
//  KeychainHelper.h
//  GenericKeychain
//
//  Created by cyou-duangl on 13-9-6.
//
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//如果需要保存其它数据，需要在这里注册，别在secAttrForSection中返回对应的key
enum {
	kSecTypeUid = 0,
	kSecTypeUUid,
    kSecTypeGiftUserData,
};

/**
 用于管理必需在程序启动时运行的一些公共数据更新等
 请在applicationDidFinishLanuch方法中激活此对象
 */
@interface KeychainHelper : NSObject

/**
 返回全局公用的KeychainHelper对象
 */
+(KeychainHelper *)shareKeychainHelper;

/**
 返回Keychain 中要存储的对象对应的Key
 */
+ (id)secAttrForType:(NSInteger)type;

/**
 存储对象
 @param object : 要存储的对象
 @param key : 要存储到keychain中的SecItemKey
 */
-(void)setObject:(id)object forKey:(id)key;

/**
 读取对象
 @param type : keychain中的SecItemKey
 @return 返回存储在key对应的对象
 */
-(id)objectForKey:(id)key;

/**
 清空Keychain
 */
- (void)resetKeychain;

@end
