//
//  UIColor+Tool.m
//  YYTHD
//
//  Created by IAN on 13-10-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "UIColor+Generator.h"

@implementation UIColor (Generator)

+ (UIColor *)colorWithHEXColor:(NSInteger)hex
{
    return [UIColor colorWithRed:((hex>>16)&0xFF)/255.0
                           green:((hex>>8)&0xFF)/255.0
                            blue:(hex&0xFF)/255.0
                           alpha:1.0];
}


+ (UIColor *)yytBackgroundColor
{
    return [self colorWithHEXColor:0xf0f0f0];
}

+ (UIColor *)yytDarkGrayColor
{
    return [self colorWithHEXColor:0x555555];
}

+ (UIColor *)yytGrayColor
{
    return [self colorWithHEXColor:0xa9a6a6];
}

+ (UIColor *)yytLightGrayColor
{
    return [self colorWithHEXColor:0xb7b7b7];
}

+ (UIColor *)yytGreenColor
{
    return [self colorWithHEXColor:0x0fc584];
}

+ (UIColor *)yytTextViewColor
{
    return [self colorWithHEXColor:0xa9a6a6];
}

+ (UIColor *)yytTransparentBlackColor
{
    return [UIColor colorWithWhite:0 alpha:0.9];
}

+ (UIColor *)yytLineColor
{
    return [self colorWithHEXColor:0xe0e0e0];
}

@end
