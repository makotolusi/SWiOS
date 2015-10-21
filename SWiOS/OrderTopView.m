//
//  OrderTopView.m
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderTopView.h"
#import "UILabel+Extension.h"
@implementation OrderTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _imgView.image=[UIImage imageNamed:@"order"];
        _orderPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 10, 100, 20)];
        [_orderPriceLabel midLabel];
        _orderPriceLabel.text=@"订单金额:";
        _orderPriceLabel.textColor=[UIColor whiteColor];
         _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(_orderPriceLabel.frame.origin.x+70, 10, 100, 20)];
        _priceLabel.text=@"¥ 499";
        [_priceLabel midLabel];
        _priceLabel.textColor=UIColorFromRGB(0x1abc9c);
        _orderCodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(_orderPriceLabel.frame.origin.x-10, _orderPriceLabel.frame.origin.y+20, 300, 20)];
        _orderCodeLabel.text=@"订单号:123141234235245";
        [_orderCodeLabel smallLabel];
        [self addSubview:_imgView];
        [self addSubview:_orderPriceLabel];
        [self addSubview:_priceLabel];
        [self addSubview:_orderCodeLabel];
    }
    return self;
}

@end
