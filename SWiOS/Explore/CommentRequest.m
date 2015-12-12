//
//  CommentRequest.m
//  SWiOS
//
//  Created by 陆思 on 15/11/23.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "CommentRequest.h"
#import "CommentModel.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
@implementation CommentRequest

+(void)listComment:(NSString*)productCode page:(int)page next:(void (^)(NSDictionary*))next{
    NSString* url=[NSString stringWithFormat:@"getCommentsByPaging/%@/%d", productCode,page];
    [HttpHelper sendPostRequest:url
                     parameters: nil
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                NSDictionary* data=[result valueForKey:@"data"];
                                next(data);
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        } parentView:nil];
}

+(void)addComment:(CommentModel*)comment next:(void (^)())next{
    NSDictionary* lu=[comment toDictionary];
    //    [lu setValue:@"%@" forKey:@"orderCode"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lu options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dict1 = @{@"content": jsonString};
    [HttpHelper sendPostRequest:@"addComment"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                  next();
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        }];
}

@end
