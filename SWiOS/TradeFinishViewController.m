
//
//  TradeFinishViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/27.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "TradeFinishViewController.h"
#import "EmptyCell.h"
#import "UILabel+Extension.h"
@interface TradeFinishViewController ()

@end

@implementation TradeFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60) ];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight=90;
    _tableView.backgroundColor=[UIColor blackColor];
    _tableView.separatorStyle=UITableViewStyleGrouped;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(150, 0.f, 0.f, 0.f);
    UIView *sucView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 150)];
    sucView.backgroundColor=UIColorFromRGB(0x1abc9c);
    [self.view addSubview:_tableView];
    [self.view addSubview:sucView];
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(10, sucView.frame.size.height/2, 200, 20)];
    label1.text=@"买家已付款";
    [label1 midLabel];
    label1.textColor=[UIColor whiteColor];
    [sucView addSubview:label1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return [[EmptyCell alloc] init];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return <#expression#>
//}

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
