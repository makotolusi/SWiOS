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
@interface AddressListViewController ()
{
NSMutableArray *_testArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DatabaseManager *db=[DatabaseManager sharedDatabaseManager];
    _testArray=[db.getAllAddress mutableCopy];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     _tableView.separatorColor=[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    self.navigationItem.title=@"选择收货地址";
    
    //创建编辑按钮
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    editButton.backgroundColor = [UIColor clearColor];
    [editButton setTitle:@"新增地址" forState:UIControlStateNormal];
    [editButton setTitleColor:UIColorFromRGB(0x1abc9c) forState:UIControlStateNormal];
    editButton.titleLabel.font=[UIFont systemFontOfSize:13.f];
    [editButton addTarget:self action:@selector(newAddress:) forControlEvents:UIControlEventTouchUpInside];
    //创建edit按钮
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem=homeButtonItem;
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
    NSLog(@"cell selected at index path %ld", (long)indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
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
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"More"];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Delete"];
        
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    AddressModel *dateObject = _testArray[indexPath.row];
    cell.textLabel.text = dateObject.name;
    cell.detailTextLabel.text = dateObject.city;
    
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
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [_testArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
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

@end
