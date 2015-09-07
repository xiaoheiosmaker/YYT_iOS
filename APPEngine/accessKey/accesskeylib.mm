//
//  accesskeylib.m
//  accesskeylib
//
//  Created by Mac on 13-7-10.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import "accesskeylib.h"
#import "SecurityChain.h"
#import "AppDelegateHelper.h"
#include <string>
@implementation accesskeylib

+(NSString *)getAccessKeyUrl:(NSString *)fullUrl{
    
    NSDate *nowDate= [NSDate date];
    int timeInterval = [nowDate timeIntervalSince1970];
    int second = [AppDelegateHelper serverTime];
    int unsignHour = (timeInterval + second)/3600;
    int signHour= (timeInterval+second)%3600>0?1:0;
    int hour =unsignHour+signHour;
    NSString *accessKeyUrl = [self getAccessKeyUrl:fullUrl :[NSString stringWithFormat:@"%d",hour]];
    return accessKeyUrl;
}

//getAccessKeyUrl
+(NSString *)getAccessKeyUrl:(NSString *)fullUrl  :(NSString *)hourStr
{
    
    NSRange question_sc_range = NSMakeRange(0, 0);
    question_sc_range = [fullUrl rangeOfString:@"?sc="];
    
    NSRange and_sc_range = NSMakeRange(0, 0);
    and_sc_range = [fullUrl rangeOfString:@"&sc="];
    
    if (question_sc_range.length>0) {
        
        NSString *accessKey = [self getAccessKey:fullUrl :hourStr];
        if ([self isExist:accessKey]) {
            NSString *sc_and_accesskey = [NSString stringWithFormat:@"?sc=%@",accessKey];
            NSString* accesskeyUrl = [fullUrl stringByReplacingCharactersInRange:NSMakeRange(question_sc_range.location, question_sc_range.length+16) withString:sc_and_accesskey];
            return accesskeyUrl;
        }else{
            return fullUrl;
        }
        
    }else if (and_sc_range.length >0){
        NSString *accessKey = [self getAccessKey:fullUrl :hourStr];
        if ([self isExist:accessKey]) {
            
            NSString *sc_and_accesskey = [NSString stringWithFormat:@"?sc=%@",accessKey];
            NSString* accesskeyUrl = [fullUrl stringByReplacingCharactersInRange:NSMakeRange(and_sc_range.location, and_sc_range.length+16) withString:sc_and_accesskey];
            return accesskeyUrl;
        }else{
            return fullUrl;
        }
    }
    else{
        return fullUrl;
    }
}

// get accesskey
+(NSString *)getAccessKey:(NSString *)fullUrl  :(NSString *)hourStr{
    NSString *fileName = [self getFileNameString:fullUrl];
    NSString *accessKey = @"";
    if ([self isExist:fileName]) {
        std::string *fileNamestdString = new std::string([fileName UTF8String]);
        std::string *hourStrstdString = new std::string([hourStr UTF8String]);
        accessKey= [NSString stringWithCString:get_security_chain("yinyuetai", *fileNamestdString, *hourStrstdString).c_str() encoding:[NSString defaultCStringEncoding]];
    }
    return accessKey;
}



//get short url
+(NSString *)getShortUrlString:(NSString *)fullUrlString{
    
    NSString *httpString = [self getHttpUrl:fullUrlString];
    NSRange range = [fullUrlString rangeOfString:httpString];
    NSRange question_range = NSMakeRange(0, 0);
    question_range = [fullUrlString rangeOfString:@"?"];
    
    int question_location = question_range.location;
    if (question_range.length <1) {
        question_location = fullUrlString.length;
    }
    
    NSString *shortUrlString = [fullUrlString substringWithRange:NSMakeRange(range.location+range.length,question_location-(range.location+range.length))];
    
    return shortUrlString;
}


//获取文件名
+(NSString *)getFileNameString:(NSString *)fullUrlString{
    NSRange question_range = NSMakeRange(0, 0);
    question_range = [fullUrlString rangeOfString:@"?"];
    
    int question_location = question_range.location;
    if (question_range.length <1) {
        question_location = fullUrlString.length;
        return @"";
    }
    
    NSString *shortUrlString = [fullUrlString substringWithRange:NSMakeRange(0,question_location)];
    std::string str_c = [shortUrlString cStringUsingEncoding:[NSString defaultCStringEncoding]];
    if (str_c.find_last_of('/') > str_c.find_last_of('.') )
    {
        return @"";
    }
    size_t length = str_c.find_last_of('.') - str_c.find_last_of('/') - 1;
    std::string str_o = str_c.substr(str_c.find_last_of('/')+1, length);
    NSString *fileName = [NSString stringWithCString:str_o.c_str() encoding:[NSString defaultCStringEncoding]];
    return [NSString stringWithFormat:@"_%@_",fileName];
}



//get http url
+(NSString *)getHttpUrl:(NSString *)fullUrlString{
    NSString *string = fullUrlString;
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^http://[^/]+"
                                  options:0
                                  error:&error];
    NSRange range   = [regex rangeOfFirstMatchInString:string
                                               options:0
                                                 range:NSMakeRange(0, [string length])];
    NSString *result = [string substringWithRange:range];
    return result;
}

+(BOOL)isExist:(NSString *)url
{
    if (self == nil) {
        
        return NO;
        
    }
    
    if (self == NULL) {
        
        return NO;
        
    }
    
    if ([url isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if ([[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return NO;
        
    }
    
    return YES;
}

@end
