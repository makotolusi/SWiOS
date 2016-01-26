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

#define kSWButtonWidth (SCREEN_HEIGHT*0.07)

#define kSWTabBarViewHeight (SCREEN_HEIGHT*0.08)
#define kSWTopViewHeight (SCREEN_WIDTH/5)
#define kSWHeadBarViewHeight (SCREEN_WIDTH/10)
#define FONT_SMALL_SIZE 13

#define icon_yonghu @"yonghu"
#define icon_gouwuche @"gouwuche"
#define icon_qiang @"huodong"
#define icon_sousuo @"sousou"


#define FONT_MID_SIZE 14

#define FONT_TYPE @"STHeitiJ-light"

#endif

#import <Availability.h>

#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif