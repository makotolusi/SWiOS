//
//  SWRegisterView.h
//  GHWalk
//
//  Created by 李乐 on 15/8/29.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWRegisterViewDelegate;


@interface SWRegisterView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<SWRegisterViewDelegate> delegate;

@end

@protocol SWRegisterViewDelegate <NSObject>

- (void)registerDidDismissView:(SWRegisterView *)registerView;


@end
