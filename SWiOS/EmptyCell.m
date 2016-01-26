//
//  EmptyCell.m
//  SWiOS
//
//  Created by 陆思 on 15/10/9.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "EmptyCell.h"
#import "UIColor+Extension.h"
@implementation EmptyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"DEDEDE"].CGColor);
    CGContextStrokeRect(context, CGRectMake(40, rect.size.height, rect.size.width, 0.5f));
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    float size=25;
    
    
    self.imageView.frame =CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,size,size);
    
    
}

@end
