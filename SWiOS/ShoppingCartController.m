//
//  ShoppingCartController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartCell.h"

@interface ShoppingCartController () <ShoppingCartCellDelegate>

@end
@implementation ShoppingCartController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadTableView {
    [self totalPrice];
    isEdit=NO;
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    _tableView.contentInset = UIEdgeInsetsMake(-50, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 100, 20)];
    label1.text=@"购物车小计";
    label1.font=[UIFont systemFontOfSize:13];
    [_tableView addSubview:label1];
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+20, 200, 20)];
    label2.text=@"我们将在三个工作日内为您免费送货";
    label2.textColor=[UIColor lightGrayColor];
    label2.font=[UIFont systemFontOfSize:10];
    [_tableView addSubview:label2];
    //total price
    totalPrice=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x+300, label1.frame.origin.y, 200, 20)];
    totalPrice.text=[@"¥ " stringByAppendingFormat:@"%d",sumPrice];
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
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem=homeButtonItem;
    // 注册单元格（nib, code）
     [_tableView registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
    //结算
//    UIView  *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66, SCREEN_WIDTH, 66)];
  
    UIButton *buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    buy.backgroundColor = UIColorFromRGB(0x1abc9c);
    buy.alpha=0.7f;
    [buy setTitle:@"结算" forState:UIControlStateNormal];
    [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buy];
}
#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arOfWatchesOfCart count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row!=0){
    // 1 如果有没有重用，创建新单元格；如果有重用，用复用的单元格
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isEdit=isEdit;
    cell.activityProduct = _arOfWatchesOfCart[indexPath.row-1];
        cell.count=1;
        cell.delegate=self;
    // 3 将单元格添加在tableView上
    return cell;
    }else
        return [[EmptyCell alloc] init];
}
- (void)edit:(UIButton*)sender {
    if (sender.selected) {
        isEdit=NO;
        sender.selected=NO;
    }else{
        isEdit=YES;
        sender.selected=YES;
    }
    [_tableView reloadData];
}

-(void)totalPrice{
    for (ActivityProduct *product in _arOfWatchesOfCart) {
        sumPrice+=product.rushPrice.intValue;
    }
}

- (void)totalPrice:(int)singlePrice{
    sumPrice=sumPrice+singlePrice;
    totalPrice.text=[@"¥ " stringByAppendingFormat:@"%d",sumPrice];
}
@end
