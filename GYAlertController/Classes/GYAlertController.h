//
//  GYAlertController.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAlertAction.h"
#import "GYAlertControllerView.h"
#import "GYAnimationController.h"
#import "GYPresentationController.h"

NS_ASSUME_NONNULL_BEGIN

NSAttributedString* _Nullable kDefaultTitleAttributedString(NSString * _Nullable text);
NSAttributedString* _Nullable kDefaultMessageAttributedString(NSString * _Nullable text);
NSAttributedString* _Nullable kDefaultAlertAttributedString(NSString * _Nullable text);


/**
 The alert view style。
 
 - GYAlertControllerStyleActionSheet: items from bottom to top
 - GYAlertControllerStyleAlert: items at center
 */
typedef NS_ENUM(NSInteger, GYAlertControllerStyle) {
    GYAlertControllerStyleActionSheet,
    GYAlertControllerStyleAlert
};

@interface GYAlertController : UIViewController

@property (nullable, nonatomic, copy) NSAttributedString *attributedTitle;
@property (nullable, nonatomic, copy) NSAttributedString *message;
@property (nonatomic, readonly, assign) GYAlertControllerStyle preferredStyle;
@property (nonatomic, readonly, assign) GYAnimationControllerStyle animationStyle;
/// 偏好高度（或宽度）:
/// <= 0，根据每个action配置的高度自动调整整个视图的高度（或宽度）；
/// 0 ~ 1（包含），按父视图高度（或宽度）百分比调整高度（或宽度）；
/// > 1，绝对高度（或宽度），整个视图的高度（或宽度）等于设定值。
@property (nonatomic, readwrite, assign) CGFloat preferredHeight;
/// 参见 `preferredHeight` 描述
@property (nonatomic, readwrite, assign) CGFloat preferredWidth;
/// 允许点击背景dismiss, 默认YES
@property (nonatomic, readwrite, assign) BOOL dismissOnBackgroundTapped;
/// 背景模糊效果
@property (nullable, nonatomic, readwrite, strong) UIBlurEffect *blurEffectForBackground;
/// 背景最终的颜色，默认 [UIColor colorWithWhite:0 alpha:0.5]
@property(nonatomic, strong) UIColor *backgroundFinalColor;
/// 整体圆角
@property (nonatomic, readwrite, assign) CGFloat cornerRadius;
/// 整体视图是否包含安全区意外的部分；默认YES。
@property (nonatomic, readwrite, assign) BOOL contentBoxIncludeUnSafeArea;


+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle
                          animationStyle:(GYAnimationControllerStyle)animationStyle;
/// 根据自定义视图初始化。
/// 内部会通过view.frame提供的size信息，结合GYAlertControllerStyle值调整其位置。
/// 若你想根据屏幕宽高比例进行布局，配置 view.frame.size 的 width, height 为 0..<1 区间值。参考`preferredHeight`属性描述
+ (instancetype)alertControllerWithView:(UIView *)view
                         preferredStyle:(GYAlertControllerStyle)preferredStyle
                         animationStyle:(GYAnimationControllerStyle)animationStyle;

@property (nonatomic, readonly) NSArray<GYAlertAction *> *actions;
- (void)addAction:(GYAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
