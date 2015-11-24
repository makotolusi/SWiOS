//
//  CommentRequest.h
//  SWiOS
//
//  Created by 陆思 on 15/11/23.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
@interface CommentRequest : NSObject

+(void)listComment:(NSString*)productCode next:(void (^)())next;
+(void)addComment:(CommentModel*)comment next:(void (^)())next;
@end
