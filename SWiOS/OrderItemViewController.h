//
//  OrderItemViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/28.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "ShoppingCartModel.h"
@interface OrderItemViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@property (nonatomic,strong) NSArray *errCartProduct;

@end
