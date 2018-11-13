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
@property (nonatomic, readwrite, strong) UIView *maskView;
@end

@implementation GYPresentationController
@synthesize delegate = _delegate;

- (void)presentationTransitionWillBegin {
    
    [self.containerView insertSubview:self.maskView atIndex:0];
    self.maskView.frame = self.containerView.bounds;
    self.maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.backgroundColor = UIColor.clearColor;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
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

#pragma mark - action

- (void)maskViewDidClick:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentationController:didClickBackgroundView:)])
    {
        [self.delegate presentationController:self didClickBackgroundView:tap.view];
    }
}

#pragma mark - setter,getter

- (UIView *)maskView {
    if (nil == _maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidClick:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
