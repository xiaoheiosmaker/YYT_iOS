//
//  MVItem.h
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/9/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTMovieItem.h"

typedef enum {
    UNVideoHD     = 0,//标清
    VideoHD       = 1,//高清
    VideoSHD      = 2,//超清
}VideoType;

@interface MVItem : MTLModel <MTLJSONSerializing, YYTMovieItem>
@property (nonatomic, strong, readonly) NSNumber *keyID;
@property (nonatomic,copy, readonly) NSString *title;
@property (nonatomic,copy, readonly) NSString *artistName;
@property (nonatomic, copy, readonly) NSString *describ;
@property (nonatomic, readonly) NSString *desc;

- (NSURL *)coverImageURL;
- (NSURL *)largeImageURL;

@property (nonatomic, readonly)NSArray *artists;
@property (nonatomic, readonly)NSNumber *duration;
@property (nonatomic, readonly) NSNumber *totalViews;
@property (nonatomic, readonly) NSNumber *totalComments;

//本地地址
@property (nonatomic,strong) NSString *localPath;

#pragma mark - mvDetail (专用)
@property (nonatomic, strong, readonly) NSArray *relatedVideos;

#pragma mark - artist Order (专用)
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *source;

- (NSNumber *)videoSizeForQuality:(YYTMovieQuality)quality;

- (VideoType)videoType;

- (NSString *)getVidepDuration;

@end
