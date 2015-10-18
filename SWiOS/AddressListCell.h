//
//  AddressListCellTableViewCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/18.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyCell.h"
@interface AddressListCell :EmptyCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end
