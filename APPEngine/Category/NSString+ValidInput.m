//
//  NSString+ValidInput.m
//  YYTHD
//
//  Created by 崔海成 on 2/18/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "NSString+ValidInput.h"

static NSRegularExpression *regextestmobile;
static NSRegularExpression *regextestcm;
static NSRegularExpression *regextestcu;
static NSRegularExpression *regextestct;

static NSPredicate *regextextemail;

@implementation NSString (ValidInput)

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (!regextestmobile)
    {
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSError *err;
        regextestmobile = [NSRegularExpression regularExpressionWithPattern:MOBILE options:0 error:&err];
        regextestcm = [NSRegularExpression regularExpressionWithPattern:CM options:0 error:&err];
        regextestcu = [NSRegularExpression regularExpressionWithPattern:CU options:0 error:&err];
        regextestct = [NSRegularExpression regularExpressionWithPattern:CT options:0 error:&err];
    }
    NSRange range = NSMakeRange(0, [mobileNum length]);
    NSArray *matchesResults = [regextestmobile matchesInString:mobileNum options:0 range:range];
    if (matchesResults != nil && [matchesResults count] > 0) return YES;
    matchesResults = [regextestcm matchesInString:mobileNum options:0 range:range];
    if (matchesResults != nil && [matchesResults count] > 0) return YES;
    matchesResults = [regextestcu matchesInString:mobileNum options:0 range:range];
    if (matchesResults != nil && [matchesResults count] > 0) return YES;
    matchesResults = [regextestct matchesInString:mobileNum options:0 range:range];
    if (matchesResults != nil && [matchesResults count] > 0) return YES;
    
    return NO;
}

- (BOOL)isValidPhone
{
    return [self isMobileNumber:self];
}

- (BOOL)isValidEmail
{
    if (!regextextemail)
    {
        regextextemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    }
    return [regextextemail evaluateWithObject:self];
}

- (BOOL)isValidPassword
{
    NSInteger length = [self length];
    if (length < 4 || length > 20) {
        return NO;
    }
    else {
        return YES;
    }
}
@end
