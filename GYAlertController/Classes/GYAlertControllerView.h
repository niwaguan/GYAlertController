//
//  GYAlertControllerView.h
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN CGFloat const kDefaultMargin;
@interface GYAlertControllerHeaderView : UIView

@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UILabel *messageLabel;
@property (nonatomic, readonly, strong) CAShapeLayer *bottomLineLayer;

- (CGFloat)heightForWidth:(CGFloat)width;

@end

/**
 cell元素布局策略

 - GYAlertControllerActionCellLayoutStrategyCenter: 居中对齐
 - GYAlertControllerActionCellLayoutStrategyLeft: 左对齐
 - GYAlertControllerActionCellLayoutStrategyRight: 右对齐
 */
typedef NS_ENUM(NSInteger, GYAlertControllerActionCellLayoutStrategy) {
    GYAlertControllerActionCellLayoutStrategyCenter,
    GYAlertControllerActionCellLayoutStrategyLeft,
    GYAlertControllerActionCellLayoutStrategyRight
};

@interface GYAlertControllerActionCell : UITableViewCell

/// 布局策略
@property (nonatomic, readwrite, assign) GYAlertControllerActionCellLayoutStrategy layoutStrategy;

@property (nonatomic, readonly, strong) UIImageView *leftIconImgView;
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UIImageView *rightIconImgView;
@property (nonatomic, readonly, strong) CAShapeLayer *bottomLineLayer;

@end

NS_ASSUME_NONNULL_END
