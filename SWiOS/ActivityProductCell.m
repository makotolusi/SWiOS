//
//  ActivityProductCellTableViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ActivityProductCell.h"
#import "UILabel+Extension.h"
#import "UIImageView+WebCache.h"
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
//    [_imgView setUrl:_activityProduct.picUrl1];
//    
    UIImage* img=[UIImage imageNamed:@"imageplaceholder-120"];
    //    img=[self scaleToSize:img size:CGSizeMake(60, 60)];
   UIImageView* _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 120, 120)];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_activityProduct.picUrl1]
            placeholderImage:img];
    
    _productName.text=_activityProduct.productName;
    [_productName midLabel];
    NSLog(@"float %@",_activityProduct.rushPrice);
    _price.text=[NSString stringWithFormat:@"￥ %@", _activityProduct.rushPrice];
    _totalCount.text=[NSString stringWithFormat:@"剩余 %d 件",_activityProduct.rushQuantity];
    [self addSubview:_imgView];
}



@end
