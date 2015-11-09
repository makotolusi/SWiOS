//
//  OrderListCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/13.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define orderListCellHeight 70
@interface OrderListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *imgScroll;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
