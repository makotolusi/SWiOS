//
//  HttpHelper.h
//  SWUITableView
//
//  Created by 李乐 on 15/9/21.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpHelper : NSObject

#pragma  mark - sending requests

+(NSString*)getUrl;
+ (void)sendAsyncRequest:(NSString *)urlBase success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)sendPostRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail;
+ (void)sendGetRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail;
+ (void)sendGetRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail parentView:(UIView*)parentView;
+ (void)sendPostRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail parentView:(UIView*)parentView;

+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;
@end
