//
//  SWMoneyNavigationController.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/18.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "SWMoneyNavigationController.h"

@interface SWMoneyNavigationController (){
    id dict;
}

@end

@implementation SWMoneyNavigationController

//NSString * const kInitURL = @"getUserRewards";


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"钱包";
    
    [self _showMoney];

}
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)_showMoney{

    NSString* urlApi = @"getUserRewards";
    [HttpHelper sendAsyncRequest:urlApi
        success:^(id response) {

            NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"获取到的数据为dict：%@", dict);

            NSString* string = [[NSString alloc] initWithFormat:@"¥%@", dict[@"coupon"]];
            _moneyLabel.text = string;

        }
        fail:^{

        }];
}

- (IBAction)moneyList:(id)sender {
    
    SWMoneyDetailController* uiNavigationController = [[SWMoneyDetailController alloc] initWithNibName:@"SWMoneyDetailController" bundle:nil];
    
    uiNavigationController.money = dict;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"撤退"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:uiNavigationController animated:YES];
}

@end
