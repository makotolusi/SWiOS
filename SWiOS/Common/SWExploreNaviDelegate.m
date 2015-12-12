//
//  SWExploreTransition.m
//  SWiOS
//
//  Created by YuchenZhang on 9/5/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExploreNaviDelegate.h"
#import "SWExploreEntranceViewController.h"
#import "SWExploreItemDetailViewController.h"
#import "SWExploreDetailAnimatedTransition.h"
#import "ZYCScrollableToolbar.h"

@interface SWExploreNaviDelegate ()


@property (nonatomic, weak) UINavigationController *naviController;

@property (nonatomic, strong) SWExploreDetailAnimatedTransition *dat;

@property (nonatomic, strong) UIPanGestureRecognizer *panGuesture;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentIT;

@end

@implementation SWExploreNaviDelegate

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.dat = [SWExploreDetailAnimatedTransition new];
////        self.percentIT = [[UIPercentDrivenInteractiveTransition alloc] init];
//    }
//    return self;
//}

- (id)initWithNavigationController:(UINavigationController *)navControl
{
    self = [super init];
    
    if (self) {
        self.dat = [SWExploreDetailAnimatedTransition new];
        self.naviController = navControl;
        navControl.delegate = self;
        
        self.panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuestureHandler:)];
        _panGuesture.enabled = NO;
    }
    
    return self;
}



#pragma mark Pan Guesture Recognizer
- (void)panGuestureHandler:(UIPanGestureRecognizer *)panGues
{
    CGPoint transition = [panGues translationInView:panGues.view];
    
//    NSLog(@"x:%f y:%f", transition.x , transition.y);
    
    
    CGPoint velocity = [panGues velocityInView:panGues.view];
    
//    NSLog(@"vx:%f vy:%f", velocity.x, velocity.y);
    
    switch (panGues.state) {
        case UIGestureRecognizerStateBegan:
            
        {
            self.percentIT = [[UIPercentDrivenInteractiveTransition alloc] init];
            [_percentIT updateInteractiveTransition:0.0f];
            
            
        }
            break;
            
            
        case UIGestureRecognizerStateChanged:
        {
            float percent = (float)transition.x / panGues.view.frame.size.width * 2;
            if (percent < 0) {
                percent = -percent;
            }
            NSLog(@"percent:%f", percent);
            
            [_percentIT updateInteractiveTransition:percent];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            
            if (transition.x > 80 || velocity.x > 50) {
                [_percentIT finishInteractiveTransition];
                [_naviController popViewControllerAnimated:YES];
            } else {
                [_percentIT cancelInteractiveTransition];
            }
            self.percentIT = nil;

        }
            break;
            
        default:
            break;
    }
}



- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    if (animationController == self.dat && self.dat.isAppearing) {
        return self.percentIT;
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    
    if (operation == UINavigationControllerOperationPush) {

        SWExploreEntranceViewController *listVC = (SWExploreEntranceViewController *)fromVC;
        CGRect transitionFrame = listVC.transViewOriFrame;
        transitionFrame.origin.y += navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        
        
        
        SWExploreItemDetailViewController *detailVC = (SWExploreItemDetailViewController *)toVC;
        _panGuesture.enabled = YES;
//        [toVC.view addGestureRecognizer:_panGuesture];
        
//        CGRect transitionToFrame = detailVC.bigImageFrame;
        
//        transitionToFrame.origin.y += navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        
//        UIView *toolbarSnapView = [[listVC scrollableToolbar] snapshotViewAfterScreenUpdates:NO];
//        
//        CGRect toolbarFrame =  [listVC scrollableToolbar].frame;
//        
//        toolbarFrame.origin.y += navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//        
//        
//        toolbarSnapView.frame = toolbarFrame;
//        
//    
//        _dat.appearing = YES;
//        _dat.transitionFromRect = transitionFrame;
////        _dat.transitionToRect = transitionToFrame;
//        _dat.transitionImage = listVC.transViewImage;
//        _dat.toolbarSnapView = toolbarSnapView;
        return _dat;
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        [toVC.view removeGestureRecognizer:_panGuesture];
        _panGuesture.enabled = NO;
        _dat.appearing = NO;
        return _dat;
    }
    
    
    return nil;
}

@end
