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
@interface AddressListViewController : SWBaseViewController <UITableViewDelegate, UITableViewDataSource, AddressListCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
-(void)reloadTableView;
@end
