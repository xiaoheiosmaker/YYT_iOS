//
//  SysSupport.h
//  KSApp
//
//  Created by kenshin on 13-8-18.
//  Copyright (c) 2013年 kenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSupport : NSObject


+ (SystemSupport *)sharedSystemSupport;

- (NSDateFormatter *)dateFormatterYMD;
- (NSDateFormatter *)dateFormatterYMD_CH;
- (NSDateFormatter *)dateFormatterYMDHMS;


+(NSString *)currentDateTime;
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)dateTimeYMD:(int)seconds;
+(NSString *)dateTimeYMD_CH:(int)seconds;
+(NSString *)dateTimeYMDHMS:(int)seconds;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
//系统版本是否为ios7之前的版本
+ (BOOL)versionPriorTo7;

+ (BOOL)isRetina;

@end
