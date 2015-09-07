//
//  YYTMoviePlayerController.h
//  YYTHD
//
//  Created by IAN on 13-12-9.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "YYTMovieItem.h"

extern NSString * const YYTMoviePlayerPlayingQualityDidChangeNotificaiton;
extern NSString * const YYTMoviePlayerTimedOutStateDidChangeNotificaiton;
extern NSString * const YYTMoviePlayerLoadingCautionNotificaiton;

@interface YYTMoviePlayerController : MPMoviePlayerController

/**
 *  当前播放列表
 */
- (void)setMoviePlayListWithMovieItems:(NSArray *)movieItems;
- (NSArray *)movieItems;
- (NSUInteger)movieItemsCount;

/**
 *  当前播放的视频索引
 */
@property (nonatomic, readonly) NSInteger currentIndex;

/**
 *  播放指定index的视频
 *
 *  @param index 视频索引
 */
- (void)playMovieAtIndex:(NSInteger)index;

/**
 *  当前播放的视频，若当前不在播放状态，则为运行play方法之后播放的视频
 *
 *  @return 当前播放的MovieItem
 */
- (id<YYTMovieItem>)playingMovieItem;

/**
 *  首选清晰度
 */
@property (nonatomic, assign) YYTMovieQuality preferredQuality;

/**
 *  当前播放清晰度
 */
@property (nonatomic, readonly) YYTMovieQuality playingQuality;

/**
 *  重复模式
 */
@property (nonatomic, assign) YYTMovieRepeatMode yytRepeatMode;

/**
 *  是否为乱序播放
 */
@property (nonatomic, assign) BOOL shuffle;

/**
 *  播放下一首
 */
- (void)playNext;

/**
 *  播放上一首
 */
- (void)playPrev;

/**
 *  是否已经超时
 */
@property (nonatomic, readonly) BOOL timedOut;

@end
