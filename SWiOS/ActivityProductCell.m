//
//  ActivityProductCellTableViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityProductCell.h"
#import "UILabel+Extension.h"
@implementation ActivityProductCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_imgView setUrl:_activityProduct.picUrl1];
    _productName.text=_activityProduct.productName;
    [_productName midLabel];
    NSLog(@"float %@",_activityProduct.rushPrice);
    _price.text=[NSString stringWithFormat:@"￥ %@", _activityProduct.rushPrice];
    _totalCount.text=[NSString stringWithFormat:@"剩余 %ld 件",_activityProduct.rushQuantity];

}



@end
