//
//  AddressListCell.h
//  SWiOS
//
//  Created by 陆思 on 15/10/19.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyCell.h"
@class AddressListCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

@protocol AddressListCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(AddressListCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(AddressListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(AddressListCell *)cell scrollingToState:(SWCellState)state;

@end


@interface AddressListCell : EmptyCell

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <AddressListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;
@end
