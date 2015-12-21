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
#import "DetailPageController.h"
@interface MyOrderController ()

@end

@implementation MyOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStyleDone target:self action:@selector(backRoot:)]];
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
                                   order.status=content[@"status"];
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
    float x=self.view.frame.origin.y;
    NSLog(@"x is %f",x);
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTabBarViewHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = SCREEN_HEIGHT*0.15;
//            _tableView.contentInset = UIEdgeInsetsMake(60, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
    if ([@"TradeFinishViewController" isEqualToString:_prePage]) {
         [ShoppingCartModel clearCart];
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *order=_orders[indexPath.section];
    NSDictionary *ods=order.orderDetails[indexPath.row];
    NSDictionary *apd=ods[@"activityProductData"];
    ActivityProduct *ap= [[ActivityProduct alloc] init];
    ap.productName=apd[@"productName"];
    ap.picUrl1=apd[@"picUrl1"];
    ap.rushPrice=apd[@"rushPrice"];
    
    static NSString *CellIdentifier = @"shoppingCartCell1";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
        cell.activityProduct=ap;
        cell.isEdit=NO;
        [cell initEdite];
        [cell settingFrame];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath=indexPath;
        cell.delegate=self;
        cell.tableView=_tableView;
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        if (indexPath.row==0) {
            // cell.status
            //            cell.isOrder=YES;
            
            [cell initOrderViewWithOrderModel];
             [cell settingDataOrderModel:order];
        }
    }else{
        [cell.orderNum removeFromSuperview];
        [cell.status removeFromSuperview];
        if (indexPath.row==0) {
            [cell initOrderViewWithOrderModel];
            [cell settingDataOrderModel:order];
        }
    }
    
    
            [cell settingData];
    
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.01;
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
        return _tableView.rowHeight+SCREEN_HEIGHT*0.05;
    }
    return _tableView.rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 图片
    DetailPageController *thumbViewController = [[DetailPageController alloc] init];
    OrderModel *order=_orders[indexPath.section];
    NSDictionary *ods=order.orderDetails[indexPath.row];
    NSDictionary *apd=ods[@"activityProductData"];
    ActivityProduct *ap= [[ActivityProduct alloc] init];
    ap.productCode=apd[@"productCode"];
    ap.productName=apd[@"productName"];
    ap.picUrl1=apd[@"picUrl1"];
    ap.rushPrice=apd[@"rushPrice"];
    thumbViewController.product=ap;
    //back button style
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:thumbViewController animated:YES];
}

@end
