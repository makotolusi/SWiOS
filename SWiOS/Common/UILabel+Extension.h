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
-(UIView *) changeNavTitleByFontSize:(NSString *)strTitle;
-(UIView*)tableSectionLabel:(NSString*)text;
@end

