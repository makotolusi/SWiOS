//
//  AddressListViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/18.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListCell.h"
@interface AddressListViewController ()

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadTableView];
    // Do any additional setup after loading the view.
}


- (void)_loadTableView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    // 注册单元格（nib, code）
    [_tableView registerNib:[UINib nibWithNibName:@"AddressListCell" bundle:nil] forCellReuseIdentifier:@"addressListCell"];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;//_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
