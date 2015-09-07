//
//  AppHelper.h
//  YYTHD
//
//  Created by IAN on 13-11-5.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDelegateHelper : NSObject

/**
 *  在程序启动时为应用加载数据
 */
+ (void)prepareDataForAppLaunching;

/**
 *  释放单例资源
 */
+ (void)releaseSharedResources;

/**
 *  程序退出时保存应用程序的状态
 */
+ (void)saveAppState;

/**
 *  恢复数据
 */
+ (void)recoverDataForAppAwake;

+ (NSTimeInterval)serverTime;

+ (void)setRootViewController:(UIViewController *)rootViewController;
+ (UIViewController *)rootViewController;

/**
 *  第一次进入应用，显示新手引导
 */
+ (void)showUserGuideIfNeed;

@end
