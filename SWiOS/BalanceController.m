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
static NSString *orderPriceCell = @"orderPriceCell";
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
}

- (void)_loadTableView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.rowHeight = 110;
//    _tableView.contentInset = UIEdgeInsetsMake(-50, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewStyleGrouped;
    _tableView.separatorColor=[UIColor clearColor];
    // 注册单元格（nib, code）
    [_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:orderPriceCell];
    [self.view addSubview:_tableView];
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
    if(section==1)
    return [self titleLabel:@"收货人信息"];
    else if (section==2)
        return [self titleLabel:@"快递公司"];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 40.f;
    }else if (indexPath.section==1){
        return 80.f;
    }else
    return 40.f;
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
        return [[EmptyCell alloc] init];
    }else if(indexPath.section==2){
       return [self editCell: @"添加收货人信息"];
    }else if(indexPath.section==3)
    {
        return [self editCell:@"快递公司"];
    }else
        return [[EmptyCell alloc] init];
}
-(UITableViewCell*)editCell:(NSString*)text{
    EmptyCell* cell = [[EmptyCell alloc] init];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(6, 10, 200, 20)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    label.textColor=[UIColor lightGrayColor];
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    [cell addSubview:label];
    return cell;

}
-(UILabel*)titleLabel:(NSString*)text{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(6, 10, 200, 20)];
    label.textColor=[UIColor darkGrayColor];
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    return label;
}
@end
