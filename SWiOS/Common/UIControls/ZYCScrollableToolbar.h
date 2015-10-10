//
//  ZYCScrollableToolbar.h
//  SWiOS
//
//  Created by YuchenZhang on 8/23/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYCScrollableToolbar;

@protocol ZYCScrollableToolbarDelegate <NSObject>

- (void)scrollableToolbar:(ZYCScrollableToolbar *)toolbar
        didSelecedAtIndex:(NSInteger) index;

@end

@interface ZYCScrollableToolbar : UIControl

@property (nonatomic, weak) id<ZYCScrollableToolbarDelegate> toolbarDelegate;

@property (nonatomic, strong, readonly) NSArray *titles;

@property (nonatomic, assign) CGFloat titlePadding;

@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, assign, readonly) NSInteger currentSelectingIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)updateWithTitles:(NSArray *)titles;

- (void)doSelectAtIndex:(NSInteger)index;


@end
