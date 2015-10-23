//
//  OrderPriceCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/12.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderPriceCell.h"
#import "ShoppingCartModel.h"
@implementation OrderPriceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    _cartModel=[ShoppingCartModel sharedInstance];
    _priceLabel.textColor=UIColorFromRGB(labelTextColor);
    _priceLabel.text=[NSString stringWithFormat:@"¥  %@",_cartModel.orderModel.totalPrice];
}

@end
