//
//  ShoppingCartCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityProduct.h"
#import "EmptyCell.h"
#import "ShoppingCartController.h"
#import "YCAsyncImageView.h"
@protocol ShoppingCartCellDelegate <NSObject>

- (void)totalPrice:(ActivityProduct*)activityProduct type:(int)type;

@end

@interface ShoppingCartCell : EmptyCell
{
    @private
        UIView *editView;
        UIView *infoView;
}
@property (weak, nonatomic) IBOutlet YCAsyncImageView *imgView;
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,strong) ActivityProduct* activityProduct;
@property (assign,nonatomic) BOOL isEdit;
//@property (assign,nonatomic) int count;
// 委托代理人，代理一般需使用弱引用(weak)
@property (weak, nonatomic) id<ShoppingCartCellDelegate> delegate;
@end
