//
//  GYAlertController.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYAlertController.h"
#import <objc/message.h>
#import <sys/utsname.h>

CGFloat _screenWidth() { return UIScreen.mainScreen.bounds.size.width; }
CGFloat _screenHeight() { return UIScreen.mainScreen.bounds.size.height; }

NSAttributedString* attributedString(NSString *text, NSDictionary<NSString *, id> *attribute) {
    if (nil == text) return nil;
    
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

NSAttributedString* kDefaultTitleAttributedString(NSString *text) {
    return attributedString(text, @{
                                    NSForegroundColorAttributeName: UIColor.blackColor,
                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:kGYNormalFontSize]
                                    });
}
NSAttributedString* kDefaultMessageAttributedString(NSString *text) {
    return attributedString(text, @{
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0],
                                    NSFontAttributeName: [UIFont systemFontOfSize:kGYMinFontSize]
                                    });
}
NSAttributedString* kDefaultAlertAttributedString(NSString *text) {
    return attributedString(text, @{
                                    NSForegroundColorAttributeName: UIColor.blackColor,
                                    NSFontAttributeName: [UIFont systemFontOfSize:kGYMinFontSize]
                                    });
}




@interface GYAlertController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, GYPresentationControllerProtocol>

@property (nonatomic, readwrite, assign) GYAlertControllerStyle preferredStyle;
@property (nonatomic, readwrite, assign) GYAnimationControllerStyle animationStyle;
/// actions
@property (nonatomic, readwrite, strong) NSMutableArray<GYAlertAction *> *interActions;
/// tableView
@property (nonatomic, readwrite, strong) UITableView *tableView;
/// tableView
@property (nonatomic, readwrite, strong) GYAlertControllerHeaderView *headerTitleMessageView;
/// tableViewConstraints
@property (nonatomic, readwrite, strong) NSArray<NSLayoutConstraint *> *tableViewConstraints;
/// contentFrame
@property (nonatomic, readwrite, assign) CGRect presentedViewFrame;

/// 自定义视图
@property (nonatomic, readwrite, strong) UIView *customView;
/// 用户自定义的customView.frame
@property (nonatomic, readwrite, assign) CGRect preferredCustomViewFrame;
/// 框架添加的对于外部视图的约束
@property (nonatomic, readwrite, strong) NSArray<NSLayoutConstraint *> *customViewConstraints;

@end

@implementation GYAlertController

#pragma mark - public

+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle {
    return [self alertControllerWithTitle:attributedTitle message:message preferredStyle:preferredStyle animationStyle:GYAnimationControllerStyleRaiseBottom];
}


+ (instancetype)alertControllerWithTitle:(nullable NSAttributedString *)attributedTitle
                                 message:(nullable NSAttributedString *)message
                          preferredStyle:(GYAlertControllerStyle)preferredStyle
                          animationStyle:(GYAnimationControllerStyle)animationStyle {
    GYAlertController *controller = [[self alloc] init];
    controller.attributedTitle = attributedTitle;
    controller.message = message;
    controller.preferredStyle = preferredStyle;
    return controller;
}

+ (instancetype)alertControllerWithView:(UIView *)view
                         preferredStyle:(GYAlertControllerStyle)preferredStyle
                         animationStyle:(GYAnimationControllerStyle)animationStyle {
    GYAlertController *controller = [self alertControllerWithTitle:nil message:nil preferredStyle:preferredStyle animationStyle:animationStyle];
    controller.customView = view;
    controller.preferredCustomViewFrame = view.frame;
    return controller;
}

- (NSArray<GYAlertAction *> *)actions {
    return _interActions.copy;
}

- (void)addAction:(GYAlertAction *)action {
    [self.interActions addObject:action];
}

#pragma mark - lifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) return nil;
    
    [self setupDefaultValues];
    
    return self;
}

- (void)loadView {
    self.view = [self contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - action

- (void)dismissThisViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.section;
    GYAlertAction *action = self.interActions[index];
    if (action.controllerDismissOnHandlerInvoked) {
        if (action.invokeHandlerAfterDismiss) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (action.handler) {
                    action.handler(action, index);
                }
            }];
            return;
        }
        
        if (action.handler) {
            action.handler(action, index);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        if (action.handler) {
            action.handler(action, index);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.interActions[indexPath.section].height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.interActions[section].topMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return self.interActions[section].bottomMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GYAlertAction *action = self.interActions[section];
    if (action.topMargin > 0) {
        return [self tableHeaderFooterViewWithBgColor:action.topMarginColor];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GYAlertAction *action = self.interActions[section];
    if (action.bottomMargin > 0) {
        return [self tableHeaderFooterViewWithBgColor:action.bottomMarginColor];
    }
    return nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.interActions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GYAlertControllerActionCell.class) forIndexPath:indexPath];
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    GYAnimationController *controller = [GYAnimationController animationControllerWithAnimationStyle:_animationStyle];
    return controller;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    GYAnimationController *controller = [GYAnimationController animationControllerWithAnimationStyle:_animationStyle];
    return controller;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    GYPresentationController *controller = [[GYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    controller.delegate = self;
    return controller;
}

#pragma mark - GYPresentationControllerProtocol

- (void)presentationController:(GYPresentationController *)controller didClickBackgroundView:(UIView *)bgView {
    if (!_dismissOnBackgroundTapped)  return;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// containerView 是 presentedVC.view（self.view） 的父视图，这里可以对其布局
- (void)presentationController:(GYPresentationController *)controller willLayoutSubviewsInContainerView:(UIView *)containerView {
    [self updatePresentedViewFrameWithSuperView:containerView];
    controller.presentedView.frame = self.presentedViewFrame;
}

/// presentedView是指self.view
- (CGRect)presentationController:(GYPresentationController *)controller presentedViewFrameInContainerView:(UIView *)containerView {
    
    [self updatePresentedViewFrameWithSuperView:containerView];
    return self.presentedViewFrame;
}

#pragma mark - assist

- (void)setupUI {
    
    if (_cornerRadius) {
        self.view.layer.cornerRadius = _cornerRadius;
        self.view.layer.masksToBounds = YES;
    }
    
    if (((_attributedTitle && _attributedTitle.length > 0) || (_message && _message.length > 0)) && _tableView) {
        GYAlertControllerHeaderView *header = [[GYAlertControllerHeaderView alloc] init];
        header.titleLabel.attributedText = _attributedTitle;
        header.messageLabel.attributedText = _message;
        header.bottomLineLayer.hidden = self.interActions.count <= 0;
        self.tableView.tableHeaderView = header;
        self.headerTitleMessageView = header;
    }
}

- (void)setupDefaultValues {
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    _dismissOnBackgroundTapped = YES;
    _presentedViewFrame = CGRectNull;
    _contentBoxIncludeUnSafeArea = YES;
}

- (UIView *)tableHeaderFooterViewWithBgColor:(UIColor * _Nullable)color {
    if (nil == color) {
        color = [UIColor colorWithRed:0.945 green:0.949 blue:0.957 alpha:1.0];
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)setupCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = NSStringFromClass(cell.class);
    NSString *selString = [NSString stringWithFormat:@"setup%@:atIndexPath:", identifier];
    SEL sel = NSSelectorFromString(selString);
    if ([self respondsToSelector:sel]) {
        ((void(*)(id, SEL, id, id))objc_msgSend)(self, sel, cell, indexPath);
    }
}

- (void)setupGYAlertControllerActionCell:(GYAlertControllerActionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GYAlertAction *action = self.interActions[indexPath.section];
    cell.bottomLineLayer.hidden = (action.bottomMargin > 0 || indexPath.section == self.interActions.count - 1);
    
    cell.titleLabel.attributedText = action.title;
    
    if (action.configuration) {
        action.configuration(cell);
    }
}

#pragma mark - layout

/// 内容宽度
- (CGFloat)contentViewMaxWidth {
    CGFloat total = 0;
    if (_customView) {
        total = _preferredCustomViewFrame.size.width;
        if (total <= 0) {
            total = _screenWidth();
        } else if (total <= 1) {
            total = total * _screenWidth();
        }
    } else {
        total = _screenWidth();
        if (_preferredWidth <= 0) { }
        else if (_preferredWidth <= 1) {
            total = total * _preferredWidth;
        } else {
            total = _preferredWidth;
        }
    }
    
    return total;
}

/// 根据safeArea修复的宽度
- (CGFloat)contentViewWidthInContainerView:(UIView *)containerView {
    CGFloat total = [self contentViewMaxWidth];
    
    CGFloat containerViewMaxWidth = containerView.bounds.size.width;
    
    if (_contentBoxIncludeUnSafeArea == NO) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *)) {
            insets = containerView.safeAreaInsets;
        }
        containerViewMaxWidth -= (insets.left + insets.right);
    }
    if (total > containerViewMaxWidth) {
        total = containerViewMaxWidth;
    }
    
    return total;
}

/// 内容高度，需要先修复tableView.tableHeaderView高度
- (CGFloat)contentViewMaxHeight {
    
    __block CGFloat total = 0;
    if (_customView) {
        total = _preferredCustomViewFrame.size.height;
        if (total <= 0) {
            total = _screenHeight();
        } else if (total <= 1) {
            total = total * _screenHeight();
        }
    } else {
        if (_preferredHeight <= 0) {
            
            if (self.tableView.tableHeaderView) {
                total += self.tableView.tableHeaderView.bounds.size.height;
            }
            
            total += [self actionsHeight];
        } else if (_preferredHeight <= 1) {
            total = _preferredHeight * _screenHeight();
        } else {
            total = _preferredHeight;
        }
    }
    
    return total;
}

/// 根据父视图（self.view.super）修复的高度.
- (CGFloat)contentViewHeightInContainerView:(UIView *)containerView {

    CGFloat total = [self contentViewMaxHeight];
    
    // 修复
    CGFloat containerViewMaxHeight = containerView.bounds.size.height;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        insets = containerView.safeAreaInsets;
    }
    
    // 内容高度增加，留出底部
    if (_contentBoxIncludeUnSafeArea && _preferredStyle == GYAlertControllerStyleActionSheet) {
        total += insets.bottom;
    }
    
    if (total > containerViewMaxHeight) {
        total = containerViewMaxHeight;
    }
    
    return total;
}

/// 更新self.view(transition过程中的presentedView)frame
- (void)updatePresentedViewFrameWithSuperView:(UIView *)containerView {
    
    CGFloat superWidth = containerView.bounds.size.width;
    CGFloat superHeight = containerView.bounds.size.height;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    // 需要考虑safeArea
    if (_contentBoxIncludeUnSafeArea == NO) {
        if (@available(iOS 11.0, *)) {
            insets = containerView.safeAreaInsets;
        }
    }
    
    CGFloat width = [self contentViewWidthInContainerView:containerView];
    if (NO == _customView) {
        [self updateTableHeaderViewFrameWithMaxWidth:width];
    }
    CGFloat height = [self contentViewHeightInContainerView:containerView];
    self.tableView.scrollEnabled = [self contentViewMaxHeight] > height;
    // x
    CGFloat x = (superWidth - width) / 2.0;
    
    // y
    CGFloat y = 0;
    if (_preferredStyle == GYAlertControllerStyleAlert) {
        y = (superHeight - height) / 2.0;
    }
    else if (_preferredStyle == GYAlertControllerStyleActionSheet) {
        y = superHeight - height - insets.bottom;
    }
    _presentedViewFrame = CGRectMake(x, y, width, height);
}

/// 更新header.frame
- (void)updateTableHeaderViewFrameWithMaxWidth:(CGFloat)maxWidth {
    if (maxWidth <= 0) {
        maxWidth = _screenWidth();
    }
    CGFloat height = [self.headerTitleMessageView heightForWidth:(maxWidth - 2 * kGYDefaultMargin)];
    self.headerTitleMessageView.frame = CGRectMake(0, 0, maxWidth, height);
}

/// 所以action所占高度
- (CGFloat)actionsHeight {
    CGFloat __block total = 0;
    [self.interActions enumerateObjectsUsingBlock:^(GYAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tmpH = obj.topMargin + obj.height + obj.bottomMargin;
        total += tmpH;
    }];
    return total;
}

#pragma mark - setter、getter

- (NSMutableArray<GYAlertAction *> *)interActions {
    if (nil == _interActions) {
        _interActions = [[NSMutableArray alloc] init];
    }
    return _interActions;
}

- (UIView *)contentView {
    if (_customView) { return _customView; }
    return self.tableView;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        [_tableView registerClass:GYAlertControllerActionCell.class forCellReuseIdentifier:NSStringFromClass(GYAlertControllerActionCell.class)];
        
    }
    return _tableView;
}

#pragma mark - debug

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}


@end
