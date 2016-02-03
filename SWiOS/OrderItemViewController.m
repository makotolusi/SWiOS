
//
//  OrderItemViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/28.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderItemViewController.h"
#import "ShoppingCartCell.h"
@interface OrderItemViewController ()
@property (nonatomic,strong) NSMutableArray *cartProducts;
@end

@implementation OrderItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.cartProducts=[[NSMutableArray alloc] init];
    _cartModel=[ShoppingCartModel sharedInstance];
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = SCREEN_HEIGHT/7;
    //        _tableView.contentInset = UIEdgeInsetsMake(0, 0.f, 0.f, 0.f);
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;

    if (self.errCartProduct) {
        NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
        
        for (NSDictionary *od in self.errCartProduct) {
            [map setObject:od[@"code"] forKey:od[@"productCode"]];
        }
//        NSLog(@" product code is %@ status is %@",od[@"productCode"],od[@"code"]);
        for (ActivityProduct* ap in _cartModel.arOfWatchesOfCart) {
            ap.code= map[ap.productCode];
        }
        
      
    }
    
    self.cartProducts=_cartModel.arOfWatchesOfCart;
    
    [self.view addSubview:_tableView];

    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _cartModel.arOfWatchesOfCart.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"shoppingCartCell1";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.activityProduct=self.cartProducts[indexPath.row];
        cell.isEdit=NO;
        [cell initEdite];
        [cell settingFrame];
       
        cell.indexPath=indexPath;
        cell.delegate=self;
        cell.tableView=_tableView;
        
    }else{
        
    }
    [cell settingData];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
