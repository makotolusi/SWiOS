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
    self.font=[UIFont fontWithName:FONT_TYPE size:FONT_MID_SIZE ];
//         }
}

-(void)smallLabel{
        self.textColor=[UIColor darkGrayColor];
    
    self.font=[UIFont fontWithName:FONT_TYPE size:FONT_SMALL_SIZE ];
    self.font=[UIFont systemFontOfSize:FONT_SMALL_SIZE];
}

-(UIView*)tableSectionLabel:(NSString*)text y:(NSInteger)y{
    UIView *view=[[UIView alloc] init];
//    view.backgroundColor=[UIColor redColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, y, 200, 20)];
//    label.backgroundColor=[UIColor blackColor];
    label.textColor=[UIColor darkGrayColor];
    label.text=text;
    label.font=[UIFont fontWithName:@"Helvetica" size:13 ];
    [view addSubview:label];
    return view;
}

+(UILabel*)navTitleLabel:(NSString*)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200,44)];
    [label midLabel];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

@end
