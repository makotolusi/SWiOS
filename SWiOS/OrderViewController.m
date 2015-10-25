


//
//  OrderViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderViewController.h"
#import "UILabel+Extension.h"
#import "EmptyCell.h"
#import "OrderTopView.h"
#import "AddressView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LUAliPay.h"
#define kOffsetHeight 60.f
@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadTableView];
}

- (void)_loadTableView {
    UILabel *navTitle=[[UILabel alloc] init];
    self.navigationItem.titleView=[navTitle changeNavTitleByFontSize:@"选择收货地址"];
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewStyleGrouped;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(kOffsetHeight, 0.f, 0.f, 0.f);
//    // 注册单元格（nib, code）
//    [_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:orderPriceCell];
//    [_tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:orderListCell];
    [self.view addSubview:_tableView];
    //submit
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-100, 100, 30)];
    submit.backgroundColor = UIColorFromRGB(0x1abc9c);
    submit.alpha=0.7f;
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"付款" forState:UIControlStateNormal];
    submit.titleLabel.textAlignment=NSTextAlignmentCenter;
    [submit.layer setCornerRadius:7.0]; //设置矩形四个圆角半径
    [submit.titleLabel smallLabel];
    //    [submit.layer setBorderWidth:1.0];
    [submit addTarget:self action:@selector(alipay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    //top view
    OrderTopView *view=[[OrderTopView alloc] initWithFrame:CGRectMake(0, -kOffsetHeight, SCREEN_WIDTH, kOffsetHeight)];
    view.backgroundColor=[UIColor darkGrayColor];
    view.alpha=0.7f;
    [_tableView addSubview:view];
    //bottom view
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-250, 30, 30)];
    imgView.image=[UIImage imageNamed:@"order"];
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50,  SCREEN_HEIGHT-250, 200, 20)];
    [label1 smallLabel];
    NSString *label1Str=@"请在 30 分钟内完成支付";
    label1.text=label1Str;
    label1.textColor=[UIColor lightGrayColor];
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40,  SCREEN_HEIGHT-230, 150, 20)];
    label2.text=@"逾期订单将自动取消";
    [label2 smallLabel];
    label2.textColor=[UIColor lightGrayColor];
    [self.view addSubview:imgView];
    [self.view addSubview:label1];
    [self.view addSubview:label2];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else {
        return 40.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1)
        return 2;
    else
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    UIView *view=[
    if(section==0)
        return [[[UILabel alloc] init] tableSectionLabel:@"收货人信息" y:20];
    else if (section==1)
        return [[[UILabel alloc] init] tableSectionLabel:@"确认支付方式" y:20];
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section==0){
        cell =[[EmptyCell alloc] init];
        AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(50, 0, 20, 20) data:self.addressModel];
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship"]];
                          img.frame=CGRectMake(10, 20, 30, 30);
        img.alpha=0.7f;
        [cell addSubview:img];
        [cell addSubview:addressView];
        return cell;
    }else if(indexPath.section==1){
            NSLog(@"indexPath.row %ld",indexPath.row);
        cell =[[EmptyCell alloc] init];
        NSString *imgName;
        NSString *labelText;
        if(indexPath.row==0){
            imgName=@"zhifubao";
            labelText=@"支付宝";
        }else if(indexPath.row==1){
            imgName=@"weixin";
            labelText=@"微信支付(推荐)";
        }
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        img.frame=CGRectMake(10, 10, 20, 20);
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
        lab.text=labelText;
        lab.textColor=[UIColor lightGrayColor];
        [lab smallLabel];
        [cell addSubview:lab];
        [cell addSubview:img];
    }else
        cell=[[EmptyCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)alipay{
    [LUAliPay alipay];
}

@end
