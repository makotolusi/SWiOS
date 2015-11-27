//
//  SWExploreFlatCell2ValueObject.h
//  SWiOS
//
//  Created by 陆思 on 15/11/20.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWExploreFlatCell2ValueObject : NSObject

@property (nonatomic, strong) NSString *leftUpSideContryImagURL;
@property (nonatomic, strong) NSString *bigImageURL;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *productCode;
@property(nonatomic,assign)int rushQuantity;

@property (nonatomic, assign) long zans;
@property (nonatomic, assign) BOOL isZan;
// this should be make a override method on a super vo class
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end