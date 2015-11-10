//
//  BalanceController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/12.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "AddressModel.h"
#import "ShoppingCartModel.h"
@interface BalanceController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    @private
        NSMutableArray* groups;
        UITableView    *_tableView;
        NSArray *paymentArray;
}

@property (strong, nonatomic) UIPickerView *paymentPicker;
@property (nonatomic,strong) AddressModel *addressModel;

@property (nonatomic,strong) ShoppingCartModel *cartModel;
-(void)reloadTableView;
@end
