//
//  BuyBuyBuyViewController.h
//  SWiOS
//
//  Created by 李乐 on 15/8/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"
@interface SWBuyBuyBuyViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
    NSMutableArray *_data;
}
@end
