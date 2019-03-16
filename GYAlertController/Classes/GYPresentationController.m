//
//  GYPresentationController.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYPresentationController.h"

@interface GYPresentationController()
/// maskView
@property (nonatomic, readwrite, strong) UIView *backgroundView;
@end

@implementation GYPresentationController
@synthesize delegate = _delegate;

- (void)presentationTransitionWillBegin {
    
    if (_blurEffectForBackground && UIAccessibilityIsReduceTransparencyEnabled() == NO) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffectForBackground];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:effectView];
        [self addTapGesutreForView:effectView];
        effectView.frame = self.containerView.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        
        [self.containerView insertSubview:self.backgroundView atIndex:0];
        self.backgroundView.frame = self.containerView.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.backgroundView.backgroundColor = self.backgroundFinalColor;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.backgroundView.backgroundColor = self.backgroundFinalColor;
        }];
    }
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.backgroundView.backgroundColor = UIColor.clearColor;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    }];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentationController:willLayoutSubviewsInContainerView:)]) {
        [self.delegate presentationController:self willLayoutSubviewsInContainerView:self.containerView];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentationController:presentedViewFrameInContainerView:)]) {
        return [self.delegate presentationController:self presentedViewFrameInContainerView:self.containerView];
    }
    return [super frameOfPresentedViewInContainerView];
}

#pragma mark -

- (void)backgroundViewDidClick:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentationController:didClickBackgroundView:)])
    {
        [self.delegate presentationController:self didClickBackgroundView:tap.view];
    }
}

- (void)addTapGesutreForView:(UIView *)view {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidClick:)];
    [view addGestureRecognizer:tap];
}

- (UIView *)backgroundView {
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = UIColor.clearColor;
        [self addTapGesutreForView:_backgroundView];
    }
    return _backgroundView;
}

@end
