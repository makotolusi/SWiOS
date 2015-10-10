//
//  SWHttpRequestOperation.h
//  SWiOS
//
//  Created by YuchenZhang on 8/30/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWCommonAPI.h"

typedef NS_ENUM(NSInteger, SWHttpReqOperationStatus)
{
    SWHttpReqOperationStatusExecuting,
    SWHttpReqOperationStatusReady,
    SWHttpReqOperationStatusFinish
};

@interface SWHttpRequestOperation : NSOperation

@property (nonatomic, copy)SWApiSuccessBlock successBlock;
@property (nonatomic, copy)SWApiFailureBlock failBlock;
@property (nonatomic, strong)NSURLRequest *reqURL;

@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) SWHttpReqOperationStatus status;

- (instancetype)initWithReqURL:(NSURLRequest *)reqURL
                  successBlock:(SWApiSuccessBlock)successBlock
                  failureBlock:(SWApiFailureBlock)failureBlock;

@end
