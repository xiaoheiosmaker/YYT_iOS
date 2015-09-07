//
//  YYTPlayerStatisticHelper.m
//  YYTHD
//
//  Created by IAN on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPlayerStatisticHelper.h"
#import "StatisticManager.h"
#import "YYTMoviePlayerViewController.h"
#import "MLItem.h"
#import "NSDictionary+JSON.h"
#import "MVDownloadItem.h"
#import "YYTClient.h"

@interface YYTPlayerStatisticHelper ()
{
    NSTimeInterval _playingTimeInterval;
    BOOL _pause;
    
    NSUInteger _buffCount;
    BOOL _reqPlayFinished;
    
    NSTimer *_timer;
}
@property (nonatomic, weak) id statisticOper;
@property (nonatomic, strong) NSMutableArray *statisticPoints;

@end


@implementation YYTPlayerStatisticHelper

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reset
{
    if (self.moviePlayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [self endPlayingTimer];
    [self clearBufferCount];
}

- (void)workWithMoviePlayer:(YYTMoviePlayerController *)moviePlayer
{
    _moviePlayer = moviePlayer;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    MPMoviePlayerController *player = self.moviePlayer;
    [center addObserver:self
               selector:@selector(moviePlayerPlaybackStateDidChange:)
                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerDidFinish:)
                   name:MPMoviePlayerPlaybackDidFinishNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerNowPlayingMovieDidChange:)
                   name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerReadyForDisplay:)
                   name:MPMoviePlayerReadyForDisplayDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerLoadStateDidChange:)
                   name:MPMoviePlayerLoadStateDidChangeNotification
                 object:player];
}

- (void)moviePlayerNowPlayingMovieDidChange:(id)sender
{
    if (!self.moviePlayer.contentURL) {
        return;
    }
    
    [self reqPlayStart];
}


- (void)moviePlayerReadyForDisplay:(id)sender
{
    if (![self.moviePlayer contentURL]) {
        return;
    }
    
    [self sendStatisticDataToServer];
    [self startPlayingTimer];
    
    [self reqVideoReadyForDisplay];
}


- (void)moviePlayerPlaybackStateDidChange:(id)sender
{
    MPMoviePlaybackState state = self.moviePlayer.playbackState;
    switch (state) {
        case MPMoviePlaybackStatePlaying:
        {
            [self pausePlayingTimer:NO];
            break;
        }
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateInterrupted:
        {
            [self pausePlayingTimer:YES];
        }
            break;
        case MPMoviePlaybackStateSeekingForward:
            break;
        case MPMoviePlaybackStateSeekingBackward:
            break;
        default:
            break;
    }
}


- (void)moviePlayerLoadStateDidChange:(id)sender
{
    NSInteger state = self.moviePlayer.loadState;
    if (state & MPMovieLoadStateStalled) {
        [self reqBufferRunOut];
    }
}

- (void)moviePlayerDidFinish:(id)sender
{
    [self clearBufferCount];
    [self endPlayingTimer];
}

#pragma mark - 播放时长统计
- (void)startPlayingTimer
{
    _playingTimeInterval = 0;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(progressPlayingTime) userInfo:nil repeats:YES];
    }
    
    if (self.moviePlayer.playbackState != MPMoviePlaybackStatePlaying) {
        [self pausePlayingTimer:YES];
    }
}

- (void)endPlayingTimer
{
    _playingTimeInterval = 0;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)pausePlayingTimer:(BOOL)pause
{
    _pause = pause;
}

- (void)progressPlayingTime
{
    if (_pause) {
        return;
    }
    
    ++_playingTimeInterval;
    if (!self.statisticOper) {
        return;
    }
    
    float progress = _playingTimeInterval/self.moviePlayer.duration;
    NSMutableIndexSet *removedIndexSet = nil;
    NSUInteger index = 0;
    for (NSNumber *obj in self.statisticPoints) {
        double point = [obj doubleValue];
        if (progress > point) {
            [self sendStatisticResponseWithProgress:point];
            if (!removedIndexSet) {
                removedIndexSet = [NSMutableIndexSet indexSetWithIndex:index];
            }
            else {
                [removedIndexSet addIndex:index];
            }
        }
        ++index;
    }
    
    if (progress > 0.8) {
        [self reqPlayFinished];
    }
    
    if (removedIndexSet) {
        [self.statisticPoints removeObjectsAtIndexes:removedIndexSet];
    }
}

#pragma mark - V榜统计
- (void)sendStatisticDataToServer
{
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    NSNumber *movieID = [item movieID];
    NSDictionary *userInfo = @{StatisticIDInfoKey: movieID,
                               StatisticProgressInfoKey: [NSNumber numberWithFloat:0]};
    __weak YYTPlayerStatisticHelper *weekSelf = self;
    self.statisticOper = [StatisticManager sendStatisticToPath:MVPlayStatisticPath
                                                      userInfo:userInfo
                                                    completion:
                          ^(AFHTTPRequestOperation *operation, NSError *error) {
                              if (!error && weekSelf.statisticOper == operation) {
                                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                                  weekSelf.statisticPoints = dic[@"doStatistics"];
                              }
                          }];
    
}

- (void)sendStatisticResponseWithProgress:(float)progress
{
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    NSNumber *movieID = [item movieID];
    if (!movieID) {
        return;
    }
    
    NSDictionary *userInfo = @{StatisticIDInfoKey: movieID,
                               StatisticProgressInfoKey: @(progress)};
    
    id oper = self.statisticOper;
    [StatisticManager sendResponse:oper
                          userInfo:userInfo];
    self.statisticOper = nil;
}

+ (void)sendMLStatisticWithMLItem:(MLItem *)mlItem
{
    NSNumber *mlID = mlItem.keyID;
    if (mlID) {
        NSDictionary *userInfo = @{StatisticIDInfoKey: mlID};
        [StatisticManager sendAutoStatisticToPath:MLPlayStatisticPath userInfo:userInfo];
    }
}

#pragma mark - 运营统计
- (void)reqPlayStart
{
    [self clearBufferCount];
    
    NSURL *url = [self.moviePlayer contentURL];
    if (!url) {
        return;
    }
    
    if ([url isFileURL]) {
        [self sendReq:5];
    }
    else {
        [self sendReq:1];
    }
}

- (void)reqVideoReadyForDisplay
{
    NSURL *url = [self.moviePlayer contentURL];
    if (!url || [url isFileURL]) {
        return;
    }
    
    [self sendReq:2];
}

- (void)reqBufferRunOut
{
    ++_buffCount;
    if (_buffCount > 10) {
        return;
    }
    
    NSURL *url = [self.moviePlayer contentURL];
    if (!url || [url isFileURL]) {
        return;
    }
    
    [self sendReq:3];
}

- (void)clearBufferCount
{
    _buffCount = 0;
}

- (void)reqPlayFinished
{
    NSURL *url = [self.moviePlayer contentURL];
    if (!url || [url isFileURL]) {
        return;
    }
    
    [self sendReq:4];
}

- (NSDictionary *)paramsForReqID:(NSInteger)reqID
{
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    NSURL *url = [self.moviePlayer contentURL];
    if (!item || !url) {
        return nil;
    }
    
    NSString *urlStr = [url absoluteString];
    
    if ([item isKindOfClass:[MVDownloadItem class]]) {
        MVDownloadItem *downloadItem = item;
        urlStr = [downloadItem url];
    }
    
    NSMutableDictionary *params = [@{@"reqid": makeString(reqID),
                                    @"vid": [item movieID],
                                    @"vurl": urlStr,
                                    @"ctype": @"iPad",
                                    @"cagent": @"苹果"} mutableCopy];
    switch (reqID) {
        case 1:
        {
            [params setObject:[item title] forKey:@"vna"];
        }
            break;
        case 2:
            break;
        case 3:
        {
            [params setObject:@"05" forKey:@"sta"];
            [params setObject:makeString(_buffCount) forKey:@"buffcount"];
        }
            break;
        case 4:
        {
            [params setObject:makeString(1) forKey:@"endplay"];
        }
            break;
        case 5:
        {
            [params setObject:[item title] forKey:@"vna"];
            NSDictionary *plaver = [YYTPlayerStatisticHelper plaverForVideID:[item movieID]];
            NSString *json = [plaver JSONString];
            [params setObject:json forKey:@"plaver"];
            
        }
            break;
        default:
            break;
    }
    
    return params;
}

- (void)sendReq:(NSInteger)req
{
    NSDictionary *params = [self paramsForReqID:req];
    NSString *plaver = [params objectForKey:@"plaver"];
    if (plaver) {
        [YYTPlayerStatisticHelper clearPlaver];
    }
    
    [[YYTClient sharedInstance] postPath:@"http://client.stats.yinyuetai.com/newvv"
                              parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (plaver) {
                                         [YYTPlayerStatisticHelper margePlaverJSON:plaver];
                                     }
                                 }];
}

NSString * makeString(NSInteger number)
{
    return [NSString stringWithFormat:@"%d",(int)number];
}

#pragma mark 离线统计数据
static NSString * const YYTPLAYERPlaverKey = @"YYTPLAYERPlaver";

+ (NSDictionary *)plaverForVideID:(NSNumber *)vid
{
    NSString *vidKey = [vid stringValue];
    
    NSDictionary *savedDic = [[NSUserDefaults standardUserDefaults] objectForKey:YYTPLAYERPlaverKey];
    NSMutableDictionary *plaver = [NSMutableDictionary dictionaryWithDictionary:savedDic];
    NSInteger count = [[plaver objectForKey:vidKey] integerValue];
    ++count;
    [plaver setObject:makeString(count) forKey:vidKey];
    
    return plaver;
}

+ (void)savePlaver:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:YYTPLAYERPlaverKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)margePlaverJSON:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *plaver = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (plaver) {
        [self margePlaver:plaver];
    }
}


+ (void)margePlaver:(NSDictionary *)plaver
{
    if (![plaver count]) {
        return;
    }
    
    NSDictionary *resultDic = plaver;
    NSDictionary *savedDic = [[NSUserDefaults standardUserDefaults] objectForKey:YYTPLAYERPlaverKey];
    if ([savedDic count]) {
        //marge
        NSMutableDictionary *margedDic = [savedDic mutableCopy];
        [margedDic addEntriesFromDictionary:plaver];
        //将被plaver覆盖的计数合并
        [savedDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSInteger addCount = [obj integerValue];
            NSInteger count = [[margedDic objectForKey:key] integerValue];
            [margedDic setObject:makeString(addCount+count) forKey:key];
        }];
        resultDic = margedDic;
    }
    
    [self savePlaver:resultDic];
}

+ (void)clearPlaver
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YYTPLAYERPlaverKey];
}

@end
