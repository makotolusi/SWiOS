//
//  LoadingView.m
//  SWiOS
//
//  Created by 陆思 on 15/10/22.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "LoadingView.h"
#define LoadingViewTag 1003
@implementation LoadingView

+ (UIActivityIndicatorView*)initWithFrame:(CGRect)frame parentView:(UIView*)parentView
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (parentView==nil) {
         parentView=window;
    }
   
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
            
            view.tag = LoadingViewTag;
            
            //设置显示样式,见UIActivityIndicatorViewStyle的定义
            view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            
            
            //设置背景色
            view.backgroundColor = [UIColor blackColor];
            
            //设置背景透明
            view.alpha = 0.5;
            
            //设置背景为圆角矩形
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            //设置显示位置
            [view setCenter:CGPointMake(parentView.frame.size.width / 2.0, parentView.frame.size.height / 2.0)];
            
            //开始显示Loading动画
            [view startAnimating];
            
            [parentView addSubview:view];
            

    }
    return view;
}

+(void)stopAnimating:(UIView*)parentView{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (parentView==nil) {
        parentView=window;
    }
    UIActivityIndicatorView* ind= (UIActivityIndicatorView *)[parentView viewWithTag:LoadingViewTag];
   [ind stopAnimating];
    [ind removeFromSuperview];
}
@end
