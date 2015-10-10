//
//  FileUploadHelper.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/15.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "FileUploadHelper.h"
#import "AFNetworking.h"



@implementation FileUploadHelper

//NSString * const kInitURL = @"getUpToken";

-(instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)uploadFileToQiniuByPutFile
{

    NSString* fileName = [NSString
        stringWithFormat:@"sculpture/%@_%@.jpg", [self getDateTimeString],
        [self randomStringWithLength:8]];

    QNUploadManager* upManager = [[QNUploadManager alloc] init];

    [upManager
         putFile:_imageFilePath
             key:fileName
           token:_token
        complete:^(QNResponseInfo* info, NSString* key, NSDictionary* resp) {

            NSLog(@" --->> Info: %@  ", info);
            NSLog(@" ---------------------");
            NSLog(@" --->> Response: %@,  ", resp);

            if (info.error) {

                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

                    if (self.delegate != nil &&
                        [self.delegate respondsToSelector:@selector(failed:)]) {
                        [self.delegate failed:info];
                    }
                });
            }

        } option:nil];
}

#pragma mark - Helpers

- (NSString*)getDateTimeString
{
    NSDateFormatter* formatter;
    NSString* dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}

- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters             = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i                    = 0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

- (NSString*)makeUpToken
{

    NSString* token = nil;
    NSString* tokenApi = @"getUpToken";
    [HttpHelper sendAsyncRequest:tokenApi
        success:^(id token) {
            NSLog(@"JSON: %@", token);


            _token = [token stringByReplacingOccurrencesOfString:@"\"" withString:@""];

            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {

                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sucessed)]) {
                    [self.delegate sucessed];
                }
            });

        }
        fail:^{

            NSLog(@"fail: ");

        }];

    return token;
}


@end
