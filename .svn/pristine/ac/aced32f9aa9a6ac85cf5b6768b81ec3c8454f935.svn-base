//
//  ZYCExplodeStyleLoadView.m
//  SWiOS
//
//  Created by zhangyuchen on 15-9-8.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "ZYCExplodeStyleLoadView.h"

#define DEG_TO_RAD(angle) (angle / 180.0f * M_PI)

@interface ZYCExplodeStyleLoadView ()

@property (nonatomic, assign)CGFloat progressPercent;

@property (nonatomic, weak) UIView *maskedView;

@property (nonatomic, assign)CGFloat radius;

@end

@implementation ZYCExplodeStyleLoadView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint center = CGPointMake(roundf(CGRectGetWidth(rect) * 0.5f), roundf(CGRectGetHeight(rect) * 0.5f));
    
    CGFloat height = CGRectGetHeight(rect);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    
    [bezierPath setLineWidth:2.0f];
    
    
    CGFloat endAngle = DEG_TO_RAD(self.progressPercent * 360) - M_PI_2;
    
    [bezierPath addArcWithCenter:center radius:_cycleSize.width * 0.5 startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    
    [bezierPath stroke];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cycleSize = CGSizeMake(40, 40);
//        self.layer.zPosition = CGFLOAT_MAX;
        
    }
    
    return self;
}

- (void)setCycleSize:(CGSize)cycleSize
{
    _cycleSize = cycleSize;
    _radius = (int)cycleSize.width >> 1;
}


- (CGFloat)currentProgressive
{
    return _progressPercent;
}


- (void)updateProgressPercent:(CGFloat)progressPercent
{
    self->_progressPercent = progressPercent;
    [self setNeedsDisplay];
}

- (void)finishLoadingAnimation
{
    
    self.maskedView = self.superview;
    
    
    CAShapeLayer *cycleLayer = [CAShapeLayer layer];
    cycleLayer.frame = CGRectMake(0, 0, _cycleSize.width, _cycleSize.height);
    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGPathAddArc(pathRef, NULL, (int)_cycleSize.width >> 1, (int)_cycleSize.width >> 1, _cycleSize.width, 0, M_2_PI, YES);
    
    CGPathAddRoundedRect(pathRef, NULL, cycleLayer.frame, (int)_cycleSize.width >> 1, (int)_cycleSize.width >> 1);
    
    
    cycleLayer.path = pathRef;
    
    
    CGPathRelease(pathRef);
    
    cycleLayer.fillColor = [UIColor greenColor].CGColor;
//    cycleLayer.backgroundColor = [UIColor greenColor].CGColor;
    

    _maskedView.layer.mask = cycleLayer;
    
    
    
    CGPoint center = CGPointMake(roundf(CGRectGetWidth(self.bounds) * 0.5f), roundf(CGRectGetHeight(self.bounds) * 0.5f));
    center = [self convertPoint:center toView:_maskedView];
    cycleLayer.position = center;
    
//    [_maskedView.layer addSublayer:cycleLayer];
//    [self removeFromSuperview];
//    return;
    

    
    NSValue *newBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(_maskedView.bounds), CGRectGetWidth(_maskedView.bounds))];
    CGMutablePathRef newPathref = CGPathCreateMutable();
    
//    CGPathAddArc(newPathref, NULL, (int)_maskedView.bounds.size.width >> 1, (int)_maskedView.bounds.size.height >> 1, _maskedView.bounds.size.width, 0, M_2_PI, YES);
    
    CGFloat maxRadius = MAX(_maskedView.bounds.size.width, _maskedView.bounds.size.height);
    
    maxRadius = _maskedView.bounds.size.width;
//    CGPathAddRoundedRect(newPathref, NULL, CGRectMake(-_cycleSize.width * 2, -_cycleSize.height * 2, maxRadius, maxRadius), (int)maxRadius >> 1, (int)maxRadius >> 1);
//    CGPathAddRoundedRect(newPathref, NULL, CGRectMake(-_cycleSize.width, -_cycleSize.height, maxRadius, maxRadius), (int)maxRadius >> 1, (int)maxRadius >> 1);
    
    CGPathAddRoundedRect(newPathref, NULL, CGRectMake(0, 0, maxRadius, maxRadius), (int)maxRadius >> 1, (int)maxRadius >> 1);
    
    
    
    // ani1
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:cycleLayer.bounds];
    boundsAnimation.toValue = newBounds;
    // ani2
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.toValue = (__bridge id)(newPathref);
    CGPathRelease(newPathref);
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    
    // ani for sacle transformation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CGFloat maxSize = MAX(_maskedView.bounds.size.width, _maskedView.bounds.size.height);
    CGFloat scaleFactor = roundf(maxSize / _cycleSize.width);
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scaleFactor, scaleFactor, scaleFactor)];

    
    

//    aniGroup.animations = @[boundsAnimation, scaleAnimation];
    aniGroup.animations = @[scaleAnimation];
    aniGroup.removedOnCompletion = NO;
    aniGroup.duration = 0.5f;
    aniGroup.fillMode = kCAFillModeForwards;
    
    aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    aniGroup.delegate = self;
    
    [cycleLayer addAnimation:aniGroup forKey:@"hello"];
    
    [self removeFromSuperview];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        _maskedView.layer.mask = nil;
        [_maskedView setNeedsLayout];
    }
}

@end
