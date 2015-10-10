//
//  SWExploreItemDetailViewController.h
//  SWiOS
//
//  Created by YuchenZhang on 9/3/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWBaseViewController.h"
#import "YCAsyncImageView.h"
#import "SWExplorePieceCell.h"


@interface SWExploreItemDetailViewController : SWBaseViewController

@property (nonatomic, strong) SWExploreFlatCell2ValueObject *itemInfo;

@property (nonatomic, assign) CGRect bigImageFrame;

@property (nonatomic, strong) YCAsyncImageView *bigImageView;

@end
