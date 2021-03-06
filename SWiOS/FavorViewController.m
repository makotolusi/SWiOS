//
//  FavorViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/11/30.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "FavorViewController.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
#import "ActivityProduct.h"
#import "ShoppingCartCell.h"
#import "DetailPageController.h"
#import "MJRefresh.h"
@interface FavorViewController ()

@end

@implementation FavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cartModel=[ShoppingCartModel sharedInstance];
    _currentPageNum=1;
    _data=[NSMutableArray array];
     [self loadTable];
}

-(void)loadDataWithPageNum:(NSString*)pageNum{
    [HttpHelper sendPostRequest:@"CommerceUserServices/listFavor"
                     parameters: @{@"pageNum": pageNum,@"userId":[NSString stringWithFormat:@"%d",_cartModel.registerModel.id]}
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                NSArray* data=result[@"data"];
                                if ([data count]==0) {
                                    _currentPageNum--;
                                }
                                for (id content in data) {
                                    ActivityProduct *product=[[ActivityProduct alloc] init];
                                    product.productCode=content[@"productCode"];
                                    product.productName=content[@"name"];
                                    product.picUrl1=content[@"picUrl1"];
                                    product.rushPrice=content[@"price"];
                                    [_data addObject:product];
                                }
                                [_tableView reloadData];
                                 [_tableView footerEndRefreshing];
                            }
                        }fail:^{
                            NSLog(@"网络异常，取数据异常");
                        }];
}

-(void)reload{
    [HttpHelper sendPostRequest:@"CommerceUserServices/listFavor"
                     parameters: @{@"pageNum": @"1",@"userId":[NSString stringWithFormat:@"%d",_cartModel.registerModel.id]}
                        success:^(id response) {
                            [_data removeAllObjects];
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                NSArray* data=result[@"data"];
                                for (id content in data) {
                                    ActivityProduct *product=[[ActivityProduct alloc] init];
                                    product.productCode=content[@"productCode"];
                                    product.productName=content[@"name"];
                                    product.picUrl1=content[@"picUrl1"];
                                    product.rushPrice=content[@"price"];
                                    [_data addObject:product];
                                }
                                [_tableView reloadData];
                                 [_tableView headerEndRefreshing];
                                _currentPageNum=1;
                            }
                        }fail:^{
                            NSLog(@"网络异常，取数据异常");
                        }];
}

-(void)loadTable{

    float x=self.view.frame.origin.y;
    NSLog(@"x is %f",x);
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTabBarViewHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = SCREEN_HEIGHT*0.15;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [_tableView addHeaderWithCallback:^{
        [self reload];
       
    }];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:_tableView];
}

- (void)footerRereshing{
    _currentPageNum++;
    [self loadDataWithPageNum:[NSString stringWithFormat:@"%ld",_currentPageNum]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"shoppingCartCell1";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     ActivityProduct *ap= _data[indexPath.row];
    if (!cell) {
        cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.activityProduct=ap;
        cell.isEdit=NO;
        [cell initEdite];
        [cell settingFrame];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath=indexPath;
        cell.delegate=self;
        cell.tableView=_tableView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }else{
         cell.activityProduct=ap;

    }
    [cell settingData];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return _tableView.rowHeight+40;
//    }
//    return _tableView.rowHeight;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 图片
    DetailPageController *thumbViewController = [[DetailPageController alloc] init];
    ActivityProduct *product=_data[indexPath.row];
    thumbViewController.product=product;
    //back button style
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:thumbViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
