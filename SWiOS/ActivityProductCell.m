//
//  ActivityProductCellTableViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityProductCell.h"
#import "UILabel+Extension.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
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
    float imgViewSize=SCREEN_WIDTH/3;
    //initWithFrame:CGRectMake(8, 8, imgViewSize, imgViewSize)];
    [self.imgView setImageWithURL:[NSURL URLWithString:_activityProduct.picUrl1] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.imgView.tag=1;
    _productName.text=_activityProduct.productName;
    _productName.textAlignment=NSTextAlignmentLeft;
    [_productName midLabel];
    _price.text=[NSString stringWithFormat:@"￥ %@", _activityProduct.rushPrice];
    _totalCount.text=[NSString stringWithFormat:@"剩余 %d 件",_activityProduct.rushQuantity];
    
}



@end
