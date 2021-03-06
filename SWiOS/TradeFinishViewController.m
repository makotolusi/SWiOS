
//
//  TradeFinishViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/27.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "TradeFinishViewController.h"
#import "EmptyCell.h"
#import "UILabel+Extension.h"
#import "AddressView.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartCell.h"
#import "UILabel+Extension.h"
#import "MyOrderController.h"
#import "UIWindow+Extension.h"
@interface TradeFinishViewController ()

@end

@implementation TradeFinishViewController

-(void)viewWillAppear:(BOOL)animated{
    self.pageName=@"TradeFinishViewController";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"我的订单" style:UIBarButtonItemStyleDone target:self action:@selector(myorder:)]];
    self.navigationItem.hidesBackButton = YES;
     [UIWindow showTabBar:YES];
    _cartModel=[ShoppingCartModel sharedInstance];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTabBarViewHeight) ];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight=100;
    _tableView.separatorStyle=UITableViewStyleGrouped;
    _tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
}

-(void)myorder:(id)sender{
    MyOrderController* uiNavigationController = [[MyOrderController alloc] init];
    uiNavigationController.prePage=@"TradeFinishViewController";
    uiNavigationController.navigationItem.titleView = [UILabel navTitleLabel:@"我的订单"];
    [UIWindow showTabBar:YES];
    [self.navigationController pushViewController:uiNavigationController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else
    if (section==1) {
        return _cartModel.arOfWatchesOfCart.count;
    }else
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartModel *cartModel=[ShoppingCartModel sharedInstance];
    UITableViewCell *cell;
    if(indexPath.section==0){
        if (indexPath.row==0) {
            cell=[[EmptyCell alloc] init];
            UIView *sucView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
            sucView.backgroundColor=UIColorFromRGB(0x1abc9c);
            [self.view addSubview:sucView];
            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(40, sucView.frame.size.height/2-10, 200, 20)];
            label1.text=@"买家已付款";
            [label1 midLabel];
            label1.textColor=[UIColor whiteColor];
            UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift"]];
            imgView.frame=CGRectMake(SCREEN_WIDTH/2+50, label1.frame.origin.y-15, 50, 50);
            [sucView addSubview:label1];
            [sucView addSubview:imgView];
            [cell addSubview:sucView];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }else{
            cell =[[EmptyCell alloc] init];
            AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH, cell.frame.size.height) data:cartModel.addressModel];
            UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dizhi"]];
            img.frame=CGRectMake(10, 20, 30, 30);
            img.alpha=0.7f;
            [cell addSubview:img];
            [cell addSubview:addressView];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
      
    }else if(indexPath.section==1)
    {
        
        static NSString *CellIdentifier = @"shoppingCartCell1";
        ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.activityProduct=_cartModel.arOfWatchesOfCart[indexPath.row];
            cell.isEdit=NO;
            [cell initEdite];
            [cell settingFrame];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath=indexPath;
            cell.delegate=self;
            cell.tableView=_tableView;
        }else{
            
        }
        
        [cell settingData];
        
        return cell;
    }else{
        cell=[[EmptyCell alloc] init];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 20)];
        [label1 smallLabel];
        label1.text=@"运费";
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+15, 200, 20)];
        [label2 midLabel];
        label2.text=@"实付款(含运费)";
        UILabel *price2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.2, label1.frame.origin.y+15, 200, 20)];
        [price2 midLabel];
        price2.textColor=[UIColor orangeColor];
        price2.text=[@"¥ " stringByAppendingString:_cartModel.orderModel.totalPrice.stringValue];
        UILabel *price1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.2, label1.frame.origin.y, 200, 20)];
        [price1 midLabel];
        price1.text=@"¥ 0";
        [cell addSubview:label1];
        [cell addSubview:label2];
        [cell addSubview:price2];
        [cell addSubview:price1];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=2) {
         return 10.f;
    }else
        return 0.f;
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section %ld",indexPath.section);
    if (indexPath.section==2) {
        return 60.f;
    }else
    if (indexPath.section==0&&indexPath.row==0) {
        return 120.f;
    } else{
        return _tableView.rowHeight;
    }
}


@end
