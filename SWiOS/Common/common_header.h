//
//  common_header.h
//  SWiOS
//
//  Created by YuchenZhang on 7/19/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#ifndef SWiOS_common_header_h
#define SWiOS_common_header_h
#import "ui_define.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define labelTextColor 0x1abc9c

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define FONT_SMALL_SIZE 12

#define FONT_MID_SIZE 15
#endif
