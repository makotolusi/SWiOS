//
//  BalanceController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/12.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
@interface BalanceController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    @private
        NSMutableArray* groups;
        UITableView    *_tableView;
}
@end
