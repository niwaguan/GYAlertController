//
//  GYTestCase.h
//  GYAlertControllerDemo
//
//  Created by 高洋 on 2018/7/19.
//  Copyright © 2018年 Gyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYTestCaseAction : NSObject <NSCopying>

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *leftIconName;
@property (nonatomic, readwrite, copy) NSString *rightIconName;

@property (nonatomic, readwrite, assign) NSInteger layoutStrategy;

@property (nonatomic, readwrite, assign) BOOL invokeAfterDismiss;

- (instancetype)initWithTitle:(NSString *)title
                 leftIconName:(NSString *)leftIconName
                rightIconName:(NSString *)rightIconName;

@end

@interface GYTestCase : NSObject

@property (nonatomic, readwrite, assign) BOOL dismissOnBackgroundTapped;
@property (nonatomic, readwrite, assign) float preferredHeight;
@property (nonatomic, readwrite, assign) float preferredWidth;
@property (nonatomic, readwrite, assign) NSInteger preferredStyle;
@property (nonatomic, readwrite, assign) NSInteger alertStyle;
@property (nonatomic, readonly, strong) NSString *styleDescription;

@property (nonatomic, nullable, readwrite, copy) NSString *title;
@property (nonatomic, nullable, readwrite, copy) NSString *message;
@property (nonatomic, nullable, readwrite, copy) NSArray<GYTestCaseAction *> *actions;

- (instancetype)initWithTitle:(NSString * _Nullable)title
                      message:(NSString * _Nullable)message
                 actions:(NSArray<GYTestCaseAction *> * _Nullable)actions;

@end
