//
//  LSUIScrollView.h
//  SWiOS
//
//  Created by 陆思 on 15/11/19.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSUIScrollView;
@protocol LSUIScrollViewDelegate <NSObject>

- (void)scrollableToolbar:(LSUIScrollView *)toolbar
        didSelecedAtIndex:(NSInteger) index;

@end

@interface LSUIScrollView : UIView

@property(strong,nonatomic) UIScrollView *toolbar;
@property(strong,nonatomic) NSMutableArray* titleList;

@property (nonatomic, weak) id<LSUIScrollViewDelegate> toolbarDelegate;

@property (nonatomic,strong) UILabel* lastMenuLabel;
- (instancetype)initWithFrame:(CGRect)frame titleList:(NSArray*)titleList;
@end
