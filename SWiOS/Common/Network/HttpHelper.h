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

+ (void)sendAsyncRequest:(NSString *)urlBase success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)sendPostRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail;
+ (void)sendGetRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail;
@end
