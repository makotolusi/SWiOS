//
//  Activity.h
//  SWiOS
//
//  Created by 陆思 on 15/9/30.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
@property(nonatomic,strong)NSNumber *_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *des;
@property(nonatomic,copy)NSString *beginTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *imageUrl;
@end
