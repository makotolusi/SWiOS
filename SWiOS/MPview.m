//
//  MPview.m
//  SWiOS
//
//  Created by 陆思 on 15/11/13.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "MPview.h"
#import "UIAlertView+Extension.h"
static CGFloat kSWCellCountTag = 1;


@implementation MPview

-(instancetype)initWithFrame:(CGRect)frame gap:(float)gap{
    self=[super initWithFrame:frame];
    if(self){
        _count=1;
        _cartModel=[ShoppingCartModel sharedInstance];
        self.backgroundColor=[UIColor whiteColor];
        //-
        UIButton *minus=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
      
        [self minusPlus:minus withSign:@"jianhao"];
        //+
        UIButton *plus=[[UIButton alloc] initWithFrame:CGRectMake(minus.frame.origin.x+gap, minus.frame.origin.y, 30, 30)];
        [self minusPlus:plus withSign:@"jiahao"];
        //count
        _countText=[[UITextField alloc] initWithFrame:CGRectMake(minus.frame.origin.x+(plus.frame.origin.x-minus.frame.origin.x)/2,minus.frame.origin.y, 100, 20)];
        [_countText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        _countText.tag=kSWCellCountTag;
        [plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
        [minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
        _countText.keyboardType = UIKeyboardTypeNumberPad;
        _countText.returnKeyType =UIReturnKeyGo;
        _countText.textColor=UIColorFromRGB(labelTextColor);
        _countText.text=[@"" stringByAppendingFormat:@"%d",_count];
        _countText.clearsOnBeginEditing = YES;
        [self addSubview:_countText];

    }
    return self;
}

//-(void)kbHide:(UITapGestureRecognizer*)tap{
//    [count resignFirstResponder];
//}



-(void)minusPlus:(UIButton*)button withSign:(NSString *) sign{
      float inset=10;
    [button setImage:[UIImage imageNamed:sign] forState:UIControlStateNormal];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset) ];
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=15.0f;
    button.alpha=0.7f;
    //    [button setTitle:sign forState:UIControlStateNormal];
    //    minus.titleLabel.font=[UIFont systemFontOfSize:15];
    button.titleLabel.font=[UIFont fontWithName:@"STHeitiK-Light" size:15 ];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset) ];
    button.layer.backgroundColor=UIColorFromRGB(0x1abc9c).CGColor;
    
    [self addSubview:button];
}

- (void)textFieldChanged:(UIButton*)sender{
    _count=[_countText.text intValue];
}

- (void)plusAction:(UIButton*)sender{
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"" stringByAppendingFormat:@"%ld",(long) ++_count];
}
- (void)minusAction:(UIButton*)sender{
    if (_count>1) {
        UILabel *countLable= (UILabel *)[self viewWithTag:kSWCellCountTag];
        countLable.text=[@"" stringByAppendingFormat:@"%ld",(long) --_count];
    }
}
-(void)labelStyle:(UILabel*)label text:(NSString *)text size:(int)size{
    label.textColor=UIColorFromRGB(0x1abc9c);
    label.text=text;
    label.font=[UIFont systemFontOfSize:13];
    label.font=[UIFont fontWithName:@"STHeitiK-Light" size:size ];
}
@end
