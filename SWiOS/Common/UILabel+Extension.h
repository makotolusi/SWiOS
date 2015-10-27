//
//  UILabel+Extension.h
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
-(void)midLabel;
-(void)smallLabel;
-(UIView*)tableSectionLabel:(NSString*)text y:(NSInteger)y;

+(UILabel*)navTitleLabel:(NSString*)title;
@end

