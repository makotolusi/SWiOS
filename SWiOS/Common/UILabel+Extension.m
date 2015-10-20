//
//  UILabel+Extension.m
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


-(void)midLabel{
    self.textColor=[UIColor darkGrayColor];
    self.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_MID_SIZE ];
}

-(void)smallLabel{
    self.font=[UIFont fontWithName:@"STHeitiK-Light" size:FONT_SMALL_SIZE ];
}

-(UIView *) changeNavTitleByFontSize:(NSString *)strTitle
{
    //自定义标题
    self.frame=CGRectMake(0, 0 , 100, 44);
    self.backgroundColor = [UIColor clearColor];
    [self midLabel];
    self.textAlignment = NSTextAlignmentCenter;
    self.text = strTitle;
    return self;
}

@end
