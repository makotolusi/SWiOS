//
//  ImageHelper.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/17.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "ImageHelper.h"

static CGRect oldframe;

@implementation ImageHelper
+ (void)showImage:(UIImageView*)avatarImageView
{

    UIImage* image = avatarImageView.image;

    UIWindow* window = [UIApplication sharedApplication].keyWindow;

    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];

    backgroundView.backgroundColor = [UIColor blackColor];

    backgroundView.alpha = 0;

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:oldframe];

    imageView.image = image;

    imageView.tag = 1;

    [backgroundView addSubview:imageView];

    [window addSubview:backgroundView];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];

    [backgroundView addGestureRecognizer:tap];

    [UIView animateWithDuration:0.3
        animations:^{

            imageView.frame = CGRectMake(0, ([UIScreen
                                                     mainScreen]
                                                    .bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) / 2,
                [UIScreen mainScreen].bounds.size.width, image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);

            backgroundView.alpha = 1;

        }
        completion:^(BOOL finished){

        }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{

    UIView* backgroundView = tap.view;

    UIImageView* imageView = (UIImageView*)[tap.view viewWithTag:1];

    [UIView animateWithDuration:0.3

        animations:^{

            imageView.frame = oldframe;

            backgroundView.alpha = 0;

        }
        completion:^(BOOL finished) {

            [backgroundView removeFromSuperview];

        }];
}

// 圆角
+ (void)makeRoundCorners:(UIImageView*)uiImage
{
    uiImage.layer.masksToBounds = YES;
    uiImage.layer.cornerRadius = 10.0f;
    uiImage.layer.borderWidth = 1.0f;
    uiImage.layer.borderColor = [[UIColor grayColor] CGColor];
}

// 保持原来的长宽比，生成一个缩略图
+ (UIImage*)thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize
{
    UIImage* newimage;
    if (nil == image) {
        newimage = nil;
    }
    else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldsize.width / oldsize.height) {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }
        else {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height)); //clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
