//
//  SWCommonAPI.h
//  SWiOS
//
//  Created by YuchenZhang on 8/30/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWCommonAPIProtocol <NSObject>

@optional
- (BOOL)shouldEncrypt;
- (NSString *)pathForEndpoint;

@end

@class SWCommonAPI;
@class SWHttpRequestOperation;

typedef void(^SWApiSuccessBlock)(SWHttpRequestOperation *operation, id response);
typedef void(^SWApiFailureBlock)(SWHttpRequestOperation *operation, NSError *error);

@interface SWCommonAPI : NSObject <SWCommonAPIProtocol>

@property (nonatomic, strong) NSURL *baseURL;


+ (instancetype)sharedInstance;


- (instancetype)initWithBaseURL:(NSString *)baseURL;

- (void)post:(NSString *)apiname
      params:(NSDictionary *)params
 withSuccess:(SWApiSuccessBlock)successBlock
     failure:(SWApiFailureBlock)failureBlock;


@end
