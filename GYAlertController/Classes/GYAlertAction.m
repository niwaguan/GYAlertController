//
//  GYAlertAction.m
//  GYAlertController
//
//  Created by Gyang on 07/21/2018.
//  Copyright (c) 2018 Gyang. All rights reserved.
//

#import "GYAlertAction.h"

CGFloat const kDefaultAlertHeight = 44.0;
@interface GYAlertAction()
/// handler
@property (nonatomic, readwrite, copy) GYAlertActionHandler handler;
/// configuration
@property (nonatomic, readwrite, copy) GYAlertActionConfiguration configuration;
@end

@implementation GYAlertAction

+ (instancetype)defaultStyleActionWithTitle:(NSAttributedString *)title
                                    handler:(GYAlertActionHandler)handler {
    GYAlertAction *action = [[self alloc] initWithTitle:title configuration:nil handler:handler];
    return action;
}

- (instancetype)initWithTitle:(NSAttributedString *)title
                configuration:(GYAlertActionConfiguration)configuration
                      handler:(GYAlertActionHandler)handler {
    self = [super init];
    if (nil == self) return nil;
    _title = title.copy;
    _handler = [handler copy];
    _configuration = [configuration copy];
    [self setupDefaultValues];
    
    return self;
}

#pragma mark - assist

- (void)setupDefaultValues {
    _height = kDefaultAlertHeight;
    _controllerDismissOnHandlerInvoked = YES;
}

@end
