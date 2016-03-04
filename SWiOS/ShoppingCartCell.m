//
//  ShoppingCartCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "UIColor+Extension.h"
#import "UIAlertView+Extension.h"
#import "ShoppingCartLocalDataManager.h"
#import "UILabel+Extension.h"
#import "MPview.h"
#import "NSString+Extension.h"
static CGFloat kSWCellCountTag = 1;
@implementation ShoppingCartCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cartModel=[ShoppingCartModel sharedInstance];
        _imgView=[[YCAsyncImageView alloc] init];
        [self addSubview:_imgView];
        

        _err=[[UILabel alloc] init];
         [_err smallLabel];
        _err.textColor=[UIColor redColor];
        [self addSubview:_err];
       
        
        _title=[[UILabel alloc] init];
        _title.lineBreakMode =NSLineBreakByWordWrapping;
        _title.numberOfLines = 2;
        _title.textAlignment=NSTextAlignmentLeft;
        [_title smallLabel];
        [self addSubview:_title];
        
        _price=[[UILabel alloc] init];
        [self labelStyle:_price text:[@"¥ " stringByAppendingFormat:@"%@",_activityProduct.rushPrice] size:13];
        [self addSubview:_price];
        
        //count
        _count=[[UILabel alloc] init];
        _count.tag=kSWCellCountTag;
        [self addSubview:_count];
    }
    return self;
}
- (void)initEdite{
     if (_isEdit) {
    //-
    _minus=[[UIButton alloc] init];
    [self minusPlus:_minus withSign:@"jianhao"];
    //+
     _plus=[[UIButton alloc] init];
    [self minusPlus:_plus withSign:@"jiahao"];
    
    [_plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [_minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_minus];
    
    [self addSubview:_plus];
     }
}

-(void)initOrderViewWithOrderModel{
//    if (_isOrder) {
         _status=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [_status smallLabel];
    
        _status.textColor=[UIColor lightGrayColor];
        [self addSubview:_status];
        _orderNum=[[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        [_orderNum smallLabel];
        [self addSubview:_orderNum];
//    }
}
- (void)settingDataOrderModel:(OrderModel*)order{
    
//    if (_isOrder) {
    _status.text=_cartModel.orderStatus[order.status];//@"订单已取消";
    _orderNum.text=_S( @"订单号:%@", order.orderCode);
//    }
}

- (void)removeOrderMode{

//    [status removeFromSuperview];
//    [orderNum removeFromSuperview];
}
- (void)settingData{
    _imgView.url=_activityProduct.picUrl1;
    _title.text=_activityProduct.productName;
    if ([@"STOCK_NOT_ENOUGH" isEqualToString:_activityProduct.code]) {
        _err.text=@"库存不足";
    }
    
    if ([@"NONE_PRODUCT" isEqualToString:_activityProduct.code]) {
        _err.text=@"库存不足";
    }
    
    if ([@"NONE_ACTIVITY" isEqualToString:_activityProduct.code]) {
        _err.text=@"库存不足";
    }
    
    _price.text=_activityProduct.rushPrice.stringValue;
//
    [self labelStyle:_count text:[@"X " stringByAppendingFormat:@"%d",_activityProduct.buyCount.intValue] size:12];
}

- (void)settingFrame{
    _imgView.translatesAutoresizingMaskIntoConstraints=NO;
    _title.translatesAutoresizingMaskIntoConstraints=NO;
    _price.translatesAutoresizingMaskIntoConstraints=NO;
    _minus.translatesAutoresizingMaskIntoConstraints=NO;
    _plus.translatesAutoresizingMaskIntoConstraints=NO;
    _count.translatesAutoresizingMaskIntoConstraints=NO;
    _err.translatesAutoresizingMaskIntoConstraints=NO;
    float w=SCREEN_HEIGHT/7;
  
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgView,_title,_price,_err);
    if (_isEdit) {
        [views setValue:_plus forKey:@"_plus"];
        [views setValue:_minus forKey:@"_minus"];
        
    }
    [views setValue:_count forKey:@"_count"];
    NSDictionary *metrics = @{@"imageEdge":[NSString stringWithFormat:@"%f",w-10.0],@"padding":@5.0,@"toImg":@10.0,@"titleWidth":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.7],@"titleHeight":@40,@"editViewWidth":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.3],@"plusminusW":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.06]};//设置一些常量
    //    NSLog(@"%f",size.height);
    //设置bgView与superview左右对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[_imgView(imageEdge)]-toImg-[_title(titleWidth)]" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView(imageEdge)]-toImg-[_price(40)]" options:0 metrics:metrics views:views]];
    
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView(imageEdge)]-toImg-[_err]" options:0 metrics:metrics views:views]];
    
    //-padding-[_count(40)]-padding-[_plus(20)
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgView(imageEdge)]-toImg-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_err]-[_price(20)]-toImg-|" options:0 metrics:metrics views:views]];
    
    
    if (_isEdit) {
  
       [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_minus(plusminusW)]-50-[_count(40)]-20-[_plus(plusminusW)]-40-|" options:0 metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_minus(plusminusW)]-toImg-|" options:0 metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_plus(==_minus)]-toImg-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_count(20)]-toImg-|" options:0 metrics:metrics views:views]];
    }else{
         [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_count(40)]-20-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_count(20)]-toImg-|" options:0 metrics:metrics views:views]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DEDEDE"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width, 1));
//}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(labelTextColor);
    label.text=text;
    label.font=[UIFont fontWithName:FONT_TYPE size:size ];
}
-(void)minusPlus:(UIButton*)button withSign:(NSString *) sign{
    [button setImage:[UIImage imageNamed:sign] forState:UIControlStateNormal];
    button.imageEdgeInsets=UIEdgeInsetsMake(4, 4, 4, 4);
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=8.0f;
    button.alpha=0.7f;
//    [button setTitle:sign forState:UIControlStateNormal];
    //    minus.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:15 ];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor=UIColorFromRGB(0x1abc9c).CGColor;
    
   [self addSubview:button];
}

- (void)plusAction:(UIButton*)sender{
    if ([ShoppingCartModel add2CartWithProduct:_activityProduct buyCount:1]) {
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) _activityProduct.buyCount.intValue];
        if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
            [_delegate totalPrice: _activityProduct type:0]; // 通知执行协议方法
        }
    }
}
- (void)minusAction:(UIButton*)sender{
    if ([ShoppingCartModel removeCartWithProduct:_activityProduct count:1]) {
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) _activityProduct.buyCount.intValue];
        if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
            [_delegate totalPrice: _activityProduct type:1]; // 通知执行协议方法
        }

    }
}

//- (void)editOrComplete:(BOOL)selected{
//    if (selected) {
//        editView.hidden=NO;
//        _infoView.hidden=YES;
//    }else{
//        editView.hidden=YES;
//        _infoView.hidden=NO;
//    }
//}

- (void)removeCart:(UIButton*)sender{
    
    [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationLeft];

}


@end
