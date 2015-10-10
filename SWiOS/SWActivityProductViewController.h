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
@interface SWActivityProductViewController : SWBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
    NSMutableArray *_data;
    UIImageView *bottomImageView;
}
@property (nonatomic,strong) NSMutableArray *arOfWatchesOfCart;
@property (nonatomic,strong)  Activity *activity;
@end
