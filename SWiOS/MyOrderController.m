//
//  MyOrderController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/29.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "MyOrderController.h"
#import "ShoppingCartCell.h"
#import "HttpHelper.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import "UIWindow+Extension.h"
@interface MyOrderController ()

@end

@implementation MyOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"结束购买" style:UIBarButtonItemStyleDone target:self action:@selector(backRoot:)]];
    [HttpHelper sendGetRequest:@"OrderServices/getUserOrderByToken"
                    parameters: @{}
                       success:^(id response) {
                           NSDictionary* result=[response jsonString2Dictionary];
                           BOOL success=[result valueForKey:@"success"];
                           if(success){
                               _orders=[NSMutableArray array];
                               NSArray* data=[result[@"data"] jsonString2Dictionary];
                               for (id content in data) {
                                   OrderModel *order=[[OrderModel alloc] init];
                                   order.orderCode=content[@"orderCode"];
                                   order.orderDetails=[NSMutableArray arrayWithArray:content[@"orderDetails"]];
//                                   NSDictionary* orderDetails=content[@"orderDetails"];
//                                   NSDictionary* activityProductData=orderDetails[@"activityProductData"];
                                   NSLog(@"%@",order.orderCode);
                                   [_orders addObject:order];
                               }
                               [self loadTable];
                           }
                       }fail:^{
                           NSLog(@"网络异常，取数据异常");
                       }];
    
    
}


-(void)backRoot:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadTable{
    _cartModel=[ShoppingCartModel sharedInstance];
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-110)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    //        _tableView.contentInset = UIEdgeInsetsMake(0, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return _cartModel.arOfWatchesOfCart.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath=indexPath;
      OrderModel *order=_orders[indexPath.section];
    NSDictionary *ods=order.orderDetails[indexPath.row];
    NSDictionary *apd=ods[@"activityProductData"];
   ActivityProduct *ap= [[ActivityProduct alloc] init];
    ap.productName=apd[@"productName"];
    ap.picUrl1=apd[@"picUrl1"];
    ap.rushPrice=apd[@"rushPrice"];
    cell.activityProduct=ap;
    cell.tableView=_tableView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    if (indexPath.row==0) {
        UILabel *status=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [status smallLabel];
        status.text=@"订单已取消";
        status.textColor=[UIColor lightGrayColor];
        [cell addSubview:status];
        UILabel *orderNum=[[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        [orderNum smallLabel];
        OrderModel *order=_orders[indexPath.section];
        orderNum.text=_S( @"订单号:%@", order.orderCode);
//        orderNum.textColor=[UIColor lightGrayColor];
        [cell addSubview:orderNum];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _orders.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderModel *order=_orders[section];
    return order.orderDetails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return _tableView.rowHeight+40;
    }
    return _tableView.rowHeight;
}
@end
