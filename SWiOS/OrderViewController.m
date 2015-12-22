


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
#import "TradeFinishViewController.h"
#import "SWMainViewController.h"
#import "HttpHelper.h"
#import "OrderRequest.h"
#import "MyOrderController.h"
#import "UIWindow+Extension.h"
#define kOffsetHeight (SCREEN_HEIGHT*0.1)
@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消订单" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)]];
    self.navigationItem.hidesBackButton = YES;
    [self _loadTableView];
}
-(void)cancel:(id)sender{

    UIAlertView *button=[[UIAlertView alloc] initWithTitle:@"确认取消订单？" message:@"" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"取消订单", nil];
    [button show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [OrderRequest orderCancel:self.view next:^{
//            [self.navigationController popViewControllerAnimated:YES];
            MyOrderController* uiNavigationController = [[MyOrderController alloc] init];
            uiNavigationController.prePage=@"OrderViewController";
            uiNavigationController.navigationItem.titleView = [UILabel navTitleLabel:@"我的订单"];
//            [UIWindow showTabBar:YES];
            [self.navigationController pushViewController:uiNavigationController animated:YES];
        }];
        
    }
}

- (void)_loadTableView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSWHeadBarViewHeight) style:UITableViewStyleGrouped];
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
    UIButton *submit;
     UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    SWMainViewController *mainController=(SWMainViewController*)window.rootViewController;
    bool a=mainController.tabBarView.hidden;

    if(a){
        submit=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSWButtonWidth, SCREEN_WIDTH, kSWButtonWidth)];
    }else
    {
        submit=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSWButtonWidth-kSWTabBarViewHeight, SCREEN_WIDTH, kSWButtonWidth)];
    }
    submit.backgroundColor = UIColorFromRGB(0x1abc9c);
    submit.alpha=0.7f;
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"付款" forState:UIControlStateNormal];
    submit.titleLabel.textAlignment=NSTextAlignmentCenter;
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
    UIImageView *imgView=[[UIImageView alloc] init];
    imgView.image=[UIImage imageNamed:@"order"];
    UILabel *label1 =[[UILabel alloc] init];
    [label1 smallLabel];
    label1.textAlignment=NSTextAlignmentCenter;
    NSString *label1Str=@"请在 30 分钟内完成支付";
    label1.text=label1Str;
    label1.textColor=[UIColor lightGrayColor];
    UILabel *label2=[[UILabel alloc] init];
    label2.text=@"逾期订单将自动取消";
       label2.textAlignment=NSTextAlignmentCenter;
    [label2 smallLabel];
    label2.textColor=[UIColor lightGrayColor];
    [self.view addSubview:imgView];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    imgView.translatesAutoresizingMaskIntoConstraints=NO;
    label1.translatesAutoresizingMaskIntoConstraints=NO;
    label2.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(imgView,label1,label2);
    
    
    NSDictionary *metrics = @{@"imgWidth":[[NSNumber alloc] initWithFloat:SCREEN_HEIGHT*0.07].stringValue,
                              @"imgToBottom":[[NSNumber alloc] initWithFloat:SCREEN_HEIGHT*0.25].stringValue,
                              @"padding":[[NSNumber alloc] initWithFloat:SCREEN_WIDTH*0.05].stringValue,
                              @"img2Label":[[NSNumber alloc] initWithFloat:SCREEN_WIDTH*0.35].stringValue,
                               @"label2Label":[[NSNumber alloc] initWithFloat:SCREEN_WIDTH*0.05].stringValue
                              };//设置一些常量
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[label1(>=100)]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[imgView(imgWidth)]-[label1(>=100)]" options:NSLayoutFormatAlignAllFirstBaseline metrics:metrics views:views]];
    
  
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imgView(imgWidth)]-imgToBottom-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label1(20)]-5-[label2(20)]-imgToBottom-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return SCREEN_HEIGHT*0.15;
    }else {
        return SCREEN_HEIGHT*0.06;
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
        return [[[UILabel alloc] init] tableSectionLabel:@"收货人信息" y:10];
    else if (section==1)
        return [[[UILabel alloc] init] tableSectionLabel:@"确认支付方式" y:10];
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section==0){
        cell =[[EmptyCell alloc] init];
        ShoppingCartModel *ca=[ShoppingCartModel sharedInstance];
        AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(50, 0, 20, 20) data:ca.addressModel];
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dizhi64"]];
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
            imgName=@"zhifubao64";
            labelText=@"支付宝";
        }else if(indexPath.row==1){
            imgName=@"weixin64";
            labelText=@"微信支付(推荐)";
        }
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        img.frame=CGRectMake(10, 10, 20, 20);
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 20)];
        lab.text=labelText;
        lab.textColor=[UIColor lightGrayColor];
        [lab smallLabel];
        [cell addSubview:lab];
        [cell addSubview:img];
    }else
        cell=[[EmptyCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)alipay{

//
    [LUAliPay alipay:^(NSDictionary *resultDic){
       int statusCode=((NSString*)resultDic[@"resultStatus"]).intValue;
        if (statusCode==9000) {
            TradeFinishViewController *vc =[[TradeFinishViewController alloc]init];
            vc.navigationItem.titleView = [UILabel navTitleLabel:@"订单详情"];
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
            self.navigationItem.backBarButtonItem = cancelButton;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}

@end
