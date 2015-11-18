//
//  MPview.m
//  SWiOS
//
//  Created by 陆思 on 15/11/13.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "MPview.h"
#import "UIAlertView+Extension.h"
static CGFloat kSWCellCountTag = 1;


@implementation MPview



-(instancetype)initWithFrame:(CGRect)frame gap:(float)gap{
    self=[super initWithFrame:frame];
    if(self){
        _count=1;
        _cartModel=[ShoppingCartModel sharedInstance];
        self.backgroundColor=[UIColor whiteColor];
        //-
        UIButton *minus=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self minusPlus:minus withSign:@"jianhao"];
        //+
        UIButton *plus=[[UIButton alloc] initWithFrame:CGRectMake(minus.frame.origin.x+gap, minus.frame.origin.y, 20, 20)];
        [self minusPlus:plus withSign:@"jiahao"];
        
        //count
        UILabel *count=[[UILabel alloc] initWithFrame:CGRectMake(minus.frame.origin.x+(plus.frame.origin.x-minus.frame.origin.x)/2,minus.frame.origin.y, 30, 20)];
        count.tag=kSWCellCountTag;
        [plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
        [minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self labelStyle:count text:[@"X " stringByAppendingFormat:@"%d",_count] size:12];//_activityProduct.buyCount
        [self addSubview:count];

    }
    return self;
}

-(void)minusPlus:(UIButton*)button withSign:(NSString *) sign{
    [button setImage:[UIImage imageNamed:sign] forState:UIControlStateNormal];
    button.imageEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=9.0f;
    button.alpha=0.7f;
    //    [button setTitle:sign forState:UIControlStateNormal];
    //    minus.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:15 ];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor=UIColorFromRGB(0x1abc9c).CGColor;
    
    [self addSubview:button];
}

- (void)plusAction:(UIButton*)sender{
//    _activityProduct.buyCount+=1;
//    []
//    [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
    if (_product.buyCount<_product.rushQuantity) {
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) ++_count];
//        _product.buyCount=_product.buyCount+1;
    }else{
        [UIAlertView showMessage:@"库存不足"];
    }
    
//    if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
//        [_delegate totalPrice: _activityProduct type:0]; // 通知执行协议方法
//    }
}
- (void)minusAction:(UIButton*)sender{
//    if( _activityProduct.buyCount>1){
//        _activityProduct.buyCount-=1;
//        [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
    if (_count>1) {
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) --_count];
//        _product.buyCount=_product.buyCount-1;
    }
//        if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
//            [_delegate totalPrice: _activityProduct type:1]; // 通知执行协议方法
//        }
//    }
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(0x1abc9c);
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    label.font=[UIFont fontWithName:@"STHeitiK-Light" size:size ];
}
@end
