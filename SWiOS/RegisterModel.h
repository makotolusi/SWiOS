//
//  RegisterModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/30.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface RegisterModel :JSONModel


@property (assign, nonatomic) int id;
@property (copy, nonatomic) NSString<Optional> *username;
@property (copy, nonatomic) NSString *phoneNum;
//@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString<Optional> *gender;
@property (copy, nonatomic) NSString<Optional> *imgUrl;
@property (copy, nonatomic) NSString<Optional> *smallImgUrl;
@property (copy, nonatomic) NSString<Optional> *originalImgUrl;
//@property (copy, nonatomic) NSString *qq;
//@property (copy, nonatomic) NSString *weixin;
@property (copy, nonatomic) NSString<Optional> *addr;
//@property (copy, nonatomic) NSString *idNumber;
//@property (copy, nonatomic) NSString *email;
//@property (copy, nonatomic) NSString *role;

//+(RegisterModel *)sharedInstance;

@end
