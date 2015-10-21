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
#import "OrderModel.h"
static NSString *orderPriceCell = @"orderPriceCell";
static NSString *orderListCell = @"orderListCell";
@interface BalanceController ()

@end

@implementation BalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self _loadTableView];
    // Do any additional setup after loading the view.
}
-(void)initialize{
    groups=[[NSMutableArray alloc] init];
    [groups addObject:[[BalanceFieldModel alloc] init]];
     [groups addObject:[[BalanceFieldModel alloc] init]];
     [groups addObject:[[BalanceFieldModel alloc] init]];
      paymentArray=[NSArray arrayWithObjects:@"EMS",@"中通", @"顺丰",nil];
//     _cartModel=[ShoppingCartModel sharedInstance];
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
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-200, 100, 30)];
    submit.backgroundColor = UIColorFromRGB(0x1abc9c);
    submit.alpha=0.7f;
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.titleLabel.textAlignment=NSTextAlignmentCenter;
    [submit.layer setCornerRadius:7.0]; //设置矩形四个圆角半径
    [submit.titleLabel smallLabel];
//    [submit.layer setBorderWidth:1.0];
    [submit addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 30;
    }else
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[
    if(section==1)
        return [[[UILabel alloc] init] tableSectionLabel:@"收货人信息"];
    else if (section==2)
        return [[[UILabel alloc] init] tableSectionLabel:@"快递公司"];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 40.f;
    }else if (indexPath.section==1){
        return orderListCellHeight+5;
    }else if(indexPath.section==2){
        if (_addressModel!=nil)
         {
             return orderListCellHeight+20;
        }else {
            return 40.f;
         }
    } else{
        return 40.f;
    }
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
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==2){
        if (_addressModel==nil) {
            return [self editCell: @"添加收货人信息" tag:10];
        }else{
            EmptyCell *cell=[[EmptyCell alloc] init];
            AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) data:_addressModel];
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

    }else if(indexPath.section==1){
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
        [self.view addSubview:_paymentPicker];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    [self cancelLocatePicker];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField* tf=[self.view viewWithTag:11];
    tf.font=[UIFont systemFontOfSize:15];
    tf.textColor=[UIColor blackColor];
    tf.text=[paymentArray objectAtIndex:row];
}

-(void)reloadTableView{
    [_tableView reloadData];
}

- (void)checkOrder:(UIButton*)sender {
    OrderModel *om=[OrderModel new];
    [OrderRequest orderCheck:om];
    OrderViewController *vc =[[OrderViewController alloc]init];
    vc.addressModel=_addressModel;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
