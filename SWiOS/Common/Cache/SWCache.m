//
//  SWCache.m
//  SWiOS
//
//  Created by zhangyuchen on 15-8-31.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWCache.h"

#define DEFAULT_CACHE_FILE_PATH

@implementation SWCache

+ (id<SWCacheProtocl>)defaultFileCache
{
    static SWFileCache *fc = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fc = [[SWFileCache alloc] init];
    });
    
    return fc;
}


+ (id<SWCacheProtocl>)defaultMemoryCache
{
    
    static SWMemoryCache *mc = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mc = [[SWMemoryCache alloc] init];
    });
    
    return mc;
}

@end


@implementation SWFileCache

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)_initialize
{
    
}

@end


@implementation SWMemoryCache



@end
