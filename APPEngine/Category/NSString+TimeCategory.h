//
//  NSString+TimeCategory.h
//  YYTHD
//
//  Created by IAN on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeCategory)

+ (NSString *)stringWithTime:(NSTimeInterval)time;
- (NSTimeInterval)timeValue;

@end
