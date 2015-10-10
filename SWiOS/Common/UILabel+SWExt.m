//
//  UILabel+SWExt.m
//  SWiOS
//
//  Created by YuchenZhang on 8/23/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "UILabel+SWExt.h"

@implementation UILabel (SWExt)

- (void)swFixSize
{
    if (self.text) {
        NSString *text = self.text;
        
        CGSize fitSize = [text sizeWithFont:self.font forWidth:SCREEN_WIDTH lineBreakMode:self.lineBreakMode];
        CGRect f = self.frame;
        f.size.width = fitSize.width;
        
        self.frame = f;
        
    }
}

@end
