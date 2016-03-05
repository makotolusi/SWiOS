//
//  MPview.h
//  SWiOS
//
//  Created by 陆思 on 15/11/13.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
#import "ActivityProduct.h"
@interface MPview : UIView

@property(strong,nonatomic)ShoppingCartModel *cartModel;
@property(assign,nonatomic)int count;
@property (nonatomic,strong)ActivityProduct *product;
@property (nonatomic,strong)UITextField *countText;
-(instancetype)initWithFrame:(CGRect)frame gap:(float)gap;
@end
