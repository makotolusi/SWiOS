//
//  OrderTopView.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTopView : UIView
-(instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *orderPriceLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *orderCodeLabel;

@end
