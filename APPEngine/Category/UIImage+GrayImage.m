//
//  UIImage+GrayImage.m
//  YYTHD
//
//  Created by IAN on 13-12-3.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "UIImage+GrayImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (GrayImage)

- (UIImage*)getGrayImage
{
    UIImage *sourceImage = self;
    
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

@end
