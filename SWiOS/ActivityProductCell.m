//
//  ActivityProductCellTableViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityProductCell.h"

@implementation ActivityProductCell

- (void)awakeFromNib {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    _price.text=[NSString stringWithFormat:@"￥ %@", _activityProduct.rushPrice];
   
}



@end
