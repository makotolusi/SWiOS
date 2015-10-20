//
//  AddressView.h
//  SWiOS
//
//  Created by 陆思 on 15/10/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddressView : UIView
@property (nonatomic, strong) AddressModel *dateObject;
-(instancetype)initWithFrame:(CGRect)frame data:(AddressModel*)data;
@end
