//
//  SWCommonAPI.m
//  SWiOS
//
//  Created by YuchenZhang on 8/30/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWCommonAPI.h"
#import "SWHttpRequestOperation.h"



#define SW_SERVER_API_BASE_URL @"http://okeasy.eicp.net:9889/mgserver/ApCommonServices/"

@interface SWCommonAPI ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation SWCommonAPI


- (void)_initialze
{
    self.operationQueue = [[NSOperationQueue alloc] init];
}

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    self = [super init];
    
    if (self) {
        if (baseURL == nil) {
            baseURL = @"";
        }
        _baseURL = [NSURL URLWithString:baseURL];
        
        [self _initialze];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static SWCommonAPI *_api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _api = [[SWCommonAPI alloc] initWithBaseURL:SW_SERVER_API_BASE_URL];
    });
    return _api;
}


- (void)post:(NSString *)apiname
      params:(NSDictionary *)params
 withSuccess:(SWApiSuccessBlock)successBlock
     failure:(SWApiFailureBlock)failureBlock
{
    NSURL *reqURL = [NSURL URLWithString:apiname relativeToURL:_baseURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:reqURL];
    [req setValue:@"post" forHTTPHeaderField:@"method"];
    
    SWHttpRequestOperation *o = [self httpRequestOperationForURLRequest:req
                                    success:successBlock
                                    failure:failureBlock];
    
    [self.operationQueue addOperation:o];
    
}

- (SWHttpRequestOperation *)httpRequestOperationForURLRequest:(NSURLRequest *)url
                                               success:(SWApiSuccessBlock)success
                                               failure:(SWApiFailureBlock)failure
{
    SWHttpRequestOperation *o = [[SWHttpRequestOperation alloc] initWithReqURL:url successBlock:success failureBlock:failure];
    
    return o;
}


@end
