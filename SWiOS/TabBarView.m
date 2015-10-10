//
//  TabBarView.m
//  SWiOS
//
//  Created by 李乐 on 15/8/20.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "TabBarView.h"



@implementation TabBarView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray *)buttons
                       target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x1abc9c);
        self.selfTarget = target;
        self.buttons = buttons;
        
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    if (_buttons != buttons) {
        _buttons = buttons;
        [self p_layoutButtons];
    }
}

#pragma mark for buttons layout
- (void)p_layoutButtons
{
    CGFloat bWidth = self.bounds.size.width / _buttons.count;
    __block CGFloat startX = 0;
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        if (b.superview == nil || b.superview != self) {
            [self addSubview:b];
        }
        b.frame = CGRectMake(startX, 0, bWidth, self.bounds.size.height);
        b.tag = idx;
        b.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        startX += bWidth;
        
    }];
}

@end
