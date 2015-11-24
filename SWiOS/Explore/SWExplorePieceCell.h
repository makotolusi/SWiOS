//
//  SWExplorePieceCell.h
//  SWiOS
//
//  Created by YuchenZhang on 7/26/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWExploreEntranceDataProvider.h"
#import "YCAsyncImageView.h"
#import "SWExploreFlatCell2ValueObject.h"
extern const CGFloat kSWPieceCellHeight;

@interface SWExplorePieceCell : UITableViewCell

- (void)updateUIWithVOs:(NSArray *)items;

@end



typedef NS_ENUM(NSInteger, kSWExploreCellClickType)
{
    kSWExploreCellClickTypeCommnet,
    kSWExploreCellClickTypeLike,
    kSWExploreCellClickTypeFavourite,
    kSWExploreCellClickTypeBigImage
};

@class SWExplorePieceCell2;

typedef void (^ExploreCellDidClicked)(kSWExploreCellClickType type, SWExplorePieceCell2 *cell);

extern const CGFloat kSWPieceCellRbHeight;
/// 抄袭小红书的样式
@interface SWExplorePieceCell2 : UITableViewCell

@property (nonatomic, strong) YCAsyncImageView *leftUpSideContryImageView;
@property (nonatomic, strong) YCAsyncImageView *bigImageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *zan;


@property (nonatomic, weak) SWExploreEntranceViewController *vc;

@property (nonatomic, copy) ExploreCellDidClicked cellClickedBlock;


- (void)updateUIWithVO:(SWExploreFlatCell2ValueObject *)cellVO;



@end