//
//  AddressListViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/10/18.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseViewController.h"
@interface AddressListViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
@private
    UITableView    *_tableView;
    NSMutableArray *_data;
}
@end
