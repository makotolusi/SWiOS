//
//  OrderViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "AddressModel.h"
@interface OrderViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) AddressModel *addressModel;
@end
