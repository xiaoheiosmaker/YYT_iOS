//
//  MVDownloadItem.m
//  YYTHD
//
//  Created by btxkenshin on 10/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVDownloadItem.h"

@implementation MVDownloadItem

- (id)initWithMVItem:(MVItem *)item quality:(YYTMovieQuality)quality
{
    if ((self = [super init])) {
        NSInteger videoID = [item.keyID integerValue];
        NSInteger keyID = videoID*10+quality;
        self.keyID = [NSNumber numberWithInteger:keyID];
        
        _quality = quality;
        _title = item.title;
        _artistName = item.artistName;
        _thumbnailPic = item.coverImageURL;
        
        NSURL *url = [item movieURLForQuality:quality];
        _url = [url absoluteString];
        
        _videoSize = [item videoSizeForQuality:quality];
        
        _audioTimes = @"";
        
        _cbytes = 0;
        _tbytes = 0;
        _currentProgress = 0;
        _status = DownloadStatusDefault;
        
        _tmpPath = @"";
        _path = @"";
    }
    return self;
}


- (id)initWithResultSet:(FMResultSet *)rs
{
    if ((self = [super init])) {
        self.keyID = [NSNumber numberWithInt:[rs intForColumn:@"mvid"]];
        _title = [rs stringForColumn:@"title"];
        _artistName = [rs stringForColumn:@"artist_name"];
        _thumbnailPic = [NSURL URLWithString:[rs stringForColumn:@"thumbnail_pic"]];
        _totalViews = [rs intForColumn:@"total_views"] ? [NSNumber numberWithInt:[rs intForColumn:@"total_views"]] : [NSNumber numberWithInt:0];
        _totalComments = [rs intForColumn:@"total_comments"] ? [NSNumber numberWithInt:[rs intForColumn:@"total_comments"]] : [NSNumber numberWithInt:0];
        
        _url = [rs stringForColumn:@"url"];
        _videoSize = [NSNumber numberWithInt:[rs intForColumn:@"video_size"]];
        
        _audioTimes = [rs stringForColumn:@"audio_time"];
        
        _cbytes = [rs intForColumn:@"cbytes"];
        _tbytes = [rs intForColumn:@"tbytes"];
        _currentProgress = [rs doubleForColumn:@"current_progress"];
        _status = [rs intForColumn:@"status"];
        
        _tmpPath = [rs stringForColumn:@"tmp_path"];
        _path = [rs stringForColumn:@"path"];
        
        _quality = [rs intForColumn:@"quality"];
    }
    return self;
}

- (int)tbytes
{
    return _tbytes == 0 ? [_videoSize intValue] : _tbytes;
}

- (NSString *)localPath
{
    return self.path;
}

- (NSNumber *)videoID
{
    NSInteger keyID = [self.keyID integerValue];
    NSInteger videoID = keyID/10;
    return [NSNumber numberWithInteger:videoID];
}

- (NSNumber *)movieID
{
    return [self videoID];
}

- (NSURL *)fileURL
{
    NSURL *url = nil;
    if (self.path) {
        NSString *path = [RootDirectory stringByAppendingPathComponent:self.path];
        url = [NSURL fileURLWithPath:path];
    }
    
    return url;
}

- (NSURL *)movieURLForQuality:(YYTMovieQuality)quality
{
    NSURL *url = nil;
    if (quality == self.quality) {
        if (self.path) {
            url = [self fileURL];
        }
    }
    
    return url;
}

- (NSURL *)anyURLForQuality:(YYTMovieQuality *)quality
{
    *quality = self.quality;
    return [self fileURL];
}

- (NSString *)statusDes
{
    NSString *des = @"";
    switch (_status) {
        case DownloadStatusDefault:
            des = @"尚未开始";
            break;
        case DownloadStatusWait:
            des = @"等待开始";
            break;
        case DownloadStatusDownloading:
            des = @"下载进行中";
            break;
        case DownloadStatusComplete:
            des = @"";
            break;
            
        default:
            des = @"未知状态";
            break;
    }
    return des;
}

@end
