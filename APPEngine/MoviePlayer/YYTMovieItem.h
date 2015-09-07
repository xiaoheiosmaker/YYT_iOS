//
//  YYTMovieItem.h
//  YYTHD
//
//  Created by IAN on 13-12-9.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM (NSInteger, YYTMovieQuality) {
    YYTMovieQualityDefault,
    YYTMovieQualityHD,
    YYTMovieQualityUHD,
    YYTMovieQualityNotAvailable,
};

typedef NS_ENUM(NSInteger, YYTMovieRepeatMode) {
    YYTMovieRepeatModeNone = MPMovieRepeatModeNone,
    YYTMovieRepeatModeOne = MPMovieRepeatModeOne,
    YYTMovieRepeatModeAll,
};

typedef enum : NSUInteger {
    YYTMoviePlayOrderRepeatOne,     //单曲循环
    YYTMoviePlayOrderRepeatAll,     //列表循环
    YYTMoviePlayOrderNone,          //顺序播放
    YYTMoviePlayOrderShuffle,       //随机播放
} YYTMoviePlayOrder;

@protocol YYTMovieItem <NSObject>

- (NSURL *)movieURLForQuality:(YYTMovieQuality)quality;
- (NSNumber *)movieID;
- (NSString *)title;

@optional
- (NSURL *)anyURLForQuality:(YYTMovieQuality *)quality;

@end
