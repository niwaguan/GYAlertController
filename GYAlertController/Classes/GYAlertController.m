//
//  GYAlertController.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYAlertController.h"
#import <objc/message.h>

static CGSize const kGYIPhoneXSize = (CGSize){1125.0, 2436.0};

BOOL _iSiPhoneX() {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(UIScreen.mainScreen.currentMode.size, kGYIPhoneXSize) : NO;
}

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

@end

@implementation GYAlertController

#pragma mark - init

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

- (NSArray<GYAlertAction *> *)actions {
    return _interActions.copy;
}

- (void)addAction:(GYAlertAction *)action {
    [self.interActions addObject:action];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (nil == self) return nil;
    
    [self setupDefaultValues];
    
    return self;
}

#pragma mark - lifeCycle

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
    GYAlertAction *action = self.interActions[indexPath.section];
    if (action.controllerDismissOnHandlerInvoked) {
        if (action.invokeHandlerAfterDismiss) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (action.handler) {
                    action.handler();
                }
            }];
            return;
        }
        
        if (action.handler) {
            action.handler();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        if (action.handler) {
            action.handler();
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
    return [self tableHeaderFooterViewWithBgColor:action.topMarginColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GYAlertAction *action = self.interActions[section];
    return [self tableHeaderFooterViewWithBgColor:action.bottomMarginColor];
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
    [self updatePresentedViewFrame];
    controller.presentedView.frame = self.presentedViewFrame;
}
/// presentedView是指self.view
- (CGRect)presentationController:(GYPresentationController *)controller presentedViewFrameInContainerView:(UIView *)containerView {
    [self updatePresentedViewFrame];
    return self.presentedViewFrame;
}

#pragma mark - assist

- (void)setupUI {
    
    if (_cornerRadius) {
        self.view.layer.cornerRadius = _cornerRadius;
        self.view.layer.masksToBounds = YES;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
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
    
    if ((_attributedTitle && _attributedTitle.length > 0) || (_message && _message.length > 0)) {
        GYAlertControllerHeaderView *header = [[GYAlertControllerHeaderView alloc] init];
        header.titleLabel.attributedText = _attributedTitle;
        header.messageLabel.attributedText = _message;
        header.frame = CGRectMake(0, 0, _screenWidth(), [header heightForWidth:[self adaptiveContentWidth]]);
        _tableView.tableHeaderView = header;
        self.headerTitleMessageView = header;
        if (self.interActions.count <= 0) {
            header.bottomLineLayer.hidden = YES;
        }
    }
    
    /// iOS 8.1 不会自动触发 updateViewConstraints 方法
    [self.view setNeedsUpdateConstraints];
}

- (void)setupDefaultValues {
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    _dismissOnBackgroundTapped = YES;
    _presentedViewFrame = CGRectNull;
}

- (UIView *)tableHeaderFooterViewWithBgColor:(UIColor * _Nullable)color {
    if (nil == color) {
        color = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.5];
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
/// override
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self.view setNeedsUpdateConstraints];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.view setNeedsUpdateConstraints];
}
/// override
- (void)updateViewConstraints {
    if (self.headerTitleMessageView) {
        self.headerTitleMessageView.frame = CGRectMake(0, 0, _screenWidth(), [self.headerTitleMessageView heightForWidth:[self adaptiveContentWidth]]);
        if (self.tableView.tableHeaderView) {
            self.tableView.tableHeaderView = nil;
        }
        self.tableView.tableHeaderView = self.headerTitleMessageView;
    }
    if (self.tableViewConstraints && self.tableViewConstraints.count > 0) {
        [NSLayoutConstraint deactivateConstraints:self.tableViewConstraints];
        self.tableViewConstraints = nil;
    }
    
    NSMutableArray<NSLayoutConstraint *> *constraints = @[].mutableCopy;
    
    UIEdgeInsets insets = [self adaptiveLayoutInsets];
    
    NSString *hFormatter = [NSString stringWithFormat:@"H:|-%f-[_tableView]-%f-|", insets.left, insets.right];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hFormatter options:NSLayoutFormatDirectionLeftToRight metrics:@{} views:NSDictionaryOfVariableBindings(_tableView)]];
    
    NSString *vFormatter = [NSString stringWithFormat:@"V:|-0-[_tableView]-%f-|", insets.bottom];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormatter options:NSLayoutFormatDirectionLeftToRight metrics:@{} views:NSDictionaryOfVariableBindings(_tableView)]];
    
    // 解决 UIView-Encapsulated-Layout-Height 冲突问题
    // see also https://stackoverflow.com/questions/23308400/auto-layout-what-creates-constraints-named-uiview-encapsulated-layout-width-h/23910943#23910943
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.priority = UILayoutPriorityDefaultLow;
    }];
    // end
    
    [NSLayoutConstraint activateConstraints:constraints];
    self.tableViewConstraints = constraints.copy;
    
    [super updateViewConstraints];
}

/// 整个视图的高度，包含了非安全区
- (CGFloat)adaptiveTotalHeight {
    __block CGFloat total = [self contentNeedsHeight];
    if (_iSiPhoneX() && _preferredStyle == GYAlertControllerStyleActionSheet) {
        CGFloat offset = [self adaptiveLayoutInsets].bottom;
        total += offset;
    }
    return total;
}

/// 内容的宽度，去掉margin和非安全区部分
- (CGFloat)adaptiveContentWidth {
    UIEdgeInsets insets = [self adaptiveLayoutInsets];
    CGFloat fullWidth = _screenWidth();
    if (_preferredWidth <= 0) { }
    else if (_preferredWidth <= 1) {
        fullWidth = fullWidth * _preferredWidth;
    }
    else {
        fullWidth = _preferredWidth;
    }
    return fullWidth - 2 * kGYDefaultMargin - insets.left - insets.right;
}
/// 内容需要的高度
- (CGFloat)contentNeedsHeight {
    __block CGFloat total = 0;
    if (self.tableView.tableHeaderView) {
        total += self.tableView.tableHeaderView.bounds.size.height;
    }
    [self.interActions enumerateObjectsUsingBlock:^(GYAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tmpH = obj.topMargin + obj.height + obj.bottomMargin;
        total += tmpH;
    }];
    return total;
}

- (UIEdgeInsets)adaptiveLayoutInsets {
    UIEdgeInsets insets;
    if (@available(iOS 11.0, *)) {
        insets = self.view.safeAreaInsets;
    } else {
        insets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, self.bottomLayoutGuide.length);
    }
    return insets;
}
/// 更新self.view(transition过程中的presentedView)frame
- (void)updatePresentedViewFrame {
    CGFloat sw = _screenWidth();
    CGFloat sh = _screenHeight();
    // width
    CGFloat width = 0;
    if (_preferredWidth <= 0) {
        width = sw;
    }
    else if (_preferredWidth <= 1.0) {
        width = sw * _preferredWidth;
    }
    else {
        width = _preferredWidth;
    }
    // height
    CGFloat height = 0;
    if (_preferredHeight <= 0) {
        height = [self adaptiveTotalHeight];
    }
    else if (_preferredHeight <= 1.0) {
        height = sh * _preferredHeight;
    }
    else {
        height = _preferredHeight;
        
        self.tableView.scrollEnabled = (height < [self contentNeedsHeight]);
    }
    // x
    CGFloat x = (sw - width) / 2.0;
    
    // y
    CGFloat y = 0;
    if (_preferredStyle == GYAlertControllerStyleAlert) {
        y = (sh - height) / 2.0;
    }
    else if (_preferredStyle == GYAlertControllerStyleActionSheet) {
        y = sh - height;
    }
    _presentedViewFrame = CGRectMake(x, y, width, height);
    
}

#pragma mark - setter、getter

- (NSMutableArray<GYAlertAction *> *)interActions {
    if (nil == _interActions) {
        _interActions = [[NSMutableArray alloc] init];
    }
    return _interActions;
}

- (CGRect)presentedViewFrame {
    if (CGRectEqualToRect(CGRectNull, _presentedViewFrame)) {
        [self updatePresentedViewFrame];
    }
    return _presentedViewFrame;
}

#pragma mark - debug

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}


@end
