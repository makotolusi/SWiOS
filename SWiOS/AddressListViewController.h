//
//  AddresListViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/19.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "AddressListCell.h"
#import "ShoppingCartModel.h"
@interface AddressListViewController : SWBaseViewController <UITableViewDelegate, UITableViewDataSource, AddressListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShoppingCartModel *cartModel;

@property(strong,nonatomic) NSIndexPath* lastPath;
-(void)reloadTableView;
@end
