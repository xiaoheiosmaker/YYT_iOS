//
//  NSError+YYTError.m
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "NSError+YYTError.h"

NSString * const YYTErrorDomain = @"YYTErrorDomain";

NSInteger const YYTErrorNotLogin = 400;

NSInteger const YYTErrorLoginFailure = 601;
NSInteger const YYTErrorOperFailure = 600;

NSInteger const YYTErrorAddFavoriteFailure = 1000;
NSInteger const YYTErrorAddMVToMLFailure = 1200;

NSInteger const YYTErrorPlayStatusProblem = 501;

@implementation NSError (YYTError)

+ (NSError *)yytErrorWithErrorCode:(NSInteger)code userInfo:(NSDictionary *)info
{
    return [NSError errorWithDomain:YYTErrorDomain code:code userInfo:info];
}

+ (NSError *)yytNotLoginError
{
    NSDictionary *info = @{NSLocalizedDescriptionKey: @"未登录"};
    return [self yytErrorWithErrorCode:YYTErrorNotLogin userInfo:info];
}

+ (NSError *)yytLoginFailureError
{
    NSDictionary *info = @{NSLocalizedDescriptionKey: @"您输入的账号或密码错误"};
    return [self yytErrorWithErrorCode:YYTErrorLoginFailure userInfo:info];
}

+ (NSError *)yytOperErrorWithMessage:(NSString *)message
{
    NSDictionary *info = @{NSLocalizedDescriptionKey: message};
    return [self yytErrorWithErrorCode:YYTErrorOperFailure userInfo:info];
}
+ (NSError *)yytAddFavoriteMLFailureError
{
    NSDictionary *info = @{NSLocalizedDescriptionKey: @"收藏悦单失败"};
    return [self yytErrorWithErrorCode:YYTErrorAddFavoriteFailure userInfo:info];
}

+ (NSError *)yytAddMVToMLFailureError
{
    NSDictionary *info = @{NSLocalizedDescriptionKey: @"添加到悦单失败"};
    return [self yytErrorWithErrorCode:YYTErrorAddMVToMLFailure userInfo:info];
}


/*
 "display_message" = "\U8bf7\U767b\U5f55\U540e\U8fdb\U884c\U64cd\U4f5c";
 error = "Not login";
 "error_code" = 20006;
 request = "/box/subscribe/me.json";
 */
+ (NSError *)yytSeverErrorWithJSON:(NSDictionary *)jsonDic
{
    NSString *message = jsonDic[@"display_message"];
    NSNumber *errorCode = jsonDic[@"error_code"];
    NSString *error = jsonDic[@"error"];
    NSString *path = jsonDic[@"request"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    [userInfo setValue:error forKey:NSLocalizedFailureReasonErrorKey];
    [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:path forKey:NSURLErrorFailingURLStringErrorKey];
    
    return [self yytErrorWithErrorCode:[errorCode integerValue] userInfo:userInfo];
}

- (NSString *)yytErrorMessage
{
    if ([self.domain isEqualToString:YYTErrorDomain]) {
        return self.localizedDescription;
    }
    else if ([self.domain isEqualToString:AFNetworkingErrorDomain]) {
        NSDictionary *userInfo = self.userInfo;
        NSString *suggestion = [userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
        NSError *parseErr = nil;
        NSDictionary *newSuggestion = [NSJSONSerialization JSONObjectWithData:[suggestion dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&parseErr];
        if (parseErr) {
            return self.localizedDescription;
        }
        return [newSuggestion objectForKey:@"display_message"];
    }
    else if ([self.domain isEqualToString:NSURLErrorDomain]) {
        NSString *message = [self URLErrorMessage];
        return message;
    }
    else {
        //以前的代码，domain是中文
        unichar ch = [self.domain characterAtIndex:0];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            return self.domain;
        }
    }
    
    return self.localizedDescription;
}

- (NSString *)URLErrorMessage
{
    NSString *message = nil;
    switch (self.code) {
        case kCFURLErrorTimedOut:
            message = @"请求超时，请检查您的网络连接";
            break;
        case kCFURLErrorCannotConnectToHost:
            message = @"无法连接服务器";
            break;
        case kCFURLErrorNotConnectedToInternet:
            message = @"无法连接到网络";
            break;
        default:
            message = [NSString stringWithFormat:@"网络错误：%d",(int)self.code];
            break;
    }
    
    return message;
}

@end
