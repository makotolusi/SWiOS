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
#import "UIAlertView+Extension.h"
#import "ShoppingCartLocalDataManager.h"

@interface ShoppingCartController () <ShoppingCartCellDelegate>
{

}
@end
@implementation ShoppingCartController 


-(void)viewWillAppear:(BOOL)animated{

    
    self.pageName=@"ShoppingCartController";
        [super viewDidAppear:animated];
        if (_tableView) {
            [_tableView reloadData];
        }
        if (totalPrice) {
            totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
        }
        UIView* view= [self.view viewWithTag:111];
        if (view) {
            if (_cartModel.arOfWatchesOfCart.count!=0)
                [view removeFromSuperview];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _loadTableView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//- (void) tapGesturedDetected:(UITapGestureRecognizer *)recognizer
//
//{
//      [markView removeFromSuperview];
//    // do something
//}
- (void)_loadTableView {
    self.view.backgroundColor=[UIColor whiteColor];
    _cartModel=[ShoppingCartModel sharedInstance];
    UILabel *label1=[[UILabel alloc] init];
    label1.text=@"购物车小计";
    label1.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label1];
    UILabel *label2=[[UILabel alloc] init];
    label2.text=@"我们将在三个工作日内为您免费送货";
    label2.textColor=[UIColor lightGrayColor];
    label2.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:label2];
    //total price
    totalPrice=[[UILabel alloc] init];
    totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
    [totalPrice smallLabel];
    totalPrice.textColor=UIColorFromRGB(0x1abc9c);
    totalPrice.tag=2;

    label1.translatesAutoresizingMaskIntoConstraints=NO;
    
    label2.translatesAutoresizingMaskIntoConstraints=NO;
    
    totalPrice.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addSubview:totalPrice];
    NSDictionary *views = NSDictionaryOfVariableBindings(label1,label2,totalPrice);
    
    NSDictionary *metrics = @{@"top":[NSString stringWithFormat:@"%f",kSWTopViewHeight+5],@"padding":[NSString stringWithFormat:@"%f",SCREEN_WIDTH*0.01]};//设置一些常量
    //设置bgView与superview左右对齐
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[label1(>=100)]-[totalPrice(>=60)]-5-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[label1(20)]-2-[label2(20)]" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
    
    float payButtonHeight=SCREEN_HEIGHT/11;
        isEdit=YES;
    
    
    
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
//        [_tableView registerNib:[UINib nibWithNibName:@"ShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
        //结算
        //    UIView  *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66, SCREEN_WIDTH, 66)];
        //根据不同入口修改button坐标
        UIButton *buy;
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIViewController *con=window.rootViewController;
    bool a=YES;
    if ([con isKindOfClass:[SWMainViewController class]]) {
        SWMainViewController *mainController=(SWMainViewController*)con;
         a=mainController.tabBarView.hidden;
    }
    

        if(a){
            buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - payButtonHeight, SCREEN_WIDTH, payButtonHeight)];
            // 创建表视图
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSWTopViewHeight*1.7, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTopViewHeight*1.7-payButtonHeight)];
        }else
        {
            buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - payButtonHeight-kSWTabBarViewHeight, SCREEN_WIDTH, payButtonHeight)];
            // 创建表视图
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSWTopViewHeight*1.7, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTabBarViewHeight-kSWTopViewHeight*1.7-payButtonHeight)];
        }
   
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.backgroundColor=[UIColor blackColor];
    _tableView.rowHeight = SCREEN_HEIGHT*0.16;
    //        _tableView.contentInset = UIEdgeInsetsMake(50, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
        buy.backgroundColor = UIColorFromRGB(0x1abc9c);
        buy.alpha=0.7f;
        [buy setTitle:@"结算" forState:UIControlStateNormal];
        [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buy addTarget:self action:@selector(goBalace) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buy];



}
#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cartModel.arOfWatchesOfCart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"shoppingCartCell1";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.activityProduct=_cartModel.arOfWatchesOfCart[indexPath.row];
         cell.isEdit=YES;
        [cell initEdite];
        [cell settingFrame];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath=indexPath;
        cell.delegate=self;
        cell.tableView=_tableView;

    }else{
       cell.activityProduct=_cartModel.arOfWatchesOfCart[indexPath.row];
    }

     [cell settingData];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return 60.f;
//    }else{
//        return 110.f;
//    }
//}
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
    totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@", _cartModel.orderModel.totalPrice];
}

-(void)goBalace{
    if (_cartModel.arOfWatchesOfCart.count==0) {
        [UIAlertView showMessage:@"空空如野，快选几件放进来！"];
        return;
    }
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ActivityProduct *product= _cartModel.arOfWatchesOfCart[indexPath.row];
        
        if ([ShoppingCartModel removeCartWithProduct:product]) {
//            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView reloadData];
            // Delete the row from the data source.
            totalPrice.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
        }


    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}



@end
