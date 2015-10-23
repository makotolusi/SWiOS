//
//  LoadingView.h
//  SWiOS
//
//  Created by 陆思 on 15/10/22.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+(UIActivityIndicatorView*)initWithFrame:(CGRect)frame parentView:(UIView*)parentView;
+(void)stopAnimating:(UIView*)parentView;
@end
