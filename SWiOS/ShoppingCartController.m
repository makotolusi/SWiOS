//
//  ShoppingCartController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartModel.h"
#import "BalanceController.h"
#import "SWMainViewController.h"
#import "UILabel+Extension.h"
@interface ShoppingCartController () <ShoppingCartCellDelegate>

@end
@implementation ShoppingCartController 

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self _loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)initialize{
    _cartModel=[ShoppingCartModel sharedInstance];
}

- (void)_loadTableView {
//    if (_cartModel.arOfWatchesOfCart.count==0) {
//        
//    }else{
        //    [self totalPrice];
        isEdit=NO;
        // 创建表视图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//    _tableView.backgroundColor=[UIColor blackColor];
        _tableView.rowHeight = 110;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0.f, 0.f, 0.f);
        _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
        label1.text=@"购物车小计";
        label1.font=[UIFont systemFontOfSize:13];
        [_tableView addSubview:label1];
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+20, 200, 20)];
        label2.text=@"我们将在三个工作日内为您免费送货";
        label2.textColor=[UIColor lightGrayColor];
        label2.font=[UIFont systemFontOfSize:10];
        [_tableView addSubview:label2];
        //total price
        totalPrice=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x+280, label1.frame.origin.y, 200, 20)];
        totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
        totalPrice.textColor=UIColorFromRGB(0x1abc9c);
        totalPrice.font=[UIFont fontWithName:@"STHeitiK-Light" size:13 ];
        totalPrice.tag=2;
        [_tableView addSubview:totalPrice];
        //创建编辑按钮
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 40)];
        editButton.backgroundColor = [UIColor clearColor];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitleColor:UIColorFromRGB(0x1abc9c) forState:UIControlStateNormal];
        [editButton setTitle:@"完成" forState:UIControlStateSelected];
        [editButton setTitleColor:UIColorFromRGB(0x1abc9c) forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        
        //创建edit按钮
//        UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
//        self.navigationItem.rightBarButtonItem=homeButtonItem;
        // 注册单元格（nib, code）
        [_tableView registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
        //结算
        //    UIView  *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66, SCREEN_WIDTH, 66)];
        //根据不同入口修改button坐标
        UIButton *buy;
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        SWMainViewController *mainController=(SWMainViewController*)window.rootViewController;
        bool a=mainController.tabBarView.hidden;
        if(a){
            buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        }else
        {
            buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50-66, SCREEN_WIDTH, 50)];
        }
        buy.backgroundColor = UIColorFromRGB(0x1abc9c);
        buy.alpha=0.7f;
        [buy setTitle:@"结算" forState:UIControlStateNormal];
        [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buy addTarget:self action:@selector(goBalace) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buy];
//    }
}
#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cartModel.arOfWatchesOfCart count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    if(indexPath.row!=0){
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isEdit=YES;
        cell.indexPath=indexPath;
        cell.delegate=self;
     cell.activityProduct=_cartModel.arOfWatchesOfCart[indexPath.row-1];
        cell.tableView=_tableView;
    // 3 将单元格添加在tableView上
    return cell;
    }else{
        EmptyCell *em=[[EmptyCell alloc] init] ;
        return em;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 60.f;
    }else{
        return 110.f;
    }
}
//- (void)edit:(UIButton*)sender {
//    if (sender.selected) {
//        isEdit=NO;
//        sender.selected=NO;
//    }else{
//        isEdit=YES;
//        sender.selected=YES;
//    }
//    [_tableView reloadData];
//}

-(void)totalPrice{
    for (ActivityProduct *product in _cartModel.arOfWatchesOfCart) {
        NSDecimalNumber *a1=[[NSDecimalNumber alloc] initWithDecimal:_cartModel.orderModel.totalPrice.decimalValue];
        NSDecimalNumber *a2=[[NSDecimalNumber alloc] initWithDecimal:product.rushPrice.decimalValue];
        NSDecimalNumber *sum= [a1 decimalNumberByAdding:a2];
        _cartModel.orderModel.totalPrice= sum;
    }
}

- (void)totalPrice:(ActivityProduct*)activityProduct type:(int)type{
    NSDecimalNumber *sum;
    if (type==0) {
        NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:_cartModel.orderModel.totalPrice.stringValue];
        NSDecimalNumber *t2=[NSDecimalNumber decimalNumberWithString:activityProduct.rushPrice.stringValue];
        sum=[t1 decimalNumberByAdding: t2];
    }else{
        NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:_cartModel.orderModel.totalPrice.stringValue];
        NSDecimalNumber *t2=[NSDecimalNumber decimalNumberWithString:activityProduct.rushPrice.stringValue];
        sum=[t1 decimalNumberBySubtracting: t2];
    }
    _cartModel.orderModel.totalPrice=sum;
    totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@", _cartModel.orderModel.totalPrice];
}

-(void)goBalace{
    BalanceController *balance=[[BalanceController alloc] init];
    balance.navigationItem.titleView=[UILabel  navTitleLabel:@"陆思的订单"];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:balance animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSIndexPath *ip=[[NSIndexPath alloc] initWithIndex:indexPath.row-1];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ActivityProduct *product= _cartModel.arOfWatchesOfCart[indexPath.row-1];
        NSDecimalNumber *t1=[NSDecimalNumber decimalNumberWithString:_cartModel.orderModel.totalPrice.stringValue];
        NSDecimalNumber *t2=[NSDecimalNumber decimalNumberWithString:product.rushPrice.stringValue];
        NSDecimalNumber *sum=[t1 decimalNumberBySubtracting: t2];
        _cartModel.orderModel.totalPrice=sum;
        _cartModel.orderModel.totalCount=_cartModel.orderModel.totalCount-1;
        [_cartModel.arOfWatchesOfCart removeObjectAtIndex:indexPath.row-1];
        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
