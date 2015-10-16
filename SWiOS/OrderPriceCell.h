//
//  OrderPriceCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/12.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyCell.h"
#import "ShoppingCartModel.h"
@interface OrderPriceCell : EmptyCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end
