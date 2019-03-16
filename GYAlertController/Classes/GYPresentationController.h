//
//  GYPresentationController.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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
/// 背景模糊效果
@property (nullable, nonatomic, readwrite, strong) UIBlurEffect *blurEffectForBackground;
/// 背景最终的颜色
@property(nonatomic, strong) UIColor *backgroundFinalColor;

@end

NS_ASSUME_NONNULL_END
