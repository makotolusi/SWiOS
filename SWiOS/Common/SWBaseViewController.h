//
//  SWBaseViewController.h
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWBaseViewController : UIViewController

@property(nonatomic,strong) NSString* pageName;
- (void)drawViews;

- (void)updateViews;


@end
