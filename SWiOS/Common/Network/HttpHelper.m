//
//  HttpHelper.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/21.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "HttpHelper.h"
#import "TokenEncrypt.h"
#import "LoadingView.h"
#import "UIAlertView+Extension.h"
@implementation HttpHelper

bool const isDev=NO;

bool const isLocal=YES;

NSString * const kBaseURL = @"http://okeasy.eicp.net:9889/mgserver/ApCommonServices/";

NSString * const kLocalURL = @"http://10.6.110.4:8080/mgserver/ApCommonServices/";//192.168.1.109

+(NSString*)getUrl{
    return (isLocal==YES?kLocalURL:kBaseURL);
}

+(AFHTTPRequestOperationManager *)init:(NSString **)urlApi
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];//设置相应内容类型 
    if(isDev==NO){//非开发模式
        // 配置header参数
        NSString *token = nil;
        NSString *key = nil;
        // 记录当前激活请求中的UID
        [TokenEncrypt generateUidWithKey:&token encryptString:&key Uid:nil];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"k"];
        [manager.requestSerializer setValue:key forHTTPHeaderField:@"c"];
    }
    [HttpHelper netWorkStatus];
    NSString *url=[self getUrl];
    *urlApi = [url stringByAppendingString:*urlApi];
    return manager;
}

+ (void)netWorkStatus
{

    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"%@", @"网络已连接");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self showMessage:@"当前网络不可用"];
                break;
            default:
                break;
        }
    }];

}

+(void)showMessage:(NSString *)message{

    [[[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    
}

+ (void)sendAsyncRequest:(NSString *)urlApi success:(void (^)(id response))success fail:(void (^)())fail
{
    
    [HttpHelper netWorkStatus];
    
    urlApi = [[self getUrl] stringByAppendingString:urlApi];
    NSURL* url = [NSURL URLWithString:[urlApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject) {

        success(operation.responseString);

    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"发生错误！%@", error);
    }];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

+ (void)sendPostRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail
{
    
//    [LoadingView initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) parentView:nil];
    AFHTTPRequestOperationManager *manager= [self init:&urlApi];
    [manager POST:urlApi parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
//         [LoadingView stopAnimating:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [UIAlertView showMessage:@"连接异常！"];
//         [LoadingView stopAnimating:nil];
           NSLog(@"发生错误！%@", error);
    }];
}

+ (void)sendPostRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail parentView:(UIView*)parentView
{
    
    [LoadingView initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) parentView:parentView];
    [HttpHelper sendPostRequest:urlApi parameters:parameters success:^(id response) {
        success(response);
        [LoadingView stopAnimating:nil];
    } fail:^(id response) {
        [LoadingView stopAnimating:nil];
    }];
}

+ (void)sendGetRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager= [self init:&urlApi];
        [manager GET:urlApi parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView showMessage:@"系统很忙哦！"];
        NSLog(@"发生错误！%@", error);
    }];
}

+ (void)sendGetRequest:(NSString *)urlApi parameters:(NSDictionary *)parameters success:(void (^)(id response))success fail:(void (^)())fail parentView:(UIView*)parentView
{

    [LoadingView initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) parentView:nil];
    [HttpHelper sendGetRequest:urlApi parameters:parameters success:^(id response) {
        success(response);
        [LoadingView stopAnimating:nil];
    } fail:^(id response) {
        [LoadingView stopAnimating:nil];
    }];
}
@end
