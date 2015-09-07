//
//  MVChannel.h
//  YYTHD
//
//  Created by IAN on 13-10-12.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVChannel : MTLModel <MTLJSONSerializing>

@property(nonatomic, readonly)NSNumber *channelID;
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)NSURL *coverURL;

@property(nonatomic, readonly)BOOL subscribed; //用户是否已经订阅

@property(nonatomic, readonly)NSNumber *order;  //服务器排序
@property(nonatomic, readonly)NSNumber *userOrder; //用户排序

- (NSString *)keyWord; //频道搜索关键字，用于回传服务器

//改变频道订阅状态
- (void)subscribeWithUserOrder:(NSNumber *)order;
- (void)unSubscribe;

@end
