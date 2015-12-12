
//
//  LSUIScrollView.m
//  SWiOS
//
//  Created by 陆思 on 15/11/19.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "LSUIScrollView.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
@implementation LSUIScrollView


- (instancetype)initWithFrame:(CGRect)frame titleList:(NSMutableArray*)titleList
{
    self = [super initWithFrame:frame];
    self.titleList=titleList;
    if (self) {
        
        [self _initialze:frame];
    }
    
    return self;
}

- (void)_initialze:(CGRect)frame
{
    [self drawView:frame];

}

-(void)drawView:(CGRect)frame{
    int with=60;
    int startX=5;
    
    int totalWith = 0;
    int i=0;
    
    _toolbar=[[UIScrollView alloc] initWithFrame:frame];

    [_toolbar setShowsHorizontalScrollIndicator:NO];
//        _toolbar.backgroundColor=[UIColor redColor];
    for (NSString* area in _titleList) {
        
        int x=startX*(i+1)+with*i;
//        UIView* v=[[UIView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
        UILabel* l=[[UILabel alloc] initWithFrame:CGRectMake(x, 0, with, with)];
        if (i==0) {
            l.font=[UIFont systemFontOfSize:15];
            l.textColor=[UIColor redColor];
            _lastMenuLabel=l;
        }else{
           
            l.font=[UIFont systemFontOfSize:12.5f ];
            l.textColor=[UIColor blackColor];
        }
        l.textAlignment=NSTextAlignmentCenter;
//        if (i==0) {
//                l.backgroundColor=[UIColor blueColor];
//        }
//    
        l.text=area;
        l.tag=i;
//        [v addSubview:l];
        [_toolbar addSubview:l];
        l.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPressed:)];
        [l addGestureRecognizer:tapGestureRecognizer];
        
        totalWith=totalWith+5+with;
        i++;
    }
    _toolbar.contentSize = CGSizeMake(totalWith, with);
    //用它指定 ScrollView 中内容的当前位置，即相对于 ScrollView 的左上顶点的偏移
    _toolbar.contentOffset = CGPointMake(0, 0);
    //按页滚动，总是一次一个宽度，或一个高度单位的滚动
    _toolbar.pagingEnabled = YES;
    [self addSubview:_toolbar];
}

- (void)menuPressed:(UITapGestureRecognizer *)recognizer{
    if (_lastMenuLabel) {
        _lastMenuLabel.textColor=[UIColor blackColor];
        _lastMenuLabel.font=[UIFont systemFontOfSize:12.5f];
    }
    UILabel* label=recognizer.view;
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor redColor];
    _lastMenuLabel=label;
    
    if ([_toolbarDelegate respondsToSelector:@selector(scrollableToolbar:didSelecedAtIndex:)]) {
        [_toolbarDelegate scrollableToolbar:self
                          didSelecedAtIndex:label.tag];
    }

}

@end
