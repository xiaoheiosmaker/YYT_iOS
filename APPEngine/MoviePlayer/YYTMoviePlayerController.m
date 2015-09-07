//
//  YYTMoviePlayerController.m
//  YYTHD
//
//  Created by IAN on 13-12-9.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTMoviePlayerController.h"
#import "YYTMoviePlayList.h"

NSString * const YYTMoviePlayerPlayingQualityDidChangeNotificaiton = @"YYTMoviePlayerPlayingQualityDidChanged";
NSString * const YYTMoviePlayerTimedOutStateDidChangeNotificaiton = @"YYTMoviePlayerTimedOutNotificaiton";
NSString * const YYTMoviePlayerLoadingCautionNotificaiton = @"YYTMoviePlayerLoadingCautionNotificaiton";

NSTimeInterval const YYTMovieLoadLimitedTime = 90;
NSTimeInterval const YYTMovieLoadCautionTime = 30;

@interface YYTMoviePlayerController ()
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong) YYTMoviePlayList *playList;
@property (nonatomic, readwrite) YYTMovieQuality playingQuality;
@property (nonatomic, readwrite) BOOL timedOut;
@property (nonatomic, assign) NSTimeInterval startTime;

@end

@implementation YYTMoviePlayerController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
        _preferredQuality = [self getSavedPreferredQuality];
        self.controlStyle = MPMovieControlStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:self];
    }
    return self;
}

- (void)play
{
    if (!self.contentURL) {
        [self setContentURLWithIndex:self.currentIndex];
    }
    
    [super play];
    
    if (self.loadState & MPMovieLoadStatePlaythroughOK) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
        [self performSelector:@selector(movieTimedOut) withObject:nil afterDelay:YYTMovieLoadLimitedTime];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieLoadingCaution) object:nil];
        [self performSelector:@selector(movieLoadingCaution) withObject:nil afterDelay:YYTMovieLoadCautionTime];
    }
}


- (void)replay
{
    [self stop];
    [self play];
}


- (void)playPrev
{
    NSInteger index = [self prevIndex];
    if (index != NSNotFound) {
        [self setContentURLWithIndex:index];
        [self play];
    }
}

- (void)playNext
{
    NSInteger index = [self nextIndex];
    if (index != NSNotFound) {
        [self setContentURLWithIndex:index];
        [self play];
    }
}

- (void)stop
{
    [self reset];
    [super stop];
}

- (void)setMoviePlayListWithMovieItems:(NSArray *)movieItems
{
    YYTMoviePlayList *playList = [[YYTMoviePlayList alloc] initWithMoiveItems:movieItems];
    [self stop];
    self.playList = playList;
}

- (NSArray *)movieItems
{
    return [self.playList movieItems];
}

- (NSUInteger)movieItemsCount
{
    return self.playList.count;
}

- (id<YYTMovieItem>)playingMovieItem
{
    id<YYTMovieItem> item = [self.playList movieItemAtIndex:self.currentIndex];
    return item;
}

- (void)playMovieAtIndex:(NSInteger)index
{
    [self setContentURLWithIndex:index];
    [self play];
    
    if (self.shuffle) {
        [self.playList shufflePlayList:YES withHeaderIndex:index];
    }
}

#pragma mark - Getter
- (NSInteger)currentIndex
{
    if (_currentIndex < 0) {
        return 0;
    }
    
    return _currentIndex;
}


#pragma mark - Setter
- (void)setPreferredQuality:(YYTMovieQuality)preferredQuality
{
    if (_preferredQuality!=preferredQuality && preferredQuality!=YYTMovieQualityNotAvailable) {
        _preferredQuality = preferredQuality;
        [self savePreferredQuality];
        if (_preferredQuality != self.playingQuality) {
            NSTimeInterval time = self.currentPlaybackTime;
            BOOL isPlaying = (self.playbackState == MPMoviePlaybackStatePlaying);
            [self setContentURLWithIndex:self.currentIndex initialPlaybackTime:time];
            if (isPlaying) {
                [self play];
            }
        }
    }
}

- (void)setPlayingQuality:(YYTMovieQuality)playingQuality
{
    if (_playingQuality != playingQuality) {
        _playingQuality = playingQuality;
        [[NSNotificationCenter defaultCenter] postNotificationName:YYTMoviePlayerPlayingQualityDidChangeNotificaiton object:self];
    }
}

- (void)setYytRepeatMode:(YYTMovieRepeatMode)yytRepeatMode
{
    if (_yytRepeatMode != yytRepeatMode) {
        _yytRepeatMode = yytRepeatMode;
        if (yytRepeatMode == YYTMovieRepeatModeOne) {
            self.repeatMode = MPMovieRepeatModeOne;
        }
        else {
            self.repeatMode = MPMovieRepeatModeNone;
        }
    }
}

- (void)setShuffle:(BOOL)shuffle
{
    if (_shuffle != shuffle) {
        _shuffle = shuffle;
        [self.playList shufflePlayList:shuffle withHeaderIndex:self.currentIndex];
    }
}

#pragma mark - Notificaiton
- (void)movieDidFinished:(NSNotification *)notificaion
{
    self.contentURL = nil;
    if (_currentIndex >= 0) {
        if (self.yytRepeatMode != YYTMovieRepeatModeOne) {
            [self performSelector:@selector(playNext) withObject:nil afterDelay:0];
        }
    }
}

- (void)videoLoadStateChanged:(NSNotification *)note
{
    MPMovieLoadState state = self.loadState;
    if (state & MPMovieLoadStatePlayable) {
        if (self.startTime) {
            [self setCurrentPlaybackTime:self.startTime];
            self.startTime = 0;
        }
    }
    if (state & MPMovieLoadStatePlaythroughOK) {
        self.timedOut = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieLoadingCaution) object:nil];
    }
    else if (state & MPMovieLoadStateStalled) {
        [self performSelector:@selector(movieTimedOut) withObject:nil afterDelay:YYTMovieLoadLimitedTime];
        [self performSelector:@selector(movieLoadingCaution) withObject:nil afterDelay:YYTMovieLoadCautionTime];
    }
}

- (void)movieLoadingCaution
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YYTMoviePlayerLoadingCautionNotificaiton object:self];
}

- (void)movieTimedOut
{
    if (!(self.loadState & MPMovieLoadStatePlayable) || !(self.loadState & MPMovieLoadStatePlaythroughOK)) {
        self.timedOut = YES;
    }
}

- (void)setTimedOut:(BOOL)timedOut
{
    if (_timedOut != timedOut) {
        _timedOut = timedOut;
        [[NSNotificationCenter defaultCenter] postNotificationName:YYTMoviePlayerTimedOutStateDidChangeNotificaiton object:self];
    }
}

#pragma mark - Private
- (void)setContentURLWithIndex:(NSInteger)index
{
    [self setContentURLWithIndex:index initialPlaybackTime:0];
}

- (void)setContentURLWithIndex:(NSInteger)index initialPlaybackTime:(NSTimeInterval)time
{
    if (index >= [self.playList count] || index<0) {
        return;
    }
    
    id<YYTMovieItem> item = [self.playList movieItemAtIndex:index];
    
    _currentIndex = index;
    YYTMovieQuality quality;
    NSURL *contentURL = [self movieURLWithItem:item Quality:&quality];
    if (contentURL) {
        //self.initialPlaybackTime = time;
        self.startTime = time;
        self.contentURL = contentURL;
        self.playingQuality = quality;
    }
}

- (NSInteger)nextIndex
{
    NSInteger index = [self.playList nextIndex:self.currentIndex repeatMode:self.yytRepeatMode];
    return index;
}

- (NSInteger)prevIndex
{
    NSInteger index = [self.playList prevIndex:self.currentIndex repeatMode:self.yytRepeatMode];
    return index;
}

- (void)reset
{
    _currentIndex = -1;
    _playingQuality = YYTMovieQualityNotAvailable;
    self.contentURL = nil;
    self.startTime = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
}

- (NSURL *)nextURLLocatedAt:(NSInteger *)index Quality:(YYTMovieQuality *)quality
{
    NSURL *url = nil;
    
    NSInteger playingIndex = self.currentIndex;
    for (NSInteger i = playingIndex+1; i<[self.playList count]; ++i) {
        id item = [self.playList movieItemAtIndex:i];
        url = [self movieURLWithItem:item Quality:quality];
        if (url) {
            break;
        }
    }
    
    return url;
}

- (NSURL *)movieURLWithItem:(id<YYTMovieItem>)item Quality:(YYTMovieQuality *)quality
{
    NSURL *url = nil;
    switch (self.preferredQuality) {
        case YYTMovieQualityUHD:
        {
            url = [item movieURLForQuality:YYTMovieQualityUHD];
            if (url) {
                *quality = YYTMovieQualityUHD;
                break;
            }
        }
        case YYTMovieQualityHD:
        {
            url = [item movieURLForQuality:YYTMovieQualityHD];
            if (url) {
                *quality = YYTMovieQualityHD;
                break;
            }
        }
        case YYTMovieQualityDefault:
        {
            url = [item movieURLForQuality:YYTMovieQualityDefault];
            if (url) {
                *quality = YYTMovieQualityDefault;
                break;
            }
        }
        default:
        {
            *quality = YYTMovieQualityNotAvailable;
            if ([item respondsToSelector:@selector(anyURLForQuality:)]) {
                url = [item anyURLForQuality:quality];
            }
            break;
        }
    }
    
    return url;
}

- (YYTMovieQuality)getSavedPreferredQuality
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"SettedQuality"];
    if (number != nil) {
        YYTMovieQuality quality = [number integerValue];
        return quality;
    }
    else {
        return YYTMovieQualityUHD;
    }
}

- (void)savePreferredQuality
{
    NSNumber *number = [NSNumber numberWithInteger:self.preferredQuality];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"SettedQuality"];
}

@end
