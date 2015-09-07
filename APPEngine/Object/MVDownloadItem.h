//
//  MVDownloadItem.h
//  YYTHD
//
//  Created by btxkenshin on 10/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVItem.h"
#import <FMDatabase.h>
#import "YYTMovieItem.h"

typedef enum : NSInteger{
    DownloadStatusDefault, //没有在下载队列
    DownloadStatusWait, //在队列中，但没有开始下载
    DownloadStatusDownloading,
    DownloadStatusComplete
}DownloadStatus;

@interface MVDownloadItem : NSObject <YYTMovieItem>

@property (nonatomic, strong) NSNumber *keyID;

- (NSNumber *)videoID;
@property (nonatomic,copy, readonly) NSString *title;
@property (nonatomic,copy, readonly) NSString *artistName;
@property (nonatomic,strong, readonly) NSURL *thumbnailPic;

@property (nonatomic, readonly) NSNumber *totalViews;
@property (nonatomic, readonly) NSNumber *totalComments;

//视频地址与大小
@property (nonatomic,strong, readonly) NSString *url;
@property (nonatomic,strong, readonly) NSNumber *videoSize;

@property (nonatomic,assign) NSInteger quality;
@property (nonatomic,copy) NSString *tmpPath;//临时文件下载路径
@property (nonatomic,copy) NSString *path;//最终文件路径

@property (nonatomic, copy) NSString *audioTimes;

@property (nonatomic, assign) int cbytes; //当前已经下载的大小
@property (nonatomic, assign) int tbytes; //总大小
@property float currentProgress;
@property DownloadStatus status;


- (id)initWithMVItem:(MVItem *)item quality:(YYTMovieQuality)quality;
- (id)initWithResultSet:(FMResultSet *)rs;

- (int)tbytes;
- (NSString *)localPath;
- (NSString *)statusDes;

@end
