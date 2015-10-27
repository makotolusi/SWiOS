//
//  TradeFinishViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/27.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "SWBaseViewController.h"
@interface TradeFinishViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) AddressModel *addressModel;
@end
