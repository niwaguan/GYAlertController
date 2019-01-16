//
//  GYAlertControllerView.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYAlertControllerView.h"

@interface GYAlertControllerHeaderView()
/// titleLabel
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
/// messageLabel
@property (nonatomic, readwrite, strong) UILabel *messageLabel;
/// line
@property (nonatomic, readwrite, strong) CAShapeLayer *bottomLineLayer;
@end

CGFloat const kGYDefaultMargin = 15;
CGFloat const kGYMinFontSize = 12;
CGFloat const kGYNormalFontSize = 14;

@implementation GYAlertControllerHeaderView


- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat height = _contentInsets.top + _contentInsets.bottom;
    width -= (_contentInsets.left + _contentInsets.right);
    CGSize refSize = CGSizeMake(width, CGFLOAT_MAX);
    height += [_titleLabel sizeThatFits:refSize].height;
    height += [_messageLabel sizeThatFits:refSize].height;
    height += (3 * kGYDefaultMargin);
    return height;
}

#pragma mark - private

- (void)gy_setupViews {
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.numberOfLines = 0;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:kGYNormalFontSize];
        
        label;
    });
    
    _messageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.numberOfLines = 0;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:kGYMinFontSize];
        
        label;
    });
    
    _bottomLineLayer = [CAShapeLayer layer];
    _bottomLineLayer.strokeColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.957 alpha:1.0].CGColor;
    _bottomLineLayer.lineWidth = 1;
    [self.layer addSublayer:_bottomLineLayer];
}

#pragma mark - overwrite
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self gy_setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self gy_setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    BOOL needsUpdateTitleLabel = _titleLabel.text && _titleLabel.text.length > 0;
    BOOL needsUpdateMessageLabel = _messageLabel.text && _messageLabel.text.length > 0;
    if (needsUpdateTitleLabel && needsUpdateMessageLabel) {
        CGSize refSize = size;
        refSize.width -= (kGYDefaultMargin * 2);
        
        CGSize requiredSize = [_titleLabel sizeThatFits:refSize];
        _titleLabel.frame = CGRectMake(kGYDefaultMargin, kGYDefaultMargin, refSize.width, requiredSize.height);
        
        requiredSize = [_messageLabel sizeThatFits:refSize];
        _messageLabel.frame = CGRectMake(kGYDefaultMargin, CGRectGetMaxY(_titleLabel.frame) + kGYDefaultMargin, refSize.width, requiredSize.height);
    }
    else if (needsUpdateTitleLabel) {
        _messageLabel.frame = CGRectMake(kGYDefaultMargin, kGYDefaultMargin, size.width - 2 * kGYDefaultMargin, size.height - 2 * kGYDefaultMargin);
    }
    else if (needsUpdateMessageLabel) {
        _messageLabel.frame = CGRectMake(kGYDefaultMargin, kGYDefaultMargin, size.width - 2 * kGYDefaultMargin, size.height - 2 * kGYDefaultMargin);
    }
    if (NO == _bottomLineLayer.hidden) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, size.height)];
        [path addLineToPoint:CGPointMake(size.width, size.height)];
        _bottomLineLayer.path = path.CGPath;
    }
}

@end

@interface GYAlertControllerActionCell()
@property (nonatomic, readwrite, strong) UIImageView *leftIconImgView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIImageView *rightIconImgView;
@property (nonatomic, readwrite, strong) CAShapeLayer *bottomLineLayer;
@end

@implementation GYAlertControllerActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (nil == self) return nil;
    
    [self gy_setupViews];
    return self;
}

- (void)setLayoutStrategy:(GYAlertControllerActionCellLayoutStrategy)layoutStrategy {
    _layoutStrategy = layoutStrategy;
    [self setNeedsLayout];
}

#pragma mark - private

- (void)gy_setupViews {
    
    _leftIconImgView = ({
        UIImageView *iv = [[UIImageView alloc] init];
        [self.contentView addSubview:iv];
        iv;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        label.lineBreakMode =
        label.numberOfLines = 0;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        
        label;
    });
    
    _rightIconImgView = ({
        UIImageView *iv = [[UIImageView alloc] init];
        [self.contentView addSubview:iv];
        iv;
    });
    
    
    _bottomLineLayer = [CAShapeLayer layer];
    _bottomLineLayer.strokeColor = [UIColor colorWithRed:0.945 green:0.949 blue:0.957 alpha:1.0].CGColor;
    _bottomLineLayer.lineWidth = 1;
    [self.contentView.layer addSublayer:_bottomLineLayer];
}

#pragma mark - overwrite

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    CGSize labelSize = [_titleLabel sizeThatFits:self.contentView.bounds.size];
    CGRect titleLabelFrame = CGRectMake((size.width - labelSize.width) / 2.0, (size.height - labelSize.height) / 2.0, labelSize.width, labelSize.height);
    _titleLabel.frame = titleLabelFrame;
    switch (_layoutStrategy) {
        case GYAlertControllerActionCellLayoutStrategyCenter:{
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            
            if (_leftIconImgView.image) {
                CGSize imgSize = _leftIconImgView.image.size;
                _leftIconImgView.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame) - kGYDefaultMargin - imgSize.width, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
            if (_rightIconImgView.image) {
                CGSize imgSize = _rightIconImgView.image.size;
                _rightIconImgView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + kGYDefaultMargin, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
        }break;
        case GYAlertControllerActionCellLayoutStrategyLeft:{
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            if (_leftIconImgView.image) {
                CGSize imgSize = _leftIconImgView.image.size;
                _leftIconImgView.frame = CGRectMake(kGYDefaultMargin, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
            CGFloat titleLabelOriginX = kGYDefaultMargin;
            if (_leftIconImgView.image) {
                titleLabelOriginX += (_leftIconImgView.image.size.width + kGYDefaultMargin);
            }
            titleLabelFrame.origin.x = titleLabelOriginX;
            _titleLabel.frame = titleLabelFrame;
            
            if (_rightIconImgView.image) {
                CGSize imgSize = _rightIconImgView.image.size;
                CGFloat rightImgViewOriginX = kGYDefaultMargin;
                if (_leftIconImgView.image) {
                    rightImgViewOriginX += (_leftIconImgView.frame.size.width + kGYDefaultMargin);
                }
                
                if (_titleLabel.text && _titleLabel.text.length > 0) {
                    rightImgViewOriginX += (_titleLabel.frame.size.width + kGYDefaultMargin);
                }
                _rightIconImgView.frame = CGRectMake(rightImgViewOriginX, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
            
            
        }break;
        case GYAlertControllerActionCellLayoutStrategyRight:{
            _titleLabel.textAlignment = NSTextAlignmentRight;
            if (_rightIconImgView.image) {
                CGSize imgSize = _rightIconImgView.image.size;
                _rightIconImgView.frame = CGRectMake(size.width - kGYDefaultMargin - imgSize.width, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
            
            titleLabelFrame.origin.x = size.width - titleLabelFrame.size.width - kGYDefaultMargin;
            if (_rightIconImgView.image) {
                titleLabelFrame.origin.x -= (_rightIconImgView.image.size.width + kGYDefaultMargin);
            }
            _titleLabel.frame = titleLabelFrame;
            
            if (_leftIconImgView.image) {
                CGSize imgSize = _leftIconImgView.image.size;
                CGFloat leftImgViewOriginX = size.width - _leftIconImgView.image.size.width - kGYDefaultMargin;
                if (_rightIconImgView.image) {
                    leftImgViewOriginX -= (_rightIconImgView.image.size.width + kGYDefaultMargin);
                }
                
                if (_titleLabel.text && _titleLabel.text.length > 0) {
                    leftImgViewOriginX -= (titleLabelFrame.size.width + kGYDefaultMargin);
                }
                
                _leftIconImgView.frame = CGRectMake(leftImgViewOriginX, (size.height - imgSize.height) / 2.0, imgSize.width, imgSize.height);
            }
            
        }break;
    }
    if (NO == _bottomLineLayer.hidden) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, size.height)];
        [path addLineToPoint:CGPointMake(size.width, size.height)];
        _bottomLineLayer.path = path.CGPath;
    }
}


@end
