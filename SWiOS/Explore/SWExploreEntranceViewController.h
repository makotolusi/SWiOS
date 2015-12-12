//
//  SWExploreEntranceViewController.h
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"

@class ZYCScrollableToolbar;

extern NSInteger kWDTransitionViewTag;

@interface SWExploreEntranceViewController : SWBaseViewController


//@property (nonatomic, readonly) ZYCScrollableToolbar *scrollableToolbar;

@property (nonatomic, assign) CGPoint transViewOriCenter;

@property (nonatomic, assign) CGRect transViewOriFrame;

@property (nonatomic, strong) UIImage *transViewImage;


- (void)itemBigImageDidClicked:(NSDictionary *)itemInfo;

@end
