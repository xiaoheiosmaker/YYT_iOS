//
//  StatisticManager.h
//  YYTHD
//
//  Created by 崔海成 on 12/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ShareStatisticPath;
extern NSString * const DownloadStatisticPath;
extern NSString * const MVPlayStatisticPath;
extern NSString * const MLPlayStatisticPath;

extern NSString * const StatisticPlatformInfoKey;
extern NSString * const StatisticContentTypeInfoKey;
extern NSString * const StatisticContentIDInfoKey; // 分享统计专用
extern NSString * const StatisticIDInfoKey;
extern NSString * const StatisticValidateInfoKey;
extern NSString * const StatisticProgressInfoKey;

extern NSString * const StatisticPlatformSina;
extern NSString * const StatisticPlatformQzone;
extern NSString * const StatisticPlatformTencent;
extern NSString * const StatisticPlatformRenren;
extern NSString * const StatisticPlatformWechat;
extern NSString * const StatisticPlatformWechatTimeline;

extern NSString * const StatisticContentML;
extern NSString * const StatisticContentMV;

@interface StatisticManager : NSObject
+ (void)sendAutoStatisticToPath:(NSString *)path
                       userInfo:(NSDictionary *)userInfo;

+ (AFHTTPRequestOperation *)sendStatisticToPath:(NSString *)path
                                       userInfo:(NSDictionary *)userInfo
                                     completion:(void (^)(AFHTTPRequestOperation *operation, NSError *error))completion;

+ (void)sendResponse:(AFHTTPRequestOperation *)operation
            userInfo:(NSDictionary *)userInfo;
@end
