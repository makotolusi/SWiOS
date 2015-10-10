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
@interface ShoppingCartCell : EmptyCell
{
    @private
    UIView *editView;
    UIView *infoView;
}
@property (weak, nonatomic) IBOutlet YCAsyncImageView *imgView;
@property (strong,nonatomic) ActivityProduct *activityProduct;
@property (assign,nonatomic) BOOL isEdit;
@end
