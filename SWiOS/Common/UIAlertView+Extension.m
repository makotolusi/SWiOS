
//
//  UIAlertView+Extension.m
//  SWiOS
//
//  Created by 陆思 on 15/10/25.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "UIAlertView+Extension.h"

@implementation UIAlertView(Extension)

+(void)showMessage:(NSString *)message{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.alpha=0.5;
    alert.backgroundColor=[UIColor blackColor];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:alert selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [alert show];
}
-(void) performDismiss:(NSTimer *)timer
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

@end
