//
//  PushDataItem.h
//  YYTHD
//
//  Created by ssj on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface PushDataItem : MTLModel<MTLJSONSerializing>
@property (strong,nonatomic,readonly) NSString *area;
@property (strong,nonatomic,readonly) NSString *keyId;
@property (strong,nonatomic,readonly) NSURL *traceUrl;
@property (strong,nonatomic,readonly) NSURL *clickUrl;
@property (strong,nonatomic,readonly) NSURL *playUrl;
@property (strong,nonatomic,readonly) NSString *autoPlay;
@property (strong,nonatomic,readonly) NSString *datecode;
@property (strong,nonatomic,readonly) NSString *unreadCount;
@property (strong,nonatomic,readonly) NSString *userId;
@property (strong,nonatomic,readonly) NSString *videoId;
@end
