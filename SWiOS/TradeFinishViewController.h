//
//  TradeFinishViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/27.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "ShoppingCartModel.h"
@interface TradeFinishViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end
