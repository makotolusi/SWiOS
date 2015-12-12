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
static CGFloat kSWCellCountTag = 1;
@implementation ShoppingCartCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView=[[YCAsyncImageView alloc] init];
        [self addSubview:_imgView];
        
        _title=[[UILabel alloc] init];
        _title.lineBreakMode =NSLineBreakByWordWrapping;
        _title.numberOfLines = 2;
        _title.textAlignment=NSTextAlignmentLeft;
        [_title smallLabel];
        [self addSubview:_title];
        
        _price=[[UILabel alloc] init];
        [self labelStyle:_price text:[@"¥ " stringByAppendingFormat:@"%@",_activityProduct.rushPrice] size:13];
        [self addSubview:_price];
        
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
    //count
    _count=[[UILabel alloc] init];
    _count.tag=kSWCellCountTag;
    [_plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [_minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_minus];
    [self addSubview:_count];
    [self addSubview:_plus];
     }
}

- (void)settingData{
    _imgView.url=_activityProduct.picUrl1;
    _title.text=_activityProduct.productName;
    _price.text=_activityProduct.rushPrice.stringValue;
    [self labelStyle:_count text:[@"X " stringByAppendingFormat:@"%d",_activityProduct.buyCount.intValue] size:12];
}

- (void)settingFrame{
    _imgView.translatesAutoresizingMaskIntoConstraints=NO;
    _title.translatesAutoresizingMaskIntoConstraints=NO;
    _price.translatesAutoresizingMaskIntoConstraints=NO;
    _minus.translatesAutoresizingMaskIntoConstraints=NO;
    _plus.translatesAutoresizingMaskIntoConstraints=NO;
    _count.translatesAutoresizingMaskIntoConstraints=NO;
    float w=SCREEN_HEIGHT/7;
  
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgView,_title,_price);
    if (_isEdit) {
        [views setValue:_plus forKey:@"_plus"];
        [views setValue:_minus forKey:@"_minus"];
        [views setValue:_count forKey:@"_count"];
    }
    
    NSDictionary *metrics = @{@"imageEdge":[NSString stringWithFormat:@"%f",w-10.0],@"padding":@5.0,@"toImg":@10.0,@"titleWidth":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.7],@"titleHeight":@40,@"editViewWidth":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.3]};//设置一些常量
    //    NSLog(@"%f",size.height);
    //设置bgView与superview左右对齐
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[_imgView(imageEdge)]-toImg-[_title(titleWidth)]" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView(imageEdge)]-toImg-[_price(40)]" options:0 metrics:metrics views:views]];
    //-padding-[_count(40)]-padding-[_plus(20)
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgView(imageEdge)]-toImg-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_price(20)]-toImg-|" options:0 metrics:metrics views:views]];
    
    if (_isEdit) {
  
       [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_minus(15)]-50-[_count(40)]-20-[_plus(15)]-40-|" options:0 metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_minus(15)]-toImg-|" options:0 metrics:metrics views:views]];
     [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_plus(==_minus)]-toImg-|" options:0 metrics:metrics views:views]];
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
//    [_infoView removeFromSuperview];
//    [editView removeFromSuperview];
 

   
    NSLog(@" y %f cell height %f",_imgView.frame.origin.y,self.frame.size.height);
    //info view
   


  

   
   
    
//
////    _infoView.backgroundColor=[UIColor lightGrayColor];
//  
//    
//    //count1
//    UILabel *count1=[[UILabel alloc] initWithFrame:CGRectMake(_infoView.frame.size.width-40, _infoView.frame.size.height-15, 50, 15)];
//    [self labelStyle:count1 text:[NSString stringWithFormat:@"X%d",_activityProduct.buyCount.intValue] size:11];
//
    
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(labelTextColor);
    label.text=text;
    label.font=[UIFont fontWithName:FONT_TYPE size:size ];
}
-(void)minusPlus:(UIButton*)button withSign:(NSString *) sign{
    [button setImage:[UIImage imageNamed:sign] forState:UIControlStateNormal];
    button.imageEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=7.0f;
    button.alpha=0.7f;
//    [button setTitle:sign forState:UIControlStateNormal];
    //    minus.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:15 ];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor=UIColorFromRGB(0x1abc9c).CGColor;
    
   [self addSubview:button];
}

- (void)plusAction:(UIButton*)sender{
    if (_activityProduct.buyCount.intValue<_activityProduct.rushQuantity) {
        _activityProduct.buyCount=[[NSNumber alloc] initWithInt:_activityProduct.buyCount.intValue+1];
         [ShoppingCartLocalDataManager insertShoppingCart:_activityProduct];
        [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) _activityProduct.buyCount.intValue];
        if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
            [_delegate totalPrice: _activityProduct type:0]; // 通知执行协议方法
        }
    }else{
        [UIAlertView showMessage:@"库存不足"];
    }
    
}
- (void)minusAction:(UIButton*)sender{
    if( _activityProduct.buyCount.intValue>1){
         _activityProduct.buyCount=[[NSNumber alloc] initWithInt:_activityProduct.buyCount.intValue-1];
        [ShoppingCartLocalDataManager insertShoppingCart:_activityProduct];
        [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
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
