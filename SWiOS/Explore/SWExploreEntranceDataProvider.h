//
//  SWExploreEntranceDataProvider.h
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBaseDataProvider.h"
#import "SWExploreEntranceViewController.h"
#import "SWExplorePieceCell.h"
@interface SWExploreFlatCellValueObject : NSObject

@property (nonatomic, strong) NSString *pieceID;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *sortUrl;
@property (nonatomic, strong) NSString *sortTitle;
@property (nonatomic, strong) NSString *sortTitleHint;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *pieceCategory;
// this should be make a override method on a super vo class
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end



@protocol SWExploreEntranceDataProviderDelegate <NSObject>

- (void)itemBigImageDidClicked:(NSDictionary *)itemInfo;
-(void)nextView;
@end

@interface SWExploreEntranceDataProvider : SWBaseDataProvider

@property (nonatomic, weak) SWExploreEntranceViewController *vc;

@property (nonatomic, weak) id<SWExploreEntranceDataProviderDelegate> delegate;

- (void)reloadDataWithPieceID:(NSString *)categoryID pieceImageUrl:(NSString *)pieceImageURL pageNum:(NSUInteger)pageNum last:(void (^)())last;

@end
