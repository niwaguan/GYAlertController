//
//  GYAnimationController.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 默认动画时长，0.35s
UIKIT_EXTERN CGFloat const kDefaultAnimationDuration;

/**
 动画类型
 
 - GYAlertControllerAnimationStyleRaiseBottom: 从底部升起
 */
typedef NS_ENUM(NSInteger, GYAnimationControllerStyle) {
    GYAnimationControllerStyleRaiseBottom
};


@interface GYAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;

@property (nonatomic, readwrite, assign) GYAnimationControllerStyle style;

+ (instancetype)animationControllerWithAnimationStyle:(GYAnimationControllerStyle)style;

@end

@interface GYRaiseBottomAnimationController : GYAnimationController
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
@end
NS_ASSUME_NONNULL_END
