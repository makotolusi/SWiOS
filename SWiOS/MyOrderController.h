//
//  MyOrderController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/29.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"
#import "ShoppingCartModel.h"
@interface MyOrderController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@property (nonatomic,strong) NSMutableArray *orders;
@end
