//
//  FavorViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/11/30.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"
@interface FavorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView    *_tableView;
}
@property (nonatomic,strong) ShoppingCartModel *cartModel;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic, assign)NSUInteger currentPageNum;

@end
