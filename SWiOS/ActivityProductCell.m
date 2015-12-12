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
    float imgViewSize=SCREEN_WIDTH/3;
    UIImageView* imgView=[[UIImageView alloc] init];//initWithFrame:CGRectMake(8, 8, imgViewSize, imgViewSize)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_activityProduct.picUrl1]
            placeholderImage:img];
    
    _productName.text=_activityProduct.productName;
    _productName.textAlignment=NSTextAlignmentLeft;
    [_productName midLabel];
    NSLog(@"float %@",_activityProduct.rushPrice);
    _price.text=[NSString stringWithFormat:@"￥ %@", _activityProduct.rushPrice];
    _totalCount.text=[NSString stringWithFormat:@"剩余 %d 件",_activityProduct.rushQuantity];
    [self addSubview:imgView];
    imgView.translatesAutoresizingMaskIntoConstraints=NO;
    _productName.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imgView,_productName);
    
    NSDictionary *metrics = @{@"imageEdge":[NSString stringWithFormat:@"%f",imgViewSize],@"padding":@5.0,@"toImg":@10.0};//设置一些常量
    //设置bgView与superview左右对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[imgView(imageEdge)]-toImg-[_productName]" options:0 metrics:metrics views:views]];        // 设置bgView与superview 上边界对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[imgView(imageEdge)]" options:0 metrics:metrics views:views]];        // labelOne与imageview 的水平约束
}



@end
