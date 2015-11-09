//
//  ShoppingCartCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "UIColor+Extension.h"

static CGFloat kSWCellCountTag = 1;
@implementation ShoppingCartCell


- (void)awakeFromNib {
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DEDEDE"].CGColor);
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width, 1));
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    [_infoView removeFromSuperview];
    [editView removeFromSuperview];
    _imgView=[[YCAsyncImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-100, 90, 90) url:_activityProduct.picUrl1];
//    [_imgView setUrl:_activityProduct.picUrl1];
//    _imgView.frame=CGRectMake(10, self.frame.size.height-100, 90, 90);
    [self addSubview:_imgView];
    NSLog(@" y %f cell height %f",_imgView.frame.origin.y,self.frame.size.height);
    //info view
    _infoView=[[UIView alloc] initWithFrame:CGRectMake(_imgView.frame.size.width+20,self.frame.size.height-95, SCREEN_WIDTH/3*2, _imgView.frame.size.height)];
    //    _infoView.backgroundColor=[UIColor lightGrayColor];
    UILabel *title=[[UILabel alloc] init];
    title.lineBreakMode =NSLineBreakByWordWrapping;
    title.numberOfLines = 2;
    title.textAlignment=NSTextAlignmentLeft;
    title.text=_activityProduct.productName;
    title.font=[UIFont systemFontOfSize:13];
    CGSize size = [title sizeThatFits:CGSizeMake(_infoView.frame.size.width, MAXFLOAT)];
    title.frame=CGRectMake(0, 0, _infoView.frame.size.width-10, size.height);
    //price
    UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(0, _infoView.frame.size.height-20, 70, 15)];
    [self labelStyle:price text:[@"¥ " stringByAppendingFormat:@"%@",_activityProduct.rushPrice] size:13];
    //count1
    UILabel *count1=[[UILabel alloc] initWithFrame:CGRectMake(_infoView.frame.size.width-40, _infoView.frame.size.height-15, 50, 15)];
    [self labelStyle:count1 text:[NSString stringWithFormat:@"X%ld",_activityProduct.buyCount] size:13];
    [_infoView addSubview:title];
    [_infoView addSubview:price];
    if ([self isEdit]) {
        //edit view
        editView=[[UIView alloc] initWithFrame:_infoView.frame];
        editView.backgroundColor=[UIColor whiteColor];
        //-
        UIButton *minus=[[UIButton alloc] initWithFrame:CGRectMake(price.frame.size.width+30, price.frame.origin.y, 15, 15)];
        [self minusPlus:minus withSign:@"jianhao"];
        //+
        UIButton *plus=[[UIButton alloc] initWithFrame:CGRectMake(minus.frame.origin.x+100, minus.frame.origin.y, 15, 15)];
        [self minusPlus:plus withSign:@"jiahao"];
        
        //count
        UILabel *count=[[UILabel alloc] initWithFrame:CGRectMake(minus.frame.origin.x+(plus.frame.origin.x-minus.frame.origin.x)/2,minus.frame.origin.y, 30, 20)];
        count.tag=kSWCellCountTag;
        [plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
        [minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self labelStyle:count text:[@"X " stringByAppendingFormat:@"%ld",_activityProduct.buyCount] size:12];
        [_infoView addSubview:count];
    }
   
    //trash image
//    UIImageView *trash=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trash2"]];
//    trash.frame=CGRectMake(plus.frame.origin.x+50, minus.frame.origin.y-5, 25, 25);
//    UIButton *trashButton = [[UIButton alloc] initWithFrame:CGRectMake(plus.frame.origin.x+50, minus.frame.origin.y-5, 25, 25)];
//    trashButton.backgroundColor=[UIColor blackColor];
//    [trashButton setTitle:@"xxxxx" forState:UIControlStateNormal];
//      [trashButton addTarget:self action:@selector(removeCart:) forControlEvents:UIControlEventTouchUpInside];
//    [editView addSubview:trashButton];
//    [trashButton addSubview:trash];
//    [self addSubview:editView];
    [self addSubview:_infoView];
    
//    [self editOrComplete:self.isEdit];
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(0x1abc9c);
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    label.font=[UIFont fontWithName:@"STHeitiK-Light" size:size ];
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
    
   [_infoView addSubview:button];
}

- (void)plusAction:(UIButton*)sender{
     _activityProduct.buyCount+=1;
    [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
    UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
    countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) _activityProduct.buyCount];
    if ([_delegate respondsToSelector:@selector(totalPrice:type:)]) { // 如果协议响应了sendValue:方法
        [_delegate totalPrice: _activityProduct type:0]; // 通知执行协议方法
    }
}
- (void)minusAction:(UIButton*)sender{
    if( _activityProduct.buyCount>1){
         _activityProduct.buyCount-=1;
        [_cartModel.arOfWatchesOfCart replaceObjectAtIndex:_indexPath.row-1 withObject:_activityProduct ];
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"X " stringByAppendingFormat:@"%ld",(long) _activityProduct.buyCount];
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
