//
//  ShoppingCartController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
@interface ShoppingCartController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
    BOOL isEdit;
    NSMutableArray *_data;
}
@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@end
