//
//  SWCache.h
//  SWiOS
//
//  Created by zhangyuchen on 15-8-31.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kSWCacheDestType)
{
    kSWCacheDestTypeLocalFile,
    kSWCacheDestTypeInMemory
};

@protocol SWCacheProtocl <NSObject>

- (NSData *)getContentFromKey:(id)key;

- (BOOL)pushContentData:(NSData *)data forKey:(id)key;

@end

@interface SWCache : NSObject

+ (id<SWCacheProtocl>)defaultFileCache;

+ (id<SWCacheProtocl>)defaultMemoryCache;

@end


// do not initial below directly,
// instead,use SWCache defaultFileCache or defaultMemoryCache
@interface SWFileCache : NSObject<SWCacheProtocl>

@end

@interface SWMemoryCache : NSObject<SWCacheProtocl>

@end

