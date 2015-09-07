//
//  StatisticManager.m
//  YYTHD
//
//  Created by 崔海成 on 12/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "StatisticManager.h"
#import "YYTClient.h"
#import "NSString+MD5Addition.h"

NSString * const ShareStatisticPath = @"share/statistics.json";
NSString * const DownloadStatisticPath = @"download/statistics.json";
NSString * const MVPlayStatisticPath = @"video/statistics.json";
NSString * const MLPlayStatisticPath = @"playlist/statistics.json";

NSString * const StatisticPlatformInfoKey = @"platform";
NSString * const StatisticContentTypeInfoKey = @"datatype";
NSString * const StatisticContentIDInfoKey = @"dataid";
NSString * const StatisticIDInfoKey = @"id";
NSString * const StatisticValidateInfoKey = @"s";
NSString * const StatisticProgressInfoKey = @"progress";

NSString * const StatisticPlatformSina = @"SINAWEIBO";
NSString * const StatisticPlatformQzone = @"QZONE";
NSString * const StatisticPlatformTencent = @"TENCENTWEIBO";
NSString * const StatisticPlatformWechat = @"WEIXIN";
NSString * const StatisticPlatformWechatTimeline = @"PENGYOUQUAN";
NSString * const StatisticPlatformRenren = @"RENREN";

NSString * const StatisticContentML = @"PLAYLIST";
NSString * const StatisticContentMV = @"VIDEO";

NSString * const PrivateKey = @"J7k$x*U5";

static NSMutableSet *autoOperations;

@implementation StatisticManager

+ (void)sendAutoStatisticToPath:(NSString *)path
                       userInfo:(NSDictionary *)userInfo
{
    AFHTTPRequestOperation * operation = [self sendStatisticToPath:path userInfo:userInfo completion:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            [autoOperations removeObject:operation];
            return;
        }
        if ([autoOperations containsObject:operation]) {
            [self sendResponse:operation userInfo:userInfo];
            [autoOperations removeObject:operation];
        }
        NSLog(@"autoOperations length: %d", [autoOperations count]);
    }];
    if (!autoOperations) {
        autoOperations = [NSMutableSet set];
    }
    [autoOperations addObject:operation];
}

+ (AFHTTPRequestOperation *)sendStatisticToPath:(NSString *)path
                                       userInfo:(NSDictionary *)userInfo
                                     completion:(void (^)(AFHTTPRequestOperation *, NSError *))completion
{
    [[YYTClient sharedInstance] postPath:path parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) completion(operation, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) completion(operation, error);
    }];
    
    NSOperationQueue *queue = [[YYTClient sharedInstance] operationQueue];
    int index = [queue operationCount] - 1;
    return [queue.operations objectAtIndex:index];
}

+ (NSString *)clientKeyFromServerKey:(NSString *)serverKey
{
    NSString *crypto = [[NSString stringWithFormat:@"%@%@", PrivateKey, serverKey] stringFromMD5];
    NSRange presix;
    presix.length = 6;
    presix.location = 0;
    NSString *clientKey = [NSString stringWithFormat:@"%@%@", crypto, [serverKey substringWithRange:presix]];
    return clientKey;
}

+ (void)sendResponse:(AFHTTPRequestOperation *)operation
            userInfo:(NSDictionary *)userInfo
{
    if (!operation) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"must pass operation" userInfo:nil];
        return;
    }
    NSError *error;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"send statistic error, in step 2 parse JSON fail");
        return;
    }
    if ([responseObject objectForKey:StatisticValidateInfoKey] == nil) {
        NSLog(@"send statistic error, in step 2 serverkey not found");
        return;
    }
    NSString *path = operation.request.URL.absoluteString;
    NSString *serverKey = [responseObject objectForKey:StatisticValidateInfoKey];
    NSString *clientKey = [self clientKeyFromServerKey:serverKey];
    NSMutableDictionary *newUserInfo = [userInfo mutableCopy];
    [newUserInfo setObject:clientKey forKey:StatisticValidateInfoKey];
    [self sendStatisticToPath:path userInfo:newUserInfo completion:nil];
}

@end
