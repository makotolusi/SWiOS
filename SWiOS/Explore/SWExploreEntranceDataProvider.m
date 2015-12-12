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
#import "CommentViewController.h"
#import "UILabel+Extension.h"
#import "SWExploreFlatCell2ValueObject.h"
#import "UIWindow+Extension.h"
#import "DetailPageController.h"
#import "ActivityProduct.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
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
    
     NSString *url = [NSString stringWithFormat:@"getRescueProcut/%@/0/%ld", categoryID, pageNum];
    
    _currentPieceImageURL = pieceImageURL;
    _currentPieceID = categoryID;
    
    
//    [[SWCommonAPI sharedInstance] post:url params:nil withSuccess:^(SWHttpRequestOperation *operation, id response) {
        [HttpHelper sendPostRequest:url parameters:nil success:^(id response){
            NSArray *res =[response jsonString2Dictionary];
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

        } fail:^(){
          self.isLoading = NO;
        } parentView:nil];
        
    
        
//    } failure:^(SWHttpRequestOperation *operation, NSError *error) {
//        self.isLoading = NO;
//    }];
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
     SWExploreFlatCell2ValueObject *cellVO = [self.items objectAtIndex:indexPath.row];
    NSLog(@"%@ row %ld",cellVO.productCode,indexPath.row);
    if (_redBookStyleEnabled) {
        static NSString *CellIdentifier = @"cellPieceIdentifer2";
//         NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
        SWExplorePieceCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.vc=self.vc;
        if (!cell) {
            cell = [[SWExplorePieceCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellVO:cellVO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if ([cellVO isKindOfClass:[SWExploreFlatCell2ValueObject class]]) {
                [cell updateUIWithVO:cellVO];
//            }
            
            cell.cellClickedBlock = ^(kSWExploreCellClickType type, SWExplorePieceCell2 *cell){
                
                if (type == kSWExploreCellClickTypeBigImage) {
                    
//                    [self showDetailVCWithCell:cell];
                    // 图片
                    DetailPageController *thumbViewController = [[DetailPageController alloc] init];
                    ActivityProduct *product=[[ActivityProduct alloc] init];
                    product.productCode=cellVO.productCode;
                    product.picUrl1=cellVO.bigImageURL;
                    thumbViewController.product=product;
                    //back button style
                    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
                    self.vc.navigationItem.backBarButtonItem = cancelButton;
                    [self.vc.navigationController pushViewController:thumbViewController animated:YES];
                }
                
                if (type == kSWExploreCellClickTypeCommnet) {
                   
                    
                }
                
            };
            
        }else{
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
