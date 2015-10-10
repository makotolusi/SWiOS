//
//  YCAsyncImageView.m
//  SWiOS
//
//  Created by YuchenZhang on 7/26/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "YCAsyncImageView.h"

static NSCache *kMemCache;

static dispatch_queue_t kYCRemoteLoadQueue;

static inline NSString *kCacheGetKeyFromURL(NSString *url)
{
    NSString *res = url;
    
    NSRange queMarkIdx = [url rangeOfString:@"?"];
    if (queMarkIdx.location != NSNotFound) {
        res = [url substringToIndex:queMarkIdx.location];
    }
    
    return res;
}

@implementation YCAsyncImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)initialize
{
    kMemCache = [[NSCache alloc] init];
    kYCRemoteLoadQueue = dispatch_queue_create("com.yuchen.ycasyncImageViewQueue",
                                               DISPATCH_QUEUE_CONCURRENT );
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.url = url;
    }
    
    return self;
}

- (void)setUrl:(NSString *)url
{
    if (_url != url) {
        _url = url;
    }
    [self p_loadImage];
    
}

- (void)p_loadImage
{
    NSData *cachedData = [kMemCache objectForKey:kCacheGetKeyFromURL(_url)];
    
    UIImage *image = nil;
    if (cachedData) {
        NSLog(@"cache hitted");
        image = [UIImage imageWithData:cachedData];
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
        
        [image drawInRect:self.bounds];
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        self.image = finalImage;
        return;
    }
    
    self.image = nil;
    
    NSLog(@"cache hit failed");
    [self p_loadImageFromRemote];
}

- (void)p_loadImageFromRemote
{
    dispatch_async(kYCRemoteLoadQueue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]];
        
        if (data) {
            
            UIImage *img = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
           
            [img drawInRect:self.bounds];
            
            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
        
            // cache it
            [kMemCache setObject:UIImagePNGRepresentation(finalImage)
                          forKey:kCacheGetKeyFromURL(_url)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // refresh ui
                self.image = finalImage;
            });
            
        }
    });
}

@end
