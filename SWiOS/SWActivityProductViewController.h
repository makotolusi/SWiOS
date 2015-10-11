//
//  SWActivityProductViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "Activity.h"
#import "ShoppingCartModel.h"
@interface SWActivityProductViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
    NSMutableArray *_data;
    UIImageView *bottomImageView;
    UILabel *priceLabel;
    UIButton *bottomLabel;
}
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@property (nonatomic,strong)  Activity *activity;
@end
