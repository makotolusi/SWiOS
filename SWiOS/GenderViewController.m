//
//  GenderViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/11/6.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "GenderViewController.h"
#import "EmptyCell.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
#import "SWMeTableViewController.h"
@interface GenderViewController ()
@property(nonatomic,strong)NSIndexPath* lastPath;

//@property(nonatomic,assign)NSInteger defautPath;

//@property(nonatomic,copy)NSString* gender;


@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(backRoot:)]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorColor=[UIColor clearColor];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)backRoot:(id)sender{
    int i=_lastPath.row;
    NSLog(@"index %d",i);
//    [HttpHelper sendGetRequest:@"CommerceUserServices/updateGender"
//                           parameters: @{@"gender":[NSString stringWithFormat:@"%d",i]}
//                              success:^(id response) {
//                                  NSDictionary* result=[response jsonString2Dictionary];
//                                  BOOL success=[result valueForKey:@"success"];
//                                  if(success){
//                                      UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:_lastPath];
//                                      _gender=currentCell.textLabel.text;
//                                    [self.navigationController popViewControllerAnimated:YES ];
//
//                                      if ([_delegate respondsToSelector:@selector(updateGenderView:)]) { // 如果协议响应了sendValue:方法
//                                          [_delegate updateGenderView:_gender]; // 通知执行协议方法
//                                      }
//                                  }
//                              }fail:^{
//                                  NSLog(@"网络异常，取数据异常");
//                              } parentView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"reuseIdentifier";
    
    EmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[EmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"男";
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"女";
    }
    if (indexPath.row==_defautPath) {
        _lastPath=indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_lastPath == indexPath) {
        return;
    }
    //lastPath在cell for row中 加载时当前indexpath，本函数中indexaPath为选中的path
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
//    _gender=currentCell.textLabel.text;
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    _lastPath = indexPath;
    currentCell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中的背景风格
//    [self.navigationController popViewControllerAnimated:YES];
//    NSArray *views=self.navigationController.viewControllers;
//    for (UIViewController *view in views) {
//        if ([view isKindOfClass:[BalanceController class]]) {
//            BalanceController *alv=view;
//            alv.addressModel=dataObject;
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            [alv reloadTableView];
//        }
//    }
    
}


@end
