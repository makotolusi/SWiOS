//
//  AddressModel.h
//  SWiOS
//
//  Created by 陆思 on 15/10/16.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface AddressModel : BaseModel
@property(nonatomic,assign)NSInteger AddressModelID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)int index;
///时间戳
@property (nonatomic, assign) NSTimeInterval mts;
@end
