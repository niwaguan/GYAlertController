//
//  GYViewController.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYViewController.h"
#import "GYTestCase.h"
#import <objc/message.h>
#import "GYDetailViewController.h"

#import <GYAlertController/GYAlertController.h>


@interface GYViewController ()
@property (nonatomic, readwrite, strong) NSMutableArray<GYTestCase *> *dataSource;
@end

@implementation GYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - cases

- (void)case0AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController alertControllerWithTitle:nil message:nil preferredStyle:[self styleAtIndexPath:indexPath]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case1AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:kDefaultTitleAttributedString(@"标题")
                                     message:nil
                                     preferredStyle:GYAlertControllerStyleActionSheet];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case2AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:nil
                                     message:kDefaultMessageAttributedString(@"一粒尘可填海，一根草斩尽日月星辰，弹指间天翻地覆。群雄并起，万族林立，诸圣争霸，乱天动地；问苍茫大地，谁主沉浮？一个少年从大荒中走出，一切从这里开始。")
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)case3AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    GYAlertAction *ok = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"ok") handler:^(GYAlertAction *action, NSInteger index){
        [self printAction:action atIndex:index];
    }];
    [controller addAction:ok];
    
    GYAlertAction *cancel = [[GYAlertAction alloc] initWithTitle:kDefaultAlertAttributedString(@"cancel")
                                                   configuration:^(GYAlertControllerActionCell *actionCell)
    {
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"cancel" attributes:@{NSForegroundColorAttributeName: UIColor.redColor}];
        actionCell.textLabel.attributedText = text;
        actionCell.textLabel.textAlignment = NSTextAlignmentCenter;
    } handler:^(GYAlertAction *action, NSInteger index){
        [self printAction:action atIndex:index];
    }];
    cancel.topMargin = 5.0;
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case4AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:kDefaultTitleAttributedString(@"标题")
                                     message:kDefaultMessageAttributedString(@"一粒尘可填海，一根草斩尽日月星辰，弹指间天翻地覆。群雄并起，万族林立，诸圣争霸，乱天动地；问苍茫大地，谁主沉浮？一个少年从大荒中走出，一切从这里开始。")
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case5AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:kDefaultTitleAttributedString(@"标题")
                                     message:nil
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    GYAlertAction *ok = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"ok") handler:^(GYAlertAction *action, NSInteger index){
        [self printAction:action atIndex:index];
    }];
    [controller addAction:ok];
    
    GYAlertAction *cancel = [[GYAlertAction alloc] initWithTitle:nil
                                                   configuration:^(GYAlertControllerActionCell *actionCell)
                             {
                                 NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"cancel" attributes:@{NSForegroundColorAttributeName: UIColor.redColor}];
                                 actionCell.textLabel.attributedText = text;
                                 actionCell.textLabel.textAlignment = NSTextAlignmentCenter;
                             } handler:^(GYAlertAction *action, NSInteger index){
                                 [self printAction:action atIndex:index];
                             }];
    cancel.topMargin = 5.0;
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case6AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:nil
                                     message:kDefaultMessageAttributedString(@"ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.")
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    
    GYAlertAction *ok = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"ok") handler:^(GYAlertAction *action, NSInteger index){
        [self printAction:action atIndex:index];
    }];
    [controller addAction:ok];
    
    GYAlertAction *cancel = [[GYAlertAction alloc] initWithTitle:nil
                                                   configuration:^(GYAlertControllerActionCell *actionCell)
                             {
                                 NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"cancel" attributes:@{NSForegroundColorAttributeName: UIColor.redColor}];
                                 actionCell.textLabel.attributedText = text;
                                 actionCell.textLabel.textAlignment = NSTextAlignmentCenter;
                             } handler:^(GYAlertAction *action, NSInteger index){
                                 [self printAction:action atIndex:index];
                             }];
    cancel.topMargin = 5.0;
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case7AtIndexPath:(NSIndexPath *)indexPath {
    GYAlertController *controller = [GYAlertController
                                     alertControllerWithTitle:kDefaultTitleAttributedString(@"The Return of The O'Mahony")
                                     message:kDefaultMessageAttributedString(@"ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.")
                                     preferredStyle:[self styleAtIndexPath:indexPath]];
    
    GYAlertAction *ok = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"动画结束后执行action") handler:^(GYAlertAction *action, NSInteger index){
        [self printAction:action atIndex:index];
        GYDetailViewController *controller = [[GYDetailViewController alloc] init];
        controller.title = @"GYDetailViewController";
        [self.navigationController pushViewController:controller animated:YES];
    }];
    ok.invokeHandlerAfterDismiss = YES; // 看这里
    [controller addAction:ok];
    controller.preferredWidth = 0.95;
    controller.cornerRadius = 10;
    GYAlertAction *cancel = [[GYAlertAction alloc] initWithTitle:nil
                                                   configuration:^(GYAlertControllerActionCell *actionCell)
                             {
                                 NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"cancel" attributes:@{NSForegroundColorAttributeName: UIColor.redColor}];
                                 actionCell.titleLabel.attributedText = text;
                                 actionCell.leftIconImgView.image = [UIImage imageNamed:@"zhifeiji"];
                             } handler:^(GYAlertAction *action, NSInteger index){
                             }];
    cancel.topMargin = 5.0;
    [controller addAction:cancel];
    controller.dismissOnBackgroundTapped = NO;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case8AtIndexPath:(NSIndexPath *)indexPath {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = UIColor.whiteColor;
    GYAlertController *controller = [GYAlertController alertControllerWithView:datePicker preferredStyle:GYAlertControllerStyleActionSheet animationStyle:GYAnimationControllerStyleRaiseBottom];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)case9AtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"The Return of The O'Mahony" message:@"ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it.ZEKE TISDALE was the father of Company F. Not that this title had ever been formally conferred upon him, or even recognized in terms, but everybody understood about it." preferredStyle:(UIAlertControllerStyle)[self styleAtIndexPath:indexPath]];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:ok];
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - assist

- (GYAlertControllerStyle)styleAtIndexPath:(NSIndexPath *)indexpath {
    GYTestCase *acase = self.dataSource[indexpath.row];
    return acase.alertStyle;
}

- (void)printAction:(GYAlertAction *)action atIndex:(NSInteger)index {
    NSLog(@"action<%@> title: %@, index: %ld", action, action.title.string, index);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell" forIndexPath:indexPath];
    GYTestCase *acase = _dataSource[indexPath.row];
    
    cell.textLabel.text = acase.title;
    cell.detailTextLabel.text = acase.message;
    UILabel *styleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    styleLabel.text = acase.styleDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GYTestCase *aCase = self.dataSource[indexPath.row];
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"case%ldAtIndexPath:", indexPath.row]);
    if ([self respondsToSelector:sel]) {
        ((void(*)(id, SEL, id))objc_msgSend)(self, sel, indexPath);
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // 改变弹出风格
    
    GYTestCase *acase = self.dataSource[indexPath.row];
    
    GYAlertController *controller = [GYAlertController alertControllerWithTitle:kDefaultTitleAttributedString(@"选择合适的弹出风格") message:nil preferredStyle:GYAlertControllerStyleActionSheet];
    
    GYAlertAction *action1 = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"ActionSheet") handler:^(GYAlertAction *action, NSInteger index){
        acase.alertStyle = GYAlertControllerStyleActionSheet;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    action1.invokeHandlerAfterDismiss = NO;
    [controller addAction:action1];
    
    GYAlertAction *action2 = [GYAlertAction defaultStyleActionWithTitle:kDefaultAlertAttributedString(@"Alert") handler:^(GYAlertAction *action, NSInteger index){
        acase.alertStyle = GYAlertControllerStyleAlert;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    action2.invokeHandlerAfterDismiss = NO;
    [controller addAction:action2];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)buildDataSource {
    _dataSource = [NSMutableArray array];
    NSArray<NSString *> *cases = @[
                                   @"01什么都没有😆",
                                   @"02只有标题",
                                   @"03只有消息",
                                   @"04只有actions",
                                   @"05标题和消息",
                                   @"06标题和actions",
                                   @"07消息和actions",
                                   @"08更灵活的了解下",
                                   @"09自定义视图",
                                   @"10系统风格"
                                   ];
    [cases enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GYTestCase *acase = [[GYTestCase alloc] initWithTitle:obj
                                                      message:[NSString stringWithFormat:@"请参考case%ld实现", idx]
                                                      actions:nil];
        [self.dataSource addObject:acase];
    }];
    
}

@end
