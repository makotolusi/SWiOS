//
//  KeychainHelper.m
//  GenericKeychain
//
//  Created by cyou-duangl on 13-9-6.
//
//

#import "KeychainHelper.h"
#import "KeychainItemWrapper.h"


@interface KeychainHelper()

@property (nonatomic, retain) KeychainItemWrapper *wrapper;

@end

@implementation KeychainHelper

@synthesize wrapper;

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        

        NSString *bundleId = [NSString stringWithFormat:@"%@.%@", @"lusi", [infoDic objectForKey:@"CFBundleIdentifier"]];
        
        KeychainItemWrapper *w = [[KeychainItemWrapper alloc] initWithIdentifier:@"userSecret" accessGroup:bundleId];
        self.wrapper = w;
        [w release];
    }
    return self;
}

- (void)dealloc
{
    self.wrapper = nil;
    [super dealloc];
}

+(KeychainHelper *)shareKeychainHelper
{
    static KeychainHelper *shareInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shareInstance = [[KeychainHelper alloc] init];
	});
	return shareInstance;
}

+ (id)secAttrForType:(NSInteger)type
{
    switch (type)
    {
        case kSecTypeUid: return (id)kSecAttrAccount;
        case kSecTypeUUid: return (id)kSecValueData;
        case kSecTypeGiftUserData: return (id)kSecAttrDescription;
    }
    return nil;
}

-(void)setObject:(id)object forKey:(id)key
{
    [self.wrapper setObject:object forKey:key];
}

-(id)objectForKey:(id)key
{
    return [self.wrapper objectForKey:key];
}

- (void)resetKeychain
{
    [self.wrapper resetKeychainItem];
}

@end
