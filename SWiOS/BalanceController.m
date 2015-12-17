//
//  BalanceController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/12.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "BalanceController.h"
#import "BalanceFieldModel.h"
#import "OrderPriceCell.h"
#import "OrderListCell.h"
#import "AddressListViewController.h"
#import "AddressView.h"
#import "AddressViewController.h"
#import "UILabel+Extension.h"
#import "OrderViewController.h"
#import "OrderRequest.h"
#import "ShoppingCartModel.h"
#import "LoadingView.h"
#import "UIAlertView+Extension.h"
#import "OrderItemViewController.h"
#import "SWMainViewController.h"
#import "NSString+Extension.h"
static NSString *orderPriceCell = @"orderPriceCell";
static NSString *orderListCell = @"orderListCell";
@interface BalanceController ()

@property(nonatomic,assign)NSInteger defautPath;


@end

@implementation BalanceController


-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"edge : %@", NSStringFromUIEdgeInsets(_tableView.contentInset));
   
//    NSLog(@"edge : %@", NSStringFromUIEdgeInsets(_tableView.contentInset));
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
    groups=[[NSMutableArray alloc] init];
    [groups addObject:[[BalanceFieldModel alloc] init]];
     [groups addObject:[[BalanceFieldModel alloc] init]];
     [groups addObject:[[BalanceFieldModel alloc] init]];
      paymentArray=[NSArray arrayWithObjects:@"EMS",@"中通", @"顺丰",nil];
     _cartModel=[ShoppingCartModel sharedInstance];
    
//    if (!StringIsNullOrEmpty(_cartModel.registerModel.addr)) {
//        
//        NSArray *aTest = [_cartModel.registerModel.addr componentsSeparatedByString:@";"];
//        _cartModel.addressModel.name=aTest[0];
//        _cartModel.addressModel.phone=aTest[1];
//        _cartModel.addressModel.code=aTest[2];
//        _cartModel.addressModel.city=aTest[3];
//        _cartModel.addressModel.address=aTest[4];
//    }
    _cartModel.route=@"BalanceController";
}

- (void)_loadTableView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewStyleGrouped;
    _tableView.separatorColor=[UIColor clearColor];
    // 注册单元格（nib, code）
    [_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:orderPriceCell];
     [_tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:orderListCell];
    [self.view addSubview:_tableView];
    //快递公司
    _paymentPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 100)];
    _paymentPicker.dataSource=self;
    _paymentPicker.delegate=self;

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
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [submit.layer setCornerRadius:7.0]; //设置矩形四个圆角半径
    [submit.titleLabel smallLabel];
//    [submit.layer setBorderWidth:1.0];
    [submit addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)]; // 手势类型随你喜欢。
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return SCREEN_HEIGHT*0.04;
    }else
    return SCREEN_HEIGHT*0.05;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[
    if(section==1)
        return [[[UILabel alloc] init] tableSectionLabel:@"收货人信息" y:SCREEN_HEIGHT*0.05-20];
    else if (section==2)
        return [[[UILabel alloc] init] tableSectionLabel:@"快递公司" y:SCREEN_HEIGHT*0.05-20];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        return SCREEN_HEIGHT*0.12;
    }
    if(indexPath.section==2){
        if (_cartModel.addressModel.name!=nil)
        {
            return SCREEN_HEIGHT*0.15;
        }else
            return SCREEN_HEIGHT*0.06;
    }else
        return SCREEN_HEIGHT*0.06;
}

#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        OrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:orderPriceCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==1){
        OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:orderListCell forIndexPath:indexPath];
//         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==2){
       
        if (_cartModel.addressModel.name==nil) {
            return [self editCell: @"添加收货人信息" tag:10];
        }else{
            EmptyCell *cell=[[EmptyCell alloc] init];
            AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, SCREEN_WIDTH, cell.frame.size.height) data:_cartModel.addressModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:addressView];
            return cell;
        }
    }else if(indexPath.section==3)
    {
        return [self editCell:@"快递公司" tag:11];
    }else
        return [[EmptyCell alloc] init];
}


-(UITableViewCell*)editCell:(NSString*)text tag:(NSInteger*)tag{
    EmptyCell* cell = [[EmptyCell alloc] init];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(6, 10, 200, 20)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    label.textColor=[UIColor lightGrayColor];
    label.text=text;
    label.tag=tag;
    label.font=[UIFont systemFontOfSize:13];
    [cell addSubview:label];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
         [_paymentPicker removeFromSuperview];
    }else if(indexPath.section==1){
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        OrderItemViewController *av=[[OrderItemViewController  alloc] init];
        [self.navigationController pushViewController:av animated:YES];

    }else if(indexPath.section==2){
        DatabaseManager *db=[DatabaseManager sharedDatabaseManager];
       NSArray *array=db.getAllAddress;
        if (array.count>0) {
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
            self.navigationItem.backBarButtonItem = cancelButton;
            AddressListViewController *av=[[AddressListViewController  alloc] init];
            int row=0;
            if (!StringIsNullOrEmpty(_cartModel.registerModel.addr)) {
                
                NSArray *aTest = [_cartModel.registerModel.addr componentsSeparatedByString:@";"];
                row=[aTest[5] intValue];
            }
            NSIndexPath* index=[NSIndexPath indexPathForRow:row inSection:0];
            av.lastPath=index;
            [self.navigationController pushViewController:av animated:YES];
        }else{
        self.navigationItem.title=@"收货人信息";
        //back button style
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        AddressViewController *av=[[AddressViewController  alloc] init];
        [self.navigationController pushViewController:av animated:YES];
        }
    }else if(indexPath.section==3)
    {
        [self.view  addSubview:_paymentPicker];
    }
}

//picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return paymentArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [paymentArray objectAtIndex:row];
}


- (void)tapGesturedDetected:(UITapGestureRecognizer *)recognizer
{
   [_paymentPicker removeFromSuperview];
    
    // do something
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel* tf=[self.view viewWithTag:11];
    tf.font=[UIFont systemFontOfSize:15];
    tf.textColor=[UIColor blackColor];
    tf.text=[paymentArray objectAtIndex:row];
}

-(void)reloadTableView{
    [_tableView reloadData];
}

- (void)checkOrder:(UIButton*)sender {
    UILabel* tf=[self.view viewWithTag:11];
    UIAlertView *alert=[[UIAlertView alloc] init];
    if (_cartModel.addressModel==nil)//alert
    {
        [UIAlertView showMessage:@"收货人信息是必须填写的哦！"];
    }else if([tf.text isEqualToString:@"快递公司"]){
        [UIAlertView showMessage:@"快递公司是必须填写的哦！"];
    }else{
        [LoadingView initWithFrame:CGRectMake(0, 0, 100, 80) parentView:self.view];
        [OrderRequest orderCheck:^(){
            [LoadingView stopAnimating:self.view];
            OrderViewController *vc =[[OrderViewController alloc]init];
            vc.addressModel=_addressModel;
//            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
//                                             initWithTitle:@"lui"
//                                             style:UIBarButtonItemStylePlain
//                                             target:self
//                                             action:@selector(getOrderModel)];
//            self.navigationItem.backBarButtonItem = cancelButton;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

//-(void)cancel:(id)sender{
//
//    UIAlertView *button=[[UIAlertView alloc] initWithTitle:@"确认取消订单？" message:@"xxxxxx" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"取消订单", nil];
//    [button show];
//}
//
//-(void)getOrderModel{
//    NSLog(@"");
//    
//   
////    orderModel.totalPrice=[NSNumber numberWithInteger:15677];
////    orderModel.totalCount=[NSNumber numberWithInteger:50];
////    OrderDetailModel *od=[[OrderDetailModel alloc] init];
////    od.activityId=[NSNumber numberWithInteger:22];
////    od.productCode=@"232342";
////    od.count=[NSNumber numberWithInteger:1];
////    od.price=[NSNumber numberWithInteger:1000];
//   
//}

@end
