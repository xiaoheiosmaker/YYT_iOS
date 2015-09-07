//
//  NSString+TimeCategory.m
//  YYTHD
//
//  Created by IAN on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "NSString+TimeCategory.h"

@implementation NSString (TimeCategory)
+ (NSString *)stringWithTime:(NSTimeInterval)time {
    BOOL isPositive;
    NSInteger timeInt;
    
    if (time > 3600 * 24 || time < - 3600 * 24)
        return nil;
    if (time < 0) {
        timeInt = (NSInteger)-time;
        isPositive = NO;
    } else {
        timeInt = (NSInteger)time;
        isPositive = YES;
    }
    
    
    //int hour = (int)timeInt/3600;
    //int minute = (int)(timeInt%3600)/60;
    int hour = 0;
    int minute = (int)timeInt/60;
    int second = (int)(timeInt%3600)%60;
    
    if (hour > 0) {
        if (isPositive) {
            return [NSString stringWithFormat:@"%d%d:%d%d:%d%d",
                    hour/10, hour%10, minute/10, minute%10, second/10, second%10];
        } else {
            return [NSString stringWithFormat:@"-%d%d:%d%d:%d%d",
                    hour/10, hour%10, minute/10, minute%10, second/10, second%10];
        }
        
    } else {
        if (isPositive) {
            return [NSString stringWithFormat:@"%d%d:%d%d", minute/10, minute%10, second/10, second%10];
        } else {
            return [NSString stringWithFormat:@"-%d%d:%d%d", minute/10, minute%10, second/10, second%10];
        }
        
    }
}

- (NSTimeInterval)timeValue {
    NSInteger hour = 0, minute = 0, second = 0;
    NSArray *sections = [self componentsSeparatedByString:@":"];
    NSInteger count = [sections count];
    second = [[sections objectAtIndex:count - 1] integerValue];
    minute = [[sections objectAtIndex:count - 2] integerValue];
    if (count > 2) {
        hour = [[sections objectAtIndex:0] integerValue];
    }
    return hour * 3600 + minute * 60 + second;
}

@end
