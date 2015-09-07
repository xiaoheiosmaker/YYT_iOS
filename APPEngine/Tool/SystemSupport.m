//
//  SysSupport.m
//  KSApp
//
//  Created by kenshin on 13-8-18.
//  Copyright (c) 2013年 kenshin. All rights reserved.
//

#import "SystemSupport.h"
#import "SINGLETONGCD.h"
#import <QuartzCore/QuartzCore.h>

static BOOL VersionPriorTo7 = NO;
static BOOL IsRetina = NO;

@implementation SystemSupport
{
    //反复init NSDateFormatter开销太大，故重用之
    NSDateFormatter *_dateFormatterYMD;
    NSDateFormatter *_dateFormatterYMD_CH;
    NSDateFormatter *_dateFormatterYMDHMS;
    

}
SINGLETON_GCD(SystemSupport);

+ (void)initialize
{
    NSString *versionStr = [[UIDevice currentDevice] systemVersion];
    VersionPriorTo7 = ([versionStr intValue] < 7);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    IsRetina = (scale > 1.0);
}


#pragma mark - Date
- (NSDateFormatter *)dateFormatterYMD {
    if (! _dateFormatterYMD) {
        _dateFormatterYMD = [[NSDateFormatter alloc] init];
        [_dateFormatterYMD setTimeZone:[NSTimeZone localTimeZone]];
        [_dateFormatterYMD setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatterYMD;
}

- (NSDateFormatter *)dateFormatterYMD_CH {
    if (! _dateFormatterYMD_CH) {
        _dateFormatterYMD_CH = [[NSDateFormatter alloc] init];
        [_dateFormatterYMD_CH setTimeZone:[NSTimeZone localTimeZone]];
        [_dateFormatterYMD_CH setDateFormat:@"yyyy年MM月dd日"];
    }
    return _dateFormatterYMD_CH;
}

- (NSDateFormatter *)dateFormatterYMDHMS {
    if (! _dateFormatterYMDHMS) {
        _dateFormatterYMDHMS = [[NSDateFormatter alloc] init];
        [_dateFormatterYMDHMS setTimeZone:[NSTimeZone localTimeZone]];
        [_dateFormatterYMDHMS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatterYMDHMS;
}


+(NSString *)currentDateTime{
	NSDate *date = [NSDate date];
	NSString *timeString = [[[SystemSupport sharedSystemSupport] dateFormatterYMDHMS] stringFromDate:date];
	return timeString;
}

+(NSString *)dateTimeYMD:(int)seconds{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSString *timeString = [[[SystemSupport sharedSystemSupport] dateFormatterYMD] stringFromDate:date];
	return timeString;
}

+(NSString *)dateTimeYMD_CH:(int)seconds{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSString *timeString = [[[SystemSupport sharedSystemSupport] dateFormatterYMD_CH] stringFromDate:date];
	return timeString;
}

+(NSString *)dateTimeYMDHMS:(int)seconds{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSString *timeString = [[[SystemSupport sharedSystemSupport] dateFormatterYMDHMS] stringFromDate:date];
    return timeString;
}

+(NSDate *)dateFromString:(NSString *)dateString{
	NSDate *date = [[[SystemSupport sharedSystemSupport] dateFormatterYMDHMS] dateFromString:dateString];
    return date;
}

+ (BOOL)versionPriorTo7
{
    return VersionPriorTo7;
}


+ (BOOL)isRetina
{
    return IsRetina;
}

#include <sys/xattr.h>
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
