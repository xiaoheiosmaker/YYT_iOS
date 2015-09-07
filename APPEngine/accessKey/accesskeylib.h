//
//  accesskeylib.h
//  accesskeylib
//
//  Created by Mac on 13-7-10.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface accesskeylib : NSObject
+(NSString *)getAccessKeyUrl:(NSString *)fullUrl  :(NSString *)hourStr;
+(NSString *)getAccessKeyUrl:(NSString *)fullUrl;
+(NSString *)getFileNameString:(NSString *)fullUrlString;
@end
