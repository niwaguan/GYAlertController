//
//  GYTestCase.m
//  GYAlertControllerDemo
//
//  Created by 高洋 on 2018/7/19.
//  Copyright © 2018年 Gyang. All rights reserved.
//

#import "GYTestCase.h"

@implementation GYTestCaseAction
- (instancetype)initWithTitle:(NSString *)title
                 leftIconName:(NSString *)leftIconName
                rightIconName:(NSString *)rightIconName {
    self = [super init];
    if (nil == self) return nil;
    self.title = title;
    self.leftIconName = leftIconName;
    self.rightIconName = rightIconName;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    GYTestCaseAction *tmp = [[[self class] alloc] initWithTitle:_title leftIconName:_leftIconName rightIconName:_rightIconName];
    return tmp;
}

@end

@implementation GYTestCase

- (instancetype)initWithTitle:(NSString * _Nullable)title
                      message:(NSString * _Nullable)message
                 actions:(NSArray<GYTestCaseAction *> * _Nullable)acitonTitles {
    self = [super init];
    if (nil == self) return nil;
    
    self.title = title;
    self.message = message;
    self.actions = acitonTitles;
    self.dismissOnBackgroundTapped = YES;
    self.preferredWidth = 0;
    self.preferredHeight = 0;
    return self;
}

@end
