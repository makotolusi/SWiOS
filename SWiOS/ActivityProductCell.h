//
//  ActivityProductCellTableViewCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityProduct.h"
#import "YCAsyncImageView.h"
#import "ShoppingCartModel.h"
#import "EmptyCell.h"
@interface ActivityProductCell : EmptyCell
@property (strong,nonatomic) ActivityProduct *activityProduct;
@property (weak, nonatomic) IBOutlet YCAsyncImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UIButton *cartButton;
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end
