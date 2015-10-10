//
//  SWMe.h
//  YALRentalPullToRefresh
//
//  Created by 李乐 on 15/9/7.
//  Copyright (c) 2015年 Konstantin Safronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMe : NSObject
@property (copy, nonatomic) NSString* describe;
@property (copy, nonatomic) NSString* imgUrl;
- (SWMe*)initWithDescribe:(NSString*)describe andImgUrl:(NSString*)imgUrl;
@end
