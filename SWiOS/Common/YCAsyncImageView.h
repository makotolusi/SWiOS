//
//  YCAsyncImageView.h
//  SWiOS
//
//  Created by YuchenZhang on 7/26/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCAsyncImageView : UIImageView

@property (nonatomic, strong) NSString *url;

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;

+(void)removeCache;

@end
