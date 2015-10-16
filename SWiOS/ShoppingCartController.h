//
//  ShoppingCartController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "ShoppingCartModel.h"
@interface ShoppingCartController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
    BOOL isEdit;
    NSMutableArray *_data;
//    int sumPrice;
    UILabel *totalPrice;
}
//@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end
