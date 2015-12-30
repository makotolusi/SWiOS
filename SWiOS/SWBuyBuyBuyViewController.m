//
//  BuyBuyBuyViewController.m
//  SWiOS
//
//  Created by 李乐 on 15/8/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWBuyBuyBuyViewController.h"
#import "HttpHelper.h"
#import "Activity.h"
#import "ActivityCell.h"
#import "SWActivityProductViewController.h"
#import "SWMainViewController.h"
#import "FMDB.h"
#import "UILabel+Extension.h"
#import "RegisterModel.h"
#import "UIWindow+Extension.h"
#import "LoadingView.h"
@interface SWBuyBuyBuyViewController ()

@end

@implementation SWBuyBuyBuyViewController

- (void)viewWillAppear:(BOOL)animated{
    self.pageName=@"SWBuyBuyBuyViewController";
     UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    SWMainViewController *mainController=(SWMainViewController*)window.rootViewController;
    mainController.tabBarView.hidden=NO;
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.title;
    [HttpHelper sendGetRequest:@"getActivity"
                    parameters: @{}
                       success:^(id response) {
                           NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
                           NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                           NSLog(@"获取到的数据为dict：%@", _data);
                           // 构造数组(MRC:以下情况会出问题，ARC)
                           _data = [NSMutableArray array];
                           
                           // 设置数据模型
                           for (id content in result) {
                               Activity *model = [[Activity alloc] init];
                               [model setValue: content[@"id"] forKey:@"_id"];
                               [model setValue: content[@"activityName"] forKey:@"name"];
                               [model setValue: content[@"description"] forKey:@"des"];
                               [model setValue: content[@"rushBeginTime"] forKey:@"beginTime"];
                               [model setValue: content[@"rushEndTime"] forKey:@"endTime"];
                               [model setValue: content[@"imgUrl"] forKey:@"imageUrl"];
                               [_data addObject:model];
                           }
                               [self _loadContentView];
                           
                       } fail:^{
                              NSLog(@"网络异常，取数据异常");
                       } parentView:self.view];
    // 如果数据从网络中来，那么就需要刷新表视图
    [_tableView reloadData];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadContentView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.contentInset = UIEdgeInsetsMake(64.f, 0.f, 49.f, 0.f);
    _tableView.rowHeight = SCREEN_WIDTH/16*9+60;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *activityCellIdentifier = @"activityCellIdentifier";
    ActivityCell *cell=[tableView dequeueReusableCellWithIdentifier:activityCellIdentifier ];
//        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    if(!cell){
        cell=[[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityCellIdentifier indexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         cell.indexPath=indexPath;
    }
    
    Activity *vo=_data[indexPath.row];
    [cell updateUIWithVO:vo];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did selected!");
    // 图片
    SWActivityProductViewController *thumbViewController = [[SWActivityProductViewController alloc] init];
    //vo
    Activity *vo=_data[indexPath.row];
    thumbViewController.activity=vo;
    thumbViewController.navigationItem.titleView = [UILabel navTitleLabel:vo.name];
    //back button style
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [UIWindow showTabBar:NO];
    [self.navigationController pushViewController:thumbViewController animated:YES];
}

-(void)createDB{
//    FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
}

@end
