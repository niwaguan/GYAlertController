//
//  GYPresentationController.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYPresentationController;
@protocol GYPresentationControllerProtocol <UIAdaptivePresentationControllerDelegate>

@optional;
- (void)presentationController:(GYPresentationController *)controller didClickBackgroundView:(UIView *)bgView;
- (void)presentationController:(GYPresentationController *)controller willLayoutSubviewsInContainerView:(UIView *)containerView;
- (CGRect)presentationController:(GYPresentationController *)controller presentedViewFrameInContainerView:(UIView *)containerView;

@end

@interface GYPresentationController : UIPresentationController
/// delegate
@property (nonatomic, readwrite, weak) id<GYPresentationControllerProtocol> delegate;

@end
