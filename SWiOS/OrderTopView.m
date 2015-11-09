//
//  OrderTopView.m
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderTopView.h"
#import "UILabel+Extension.h"
#import "ShoppingCartModel.h"
#import "OrderModel.h"
@implementation OrderTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    ShoppingCartModel *cart=[ShoppingCartModel sharedInstance];
    if (self) {
        _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2-15, 30, 30)];
        _imgView.image=[UIImage imageNamed:@"order64"];
        _orderPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 10, 200, 20)];
        [_orderPriceLabel midLabel];
        _orderPriceLabel.text=[NSString stringWithFormat:@"订单金额: ¥ %@",cart.orderModel.totalPrice];
        _orderPriceLabel.textColor=[UIColor whiteColor];
//         _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(_orderPriceLabel.frame.origin.x+70, 15, 100, 20)];
////        _priceLabel.text=[NSString stringWithFormat:@"¥ %@",cart.orderModel.totalPrice];
//        [_priceLabel midLabel];
//        _priceLabel.textColor=UIColorFromRGB(0x1abc9c);
        _orderCodeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, _orderPriceLabel.frame.origin.y+20, 150, 20)];
        _orderCodeLabel.textAlignment=NSTextAlignmentCenter;
        _orderCodeLabel.text=[NSString stringWithFormat:@"订单号:%@",cart.orderModel.orderCode];//@"";
        _orderCodeLabel.textColor=[UIColor lightGrayColor];
        _orderCodeLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_SMALL_SIZE ];
        [self addSubview:_orderCodeLabel];
        [self addSubview:_imgView];
        [self addSubview:_orderPriceLabel];
//        [self addSubview:_priceLabel];
        
    }
    return self;
}

@end
