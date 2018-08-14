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

+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle
                          animationStyle:(GYAnimationControllerStyle)animationStyle;

@property (nonatomic, readonly) NSArray<GYAlertAction *> *actions;
- (void)addAction:(GYAlertAction *)action;

/// 整体圆角
@property (nonatomic, readwrite, assign) CGFloat cornerRadius;


@end

NS_ASSUME_NONNULL_END
