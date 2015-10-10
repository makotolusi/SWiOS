//
//  SWExploreDetailPopTransition.h
//  SWiOS
//
//  Created by YuchenZhang on 9/5/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWExploreDetailAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>


@property (nonatomic, assign, getter=isAppearing)BOOL appearing;


@property (nonatomic, assign) CGRect transitionFromRect;

@property (nonatomic, assign) CGRect transitionToRect;

@property (nonatomic, strong) UIImage *transitionImage;

@property (nonatomic, strong) UIView *toolbarSnapView;


@end
