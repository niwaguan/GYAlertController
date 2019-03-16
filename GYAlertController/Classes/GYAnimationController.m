//
//  GYAnimationController.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYAnimationController.h"

//CGFloat const kGYDefaultAnimationDuration = 2.5;
CGFloat const kGYDefaultAnimationDuration = .25;

@interface GYAnimationController()
@property (nonatomic, readwrite, assign) CGRect presentedViewFrame;
@end

@implementation GYAnimationController

+ (instancetype)animationControllerWithAnimationStyle:(GYAnimationControllerStyle)style {
    GYAnimationController *controller = nil;
    switch (style) {
        case GYAnimationControllerStyleRaiseBottom:{
            controller = [[GYRaiseBottomAnimationController alloc] init];
        }break;
    }
    return controller;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return kGYDefaultAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext { }

@end

@implementation GYRaiseBottomAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    UIView *containerView = [transitionContext containerView];
    
    if (toVC.isBeingPresented) {
        [containerView addSubview:toView];
        
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toView.frame = CGRectOffset(finalFrame, 0, UIScreen.mainScreen.bounds.size.height - finalFrame.origin.y);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toView.frame = finalFrame;
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!canceled];
        }];
        
    }
    
    else if (fromVC.isBeingDismissed) {
        CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            fromView.frame = CGRectOffset(initFrame, 0, initFrame.size.height);
        } completion:^(BOOL finished) {
            BOOL canceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!canceled];
        }];
        
    }
}

@end
