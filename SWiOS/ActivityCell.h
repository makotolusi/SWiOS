//
//  ActivityCell.h
//  SWiOS
//
//  Created by 陆思 on 15/9/30.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAsyncImageView.h"
#import "Activity.h"

@interface ActivityCell : UITableViewCell
@property(nonatomic,strong) Activity *activity;
@property (strong, nonatomic) YCAsyncImageView *imgView;
@property (nonatomic, strong) UILabel *activityStatus;
@property (strong, nonatomic) UILabel *activityNameLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void)updateUIWithVO:(Activity *)cellVO;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath*)indexPath;
@end
