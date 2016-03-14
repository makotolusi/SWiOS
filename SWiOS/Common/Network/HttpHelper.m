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
#import "ZipArchive.h"
@implementation HttpHelper

bool const isDev=NO;

bool const isLocal=NO;

NSString * const kBaseURL = @"http://115.28.47.164:9889/mgserver/ApCommonServices/";

NSString * const kLocalURL = @"http://10.6.110.4:8080/mgserver/ApCommonServices/";//http://115.28.47.164:9889 http://10.6.110.4:8080

//10.6.110.4:8080 ali
//
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
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"%@", @"网络已连接");
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
        fail();
//         [UIAlertView showMessage:@"连接异常！"];
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

    [LoadingView initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) parentView:parentView];
    [HttpHelper sendGetRequest:urlApi parameters:parameters success:^(id response) {
        success(response);
        [LoadingView stopAnimating:nil];
    } fail:^(id response) {
        [LoadingView stopAnimating:nil];
    }];
}

/*
*  @author Jakey
*
*  @brief  下载文件
*
*  @param paramDic   附加post参数
*  @param requestURL 请求地址
*  @param savedPath  保存 在磁盘的位置
*  @param success    下载成功回调
*  @param failure    下载失败回调
*  @param progress   实时下载进度回调
*/
+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:requestURL parameters:paramDic error:nil];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
//        NSString *zipPath = @"/Users/lusi/Library/Developer/CoreSimulator/Devices/180BD695-FF92-4B55-AA47-EBF95A9076D7/data/Containers/Data/Application/1E5FF16D-A9D4-4B74-93A4-E75CEC767806/Documents/nirvana.zip";

        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *path = [paths objectAtIndex:0];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSLog(@"path %@",docDir);
         NSString *destination =[docDir stringByAppendingString:@"/zipresult"] ;
        NSString *zipPath = savedPath;
        
        
        [self extractZipFileWithUnzipFileAtPath:zipPath toDestination:destination];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}


/*
 *  ExtractZipFile : 解压指定文件
 * lpszZipFile: 要解压的文件
 * lpszDestPath: 指定解压到的目录
 * 返回压缩成功与否
 */
+(void)extractZipFileWithUnzipFileAtPath:(NSString *)zipPath toDestination:(NSString *)destination
{
    ZipArchive *za = [[ZipArchive alloc] init];
    // 1
    if ([za UnzipOpenFile: zipPath]) {
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docDir = [paths objectAtIndex:0];
//        NSLog(@"path %@",docDir);
        // 2
        BOOL ret = [za UnzipFileTo: destination overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
    
    }
}

@end
