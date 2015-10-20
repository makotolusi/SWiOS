//
//  AddressViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/14.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
#import "HZAreaPickerView.h"
#import "DatabaseManager.h"
@interface AddressViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,HZAreaPickerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    @private
        UITableView    *_tableView;
        UILabel *_placeholderLabel;
        NSArray *paymentArray;
}
@property(nonatomic,assign)NSInteger addressId;
@property(nonatomic,strong)DatabaseManager *databaseManager;
@property(nonatomic,strong)UIAlertView *alert;

@end
