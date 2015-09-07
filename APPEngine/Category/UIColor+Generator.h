//
//  UIColor+Tool.h
//  YYTHD
//
//  Created by IAN on 13-10-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Generator)

+ (UIColor *)colorWithHEXColor:(NSInteger)hex;

/**
 *  背景色 f0f0f0
 *
 *  @return f0f0f0
 */
+ (UIColor *)yytBackgroundColor;

/**
 *  深灰色字体颜色 555555
 *
 *  @return 555555
 */
+ (UIColor *)yytDarkGrayColor;

/**
 * 灰色 a9a6a6
 *
 * @return a9a6a6
 */
+ (UIColor *)yytGrayColor;

/**
 *  浅灰色字体颜色 b7b7b7
 *
 *  @return b7b7b7
 */
+ (UIColor *)yytLightGrayColor;

/**
 *  绿色 0fc584
 *
 *  @return 0fc584
 */
+ (UIColor *)yytGreenColor;

/**
 *  v榜描述字体颜色 0xa9a6a6
 *
 *  @return 0xa9a6a6
 */
+ (UIColor *)yytTextViewColor;

/**
 *  透明黑色 white:0 alpha:0.9
 *
 *  @return white:0 alpha:0.9
 */
+ (UIColor *)yytTransparentBlackColor;

/**
 *  分割线的颜色 0xe0e0e0
 *
 *  @return 0xe0e0e0
 */
+ (UIColor *)yytLineColor;

@end
