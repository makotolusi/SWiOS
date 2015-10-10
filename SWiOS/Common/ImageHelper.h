//
//  ImageHelper.h
//  SWUITableView
//
//  Created by 李乐 on 15/9/17.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

+(void)showImage:(UIImageView *)avatarImageView;
+(void)makeRoundCorners:(UIImageView *)uiImage;
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@end
