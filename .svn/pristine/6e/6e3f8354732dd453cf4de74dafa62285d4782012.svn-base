//
//  SWExploreEntranceDataProvider.m
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExploreEntranceDataProvider.h"
#import "SWExplorePieceCell.h"
#import "SWCommonAPI.h"
#import "SWExploreItemDetailViewController.h"

@implementation SWExploreFlatCellValueObject


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
        }
    }
    
    return self;
}

@end

@implementation SWExploreFlatCell2ValueObject


//addr = "\U94f6\U5ea7";
//currency = "\U65e5\U5143";
//description = "\U771f\U597d ";
//entertime = "2015-06-14 20:18:43";
//experience = "\U723d";
//id = 1;
//name = "\U9762\U819c ";
//picUrl1 = "http://cache.k.sohu.com/img8/wb/smccloud/2015/02/16/142410224028093694.JPEG";
//picUrl2 = "http://cache.k.sohu.com/img8/wb/smccloud/2015/02/16/142410223365920642.JPEG";
//piece = 1;
//pieceCategory = 1;
//price = 1;
//productCode = M000001;
//quantity = 0;
//systemName = M;
//total = 0;
//username = li;
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.itemName = dic[@"name"];
            self.desc = dic[@"description"];
            self.bigImageURL = dic[@"picUrl1"];
        }
    }
    
    return self;
}

@end

@interface SWExploreEntranceDataProvider ()

//@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) BOOL redBookStyleEnabled;

@property (nonatomic, assign) NSString *currentPieceID;

@property (nonatomic, strong) NSString *currentPieceImageURL;

@end

@implementation SWExploreEntranceDataProvider


- (instancetype)init
{
    self = [super init];
    if (self) {
        _redBookStyleEnabled = YES;
        _currentPieceID = @"0";

    }
    
    return self;
}

#pragma mark Data Request
- (void)reloadDataWithPieceID:(NSString *)categoryID pieceImageUrl:(NSString *)pieceImageURL pageNum:(NSUInteger)pageNum
{
     NSString *url = [NSString stringWithFormat:@"getRescueProcut/%@/0/%d", categoryID, pageNum];
    
    _currentPieceImageURL = pieceImageURL;
    _currentPieceID = categoryID;
    
    
    [[SWCommonAPI sharedInstance] post:url params:nil withSuccess:^(SWHttpRequestOperation *operation, id response) {
        
        
        NSArray *res = response;
        if (![res isKindOfClass:[NSArray class]]) {
            return ;
        }
        if (pageNum == 0) {
            [self.items removeAllObjects];
        }
        [res enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SWExploreFlatCell2ValueObject *v1 = [[SWExploreFlatCell2ValueObject alloc] initWithDictionary:obj];
            v1.leftUpSideContryImagURL = pieceImageURL;
            [self.items addObject:v1];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.targetTable reloadData];
            if (pageNum == 0) {
                self.targetTable.contentOffset = CGPointMake(0, 0);
            }
            self.isLoading = NO;
        });
        
        
    } failure:^(SWHttpRequestOperation *operation, NSError *error) {
        self.isLoading = NO;
    }];
}

- (void)loadNextPage
{
    self.currentPageNum++;
    self.isLoading = YES;
    
    [self reloadDataWithPieceID:_currentPieceID
                  pieceImageUrl:_currentPieceImageURL
                        pageNum:self.currentPageNum];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_redBookStyleEnabled) {
        return kSWPieceCellRbHeight;
    }
    return kSWPieceCellHeight;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    if (_redBookStyleEnabled) {
        rowCount = self.items.count;
    } else {
        rowCount = (self.items.count & 1) + self.items.count / 2;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_redBookStyleEnabled) {
        static NSString *cellPieceIdentifer = @"cellPieceIdentifer2";
        SWExplorePieceCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellPieceIdentifer];
        
        if (!cell) {
            cell = [[SWExplorePieceCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellPieceIdentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellClickedBlock = ^(kSWExploreCellClickType type, SWExplorePieceCell2 *cell){
                
                if (type == kSWExploreCellClickTypeBigImage) {
                    
                    [self showDetailVCWithCell:cell];
                    
                }
                
            };
            
        }
        SWExploreFlatCell2ValueObject *cellVO = [self.items objectAtIndex:indexPath.row];
        if ([cellVO isKindOfClass:[SWExploreFlatCell2ValueObject class]]) {
            [cell updateUIWithVO:cellVO];
        }
        
        return cell;
    }
    
    static NSString *cellPieceIdentifer = @"cellPieceIdentifer";
    SWExplorePieceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPieceIdentifer];
    
    
    if (!cell) {
        cell = [[SWExplorePieceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellPieceIdentifer];
    
        
    }
    
    NSInteger row = indexPath.row;
    NSRange range;
    CGFloat location = row * 2;
    CGFloat length = 2;
    if (self.items.count < location + length)
    {
        length--;
    }
    range = NSMakeRange(row * 2, length);
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndexesInRange:range];
    NSArray *subItems = [self.items objectsAtIndexes:indexset];
    [cell updateUIWithVOs:subItems];
    
    return cell;
}

#pragma mark Transitions

- (void)showDetailVCWithCell:(SWExplorePieceCell2 *)cell
{
    CGPoint currentPoint = [cell.bigImageView convertPoint:cell.bigImageView.frame.origin
                                                    toView:self.targetTable.superview];
    
    
    UIImageView *transIV = (UIImageView *)[self.targetTable.superview viewWithTag:kWDTransitionViewTag];
    
//    if (!transIV) {
//        transIV = [[UIImageView alloc] initWithImage:cell.bigImageView.image];
//        transIV.tag = kWDTransitionViewTag;
//        [self.targetTable.superview addSubview:transIV];
//    }
//    
//    transIV.frame = CGRectMake(cell.bigImageView.frame.origin.x, currentPoint.y, cell.bigImageView.frame.size.width, cell.bigImageView.frame.size.height);
    
    self.vc.transViewOriCenter = CGPointMake(self.targetTable.frame.size.width * 0.5, currentPoint.y + transIV.frame.size.height * 0.5);
    
    self.vc.transViewOriFrame = CGRectMake(0, currentPoint.y, CGRectGetWidth(cell.bigImageView.frame), CGRectGetHeight(cell.bigImageView.frame));
    
    self.vc.transViewImage = cell.bigImageView.image;
    
    
    [UIView animateWithDuration:0.1 animations:^{
        CGFloat y = transIV.bounds.size.height * 0.5;
        transIV.center = CGPointMake(transIV.center.x, y);
    } completion:^(BOOL finished) {
        
        if (finished) {
            SWExploreItemDetailViewController *idvc = [SWExploreItemDetailViewController new];
            
            NSIndexPath *index = [self.targetTable indexPathForCell:cell];
            idvc.bigImageFrame = CGRectMake(cell.bigImageView.frame.origin.x, 0, cell.bigImageView.frame.size.width, cell.bigImageView.frame.size.height);
            idvc.itemInfo = [self.items objectAtIndex:index.row];
            [self.vc.navigationController pushViewController:idvc animated:YES];
        }
    }];
    
    
}

@end
