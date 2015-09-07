//
//  BaseAssistantController.m
//  YYTHD
//
//  Created by 崔海成 on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BaseAssistantController.h"

@implementation BaseAssistantController
- (UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}
@end
