//
//  SWMoneyDetailController.h
//  SWUITableView
//
//  Created by 李乐 on 15/9/21.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWMoneyDetailController : UIViewController

@property (nonatomic,weak) id money;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@end
