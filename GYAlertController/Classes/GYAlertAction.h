//
//  GYAlertAction.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYAlertControllerActionCell;
typedef void(^GYAlertActionConfiguration)(GYAlertControllerActionCell *actionCell);
typedef void(^GYAlertActionHandler)(void);

@interface GYAlertAction : NSObject

@property (nullable, nonatomic, copy) NSAttributedString *title;
/// top margin, default 0
@property (nonatomic, readwrite, assign) CGFloat topMargin;
/// height of this action. default height 44pt
@property (nonatomic, readwrite, assign) CGFloat height;
/// bottom margin, default 0
@property (nonatomic, readwrite, assign) CGFloat bottomMargin;
/// default [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.5]
@property (nonatomic, readwrite, copy) UIColor *topMarginColor;
@property (nonatomic, readwrite, copy) UIColor *bottomMarginColor;
/// handler
@property (nonatomic, readonly, copy) GYAlertActionHandler handler;
/// default YES
@property (nonatomic, readwrite, assign) BOOL controllerDismissOnHandlerInvoked;
/// default NO. only effect on `controllerDismissOnHandlerInvoked` is YES
@property (nonatomic, readwrite, assign) BOOL invokeHandlerAfterDismiss;
/// configuration
@property (nonatomic, readonly, copy) GYAlertActionConfiguration configuration;

+ (instancetype)defaultStyleActionWithTitle:(NSAttributedString *)title
                                    handler:(GYAlertActionHandler)handler;
- (instancetype)initWithTitle:(nullable NSAttributedString *)title
                configuration:(nullable GYAlertActionConfiguration)configuration
                      handler:(nullable GYAlertActionHandler)handler;
@end

NS_ASSUME_NONNULL_END
