//
//  AddresListViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/19.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListCell.h"
#import "DatabaseManager.h"
#import "AddressModel.h"
#import "AddressViewController.h"
#import "UILabel+Extension.h"
#import "BalanceController.h"
#import "AddressView.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
static NSString *cellIdentifier = @"Cell";

@interface AddressListViewController ()
{
NSMutableArray *_testArray;
}


@end

@implementation AddressListViewController

-(void)initializeData{
    DatabaseManager *db=[DatabaseManager sharedDatabaseManager];
    _testArray=[db.getAllAddress mutableCopy];
    _cartModel=[ShoppingCartModel sharedInstance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     _tableView.separatorColor=[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    UILabel *navTitle=[[UILabel alloc] init];
    self.navigationItem.titleView=self.navigationItem.titleView=[UILabel  navTitleLabel:@"选择收货地址"];

    //创建编辑按钮
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, 40)];
    editButton.backgroundColor = [UIColor clearColor];
    [editButton setTitle:@"新增地址" forState:UIControlStateNormal];
    [ editButton.titleLabel smallLabel];
    [editButton setTitleColor:UIColorFromRGB(0x1abc9c) forState:UIControlStateNormal];
    editButton.titleLabel.textAlignment=NSTextAlignmentRight;
    [editButton addTarget:self action:@selector(newAddress:) forControlEvents:UIControlEventTouchUpInside];
    //创建edit按钮
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -30;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, homeButtonItem, nil];

//    self.navigationItem.rightBarButtonItem=homeButtonItem;
   
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _testArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_lastPath == indexPath) {
        return;
    }
    //lastPath在cell for row中 加载时当前indexpath，本函数中indexaPath为选中的path
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    _lastPath = indexPath;
    currentCell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中的背景风格
    
    NSLog(@"cell selected at index path %ld", (long)indexPath.row);
     AddressModel *dataObject = _testArray[indexPath.row];
    NSString* addressInfo=[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%ld",dataObject.name,dataObject.phone,dataObject.code,dataObject.city,dataObject.address,indexPath.row];
    
    [HttpHelper sendPostRequest:@"CommerceUserServices/updateAddress" parameters:@{@"address":addressInfo} success:^(id response) {
        NSDictionary* result=[response jsonString2Dictionary];
        BOOL success=[result valueForKey:@"success"];
        if(success){
            //next
            _cartModel.addressModel=dataObject;
            NSArray *views=self.navigationController.viewControllers;
            for (UIViewController *view in views) {
                if ([view isKindOfClass:[BalanceController class]]) {
                    BalanceController *alv=view;
                    alv.addressModel=dataObject;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [alv reloadTableView];
                }
            }
            
        }
    } fail:^{
        NSLog(@"网络异常，取数据异常");
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressListCell *cell = (AddressListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        //        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        //        [leftUtilityButtons addUtilityButtonWithColor:
        //         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
        //                                                 icon:[UIImage imageNamed:@"check.png"]];
        //        [leftUtilityButtons addUtilityButtonWithColor:
        //         [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
        //                                                 icon:[UIImage imageNamed:@"clock.png"]];
        //        [leftUtilityButtons addUtilityButtonWithColor:
        //         [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
        //                                                 icon:[UIImage imageNamed:@"cross.png"]];
        //        [leftUtilityButtons addUtilityButtonWithColor:
        //         [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
        //                                                 icon:[UIImage imageNamed:@"list.png"]];
        //image
        UIImage *img=[UIImage imageNamed:@"trash2"];
    
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor whiteColor] icon:[UIImage imageNamed:@"edit"]];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor whiteColor] icon:img];
        
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;

        if (indexPath.row==_lastPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    AddressModel *dateObject = _testArray[indexPath.row];
    AddressView *addressView=[[AddressView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) data:dateObject];
    [cell addSubview:addressView];
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(AddressListCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swippableTableViewCell:(AddressListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            self.navigationItem.title=@"收货人信息";
            //back button style
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
            self.navigationItem.backBarButtonItem = cancelButton;
            AddressViewController *av=[[AddressViewController  alloc] init];
            AddressModel *add=_testArray[cellIndexPath.row];
            av.addressId=add.AddressModelID;
            [self.navigationController pushViewController:av animated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            AddressModel *add=_testArray[cellIndexPath.row];
            DatabaseManager *db=[DatabaseManager sharedDatabaseManager];
            if ([db deleteAddressByID:add.AddressModelID]) {
                [_testArray removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)newAddress:(UIButton*)sender {
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

-(void)reloadTableView{
    [self initializeData];
    [self.tableView reloadData];
}

@end
