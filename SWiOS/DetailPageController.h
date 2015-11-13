//
//  DetailPageController.h
//  SWiOS
//
//  Created by 陆思 on 15/11/1.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"
#import "ActivityProduct.h"
#import "ShoppingCartModel.h"
@interface DetailPageController : SWBaseViewController

@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic,strong)ActivityProduct *product;
@property(strong,nonatomic)ShoppingCartModel *cartModel;
@property (strong, nonatomic) UIActivityIndicatorView*  activityIndicator;
@end
