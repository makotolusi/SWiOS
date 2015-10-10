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

- (void)updateUIWithVO:(Activity *)cellVO;
@end
