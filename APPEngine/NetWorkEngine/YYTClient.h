//
//  YYTClient.h
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/8/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

typedef void (^KSFailureBlock)  (AFHTTPRequestOperation *operation, NSError *error);


@interface YYTClient : AFHTTPClient


@property (nonatomic, assign) BOOL useCacheOnly;

+(YYTClient *)sharedInstance;


// 覆盖requestWithMethod，设置超时时间  虽然原作者不鼓励这么做
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters;


- (void)requestTableDataWithParams:(NSDictionary *)dict
                              path:(NSString *)path
                           success:(KSFinishedBlock)success
                           failure:(KSFailureBlock)failure;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id content, id responseObject))success
        failure:(void (^)(id content, NSError *error))failure;

@end
