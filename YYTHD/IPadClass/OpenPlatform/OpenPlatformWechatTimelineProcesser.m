//
//  OpenPlatformWechatTimelineProcesser.m
//  YYTHD
//
//  Created by 崔海成 on 11/8/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "OpenPlatformWechatTimelineProcesser.h"

@implementation OpenPlatformWechatTimelineProcesser

- (NSString *)openPlatformTitle
{
    return OPTitleWechatTimeline;
}

- (NSString *)createSWFURLForMLID:(NSNumber *)keyID
{
    return [ShareAssistantController playlistSWFURLWithID:keyID];
}

- (NSString *)createURLForMLID:(NSNumber *)keyID
{
    return [ShareAssistantController playlistURLForWechatTimeline:keyID];
}

- (NSString *)createSWFURLForMVID:(NSNumber *)keyID
{
    return [ShareAssistantController videoSWFURLWithID:keyID];
}

- (NSString *)createURLForMVID:(NSNumber *)keyID
{
    return [ShareAssistantController videoURLForWechatTimeline:keyID];
}

@end
