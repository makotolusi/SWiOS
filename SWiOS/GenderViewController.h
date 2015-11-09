//
//  GenderViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/11/6.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
@protocol GenderDelegate <NSObject>

- (void)updateGenderView:(NSString*)gender;

@end

@interface GenderViewController : UITableViewController


@property(nonatomic,copy)NSString* gender;

@property(nonatomic,assign)NSInteger defautPath;

@property (weak, nonatomic) id<GenderDelegate> delegate;


@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end
