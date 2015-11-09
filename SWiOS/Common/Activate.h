//
//  Activate.h
//  SWiOS
//
//  Created by 陆思 on 15/9/25.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activate : NSObject
@property (nonatomic, copy) NSString *currentActivateUID;

- (BOOL)Notactivated;
- (void)sendActiveRequest:(void (^)())next;
@end
