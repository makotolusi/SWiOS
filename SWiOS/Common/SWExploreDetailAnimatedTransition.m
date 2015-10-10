//
//  SWExploreDetailPopTransition.m
//  SWiOS
//
//  Created by YuchenZhang on 9/5/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExploreDetailAnimatedTransition.h"

@interface SWExploreDetailAnimatedTransition ()

@property (nonatomic, strong) UIView *caputedDetailView;

@end

@implementation SWExploreDetailAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    NSLog(@"%f", duration);
    
    
    
    if (self.isAppearing) {
         fromVC.view.hidden = YES;
        // for push
        
        CGRect transitionRect = _transitionFromRect;
        UIView *caputedDetailView = [[UIView alloc] initWithFrame:transitionRect];
        
        caputedDetailView.layer.contents = (__bridge id)((self.transitionImage.CGImage));
        
//        caputedDetailView.frame = transitionRect;
        [containerView addSubview:caputedDetailView];
        
        
        
        [UIView animateWithDuration:duration animations:^{
            caputedDetailView.center = CGPointMake(caputedDetailView.center.x, _transitionToRect.origin.y + transitionRect.size.height * 0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [caputedDetailView removeFromSuperview];
                _caputedDetailView = caputedDetailView;
                
                [containerView addSubview:toVC.view];
                toVC.view.hidden = NO;
                
                [transitionContext completeTransition:YES];
            }
        }];
        
        return;
        
        [UIView animateWithDuration:duration
                              delay:0.0f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.4f
                            options:0
                         animations:^{
                             caputedDetailView.center = CGPointMake(caputedDetailView.center.x, _transitionToRect.origin.y + transitionRect.size.height * 0.5);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [caputedDetailView removeFromSuperview];
                                 _caputedDetailView = caputedDetailView;
                                 
                                 [containerView addSubview:toVC.view];
                                 toVC.view.hidden = NO;
                                 
                                 [transitionContext completeTransition:YES];
                             }
                         }];
        
        
        
//        [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
//            
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
//                caputedDetailView.center = CGPointMake(caputedDetailView.center.x, _transitionToRect.origin.y + transitionRect.size.height * 0.5);
//            }];
//            
//        } completion:^(BOOL finished) {
//            [caputedDetailView removeFromSuperview];
//            _caputedDetailView = caputedDetailView;
//            
//            [containerView addSubview:toVC.view];
//            toVC.view.hidden = NO;
//            
//            [transitionContext completeTransition:YES];
//        }];
        
    
    }
    else
    {
        // for pop
        
        fromVC.view.hidden = YES;
        
        [containerView addSubview:_caputedDetailView];
        [containerView addSubview:_toolbarSnapView];
        
        [UIView animateWithDuration:duration animations:^{
            _caputedDetailView.center = CGPointMake(_caputedDetailView.center.x, _transitionFromRect.origin.y + _transitionFromRect.size.height * 0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [_caputedDetailView removeFromSuperview];
                [_toolbarSnapView removeFromSuperview];
                
                _caputedDetailView = nil;
                _toolbarSnapView = nil;
                toVC.view.hidden = NO;
                
                [containerView addSubview:toVC.view];
                
                [transitionContext completeTransition:YES];
            }
        }];
        
        return;
        
        
        [UIView animateWithDuration:duration
                              delay:0.0f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.4f
                            options:0
                         animations:^{
                             _caputedDetailView.center = CGPointMake(_caputedDetailView.center.x, _transitionFromRect.origin.y + _transitionFromRect.size.height * 0.5);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [_caputedDetailView removeFromSuperview];
                                 [_toolbarSnapView removeFromSuperview];
                                 
                                 _caputedDetailView = nil;
                                 _toolbarSnapView = nil;
                                 toVC.view.hidden = NO;
                                 
                                 [containerView addSubview:toVC.view];
                                 
                                 [transitionContext completeTransition:YES];
                             }
                         }];
    }
    
}

@end
