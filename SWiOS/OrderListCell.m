//
//  OrderListCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/13.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderListCell.h"
#import "ShoppingCartModel.h"
#import "YCAsyncImageView.h"
#import "ActivityProduct.h"
@implementation OrderListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    ShoppingCartModel *cartModel=[ShoppingCartModel sharedInstance];
    NSMutableArray *orders=cartModel.arOfWatchesOfCart;
    int with=orderListCellHeight;
    int startX=5;
    _imgScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, with*4+startX*4, with)];
    
    int totalWith = 0;
    int i=0;
    for (ActivityProduct *order in orders) {
//        _imgScroll.backgroundColor=[UIColor lightGrayColor];
        int x=startX*(i+1)+with*i;
        NSLog(@"%d",x);
        YCAsyncImageView *view1 = [[YCAsyncImageView alloc] initWithFrame:CGRectMake(x,5,with,with)];
        [view1 setUrl:order.picUrl1];
        [_imgScroll addSubview:view1];
        totalWith=totalWith+5+with;
        i++;
    }
    _imgScroll.contentSize = CGSizeMake(totalWith, with);
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    _imgScroll.contentOffset = CGPointMake(0, 0);
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    _imgScroll.pagingEnabled = YES;
    [self addSubview:_imgScroll];
}
@end
