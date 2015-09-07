//
//  MVItem.m
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/9/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVItem.h"
#import "Artist.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import <MTLValueTransformer.h>
#import "accesskeylib.h"
#import "NSString+TimeCategory.h"

@interface MVItem ()

@property (nonatomic, readonly) NSString *albumImg; //640x360
@property (nonatomic, readonly) NSString *posterPic;   //240x135
@property (nonatomic, readonly) NSString *thumbnailPic; //120x67;

//视频地址与大小
//@property (nonatomic,strong, readonly) NSString *url;
@property (nonatomic,strong, readonly) NSString *hdUrl;
@property (nonatomic,strong, readonly) NSString *uhdUrl;
@property (nonatomic, readonly) NSString *shdUrl;

//@property (nonatomic,strong, readonly) NSNumber *videoSize;
@property (nonatomic,strong, readonly) NSNumber *hdVideoSize;
@property (nonatomic,strong, readonly) NSNumber *uhdVideoSize;
@property (nonatomic, readonly) NSNumber *shdVideoSize;

//视频状态：200正常，403无版权 404视频不存在
@property (nonatomic,strong, readonly) NSNumber *status;
//广告曝光链接(曝光后要保证发送出去)
@property (nonatomic,strong, readonly) NSURL *traceUrl;
//广告点击链接(用户点击后要保证发送出去)
@property (nonatomic,strong, readonly) NSURL *clickUrl;
//播放统计地址
@property (nonatomic,strong, readonly) NSURL *playUrl;
//完整播放统计地址
@property (nonatomic,strong, readonly) NSURL *fullPlayUrl;

@end


@implementation MVItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"keyID": @"id",
             @"describ": @"description",
             };
}

+ (NSValueTransformer *)relatedVideosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVItem class]];
}

+ (NSValueTransformer *)artistsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *artists) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:artists.count];
        for (NSDictionary *dic in artists) {
            NSString *name = dic[@"artistName"];
            NSString *keyID = [dic[@"artistId"] stringValue];
            Artist *obj = [[Artist alloc] initWithID:keyID name:name];
            [result addObject:obj];
        }
        return result;
    }];
}

- (NSURL *)coverImageURL
{
    NSString *coverPath = nil;
    if ([SystemSupport isRetina]) {
        //Retina屏幕加载高清图片
        coverPath = self.albumImg;
    }
    
    if (![coverPath length]) {
        coverPath = self.posterPic;
    }
    
    if (![coverPath length]) {
        coverPath = self.thumbnailPic;
    }
    
    if ([coverPath length]) {
        return [NSURL URLWithString:coverPath];
    }
    
    return nil;
}

- (NSURL *)largeImageURL
{
    NSString *coverPath = self.albumImg;
    
    if (![coverPath length]) {
        coverPath = self.posterPic;
    }
    
    if (![coverPath length]) {
        coverPath = self.thumbnailPic;
    }
    
    if ([coverPath length]) {
        return [NSURL URLWithString:coverPath];
    }
    
    return nil;
}

- (NSNumber *)movieID
{
    return self.keyID;
}

- (NSURL *)movieURLForQuality:(YYTMovieQuality)quality
{
    NSString *moviePath = nil;
    switch (quality) {
        case YYTMovieQualityDefault:
        {
            moviePath = self.hdUrl;
            break;
        }
        case YYTMovieQualityHD:
        {
            moviePath = self.uhdUrl;
            break;
        }
        case YYTMovieQualityUHD:
        {
            moviePath = self.shdUrl;
            break;
        }
        default:
            break;
    }
    
    if (moviePath) {
        moviePath = [accesskeylib getAccessKeyUrl:moviePath];
        return [NSURL URLWithString:moviePath];
    }
    
    return nil;
}

- (NSNumber *)videoSizeForQuality:(YYTMovieQuality)quality
{
    NSNumber *videoSize = nil;
    switch (quality) {
        case YYTMovieQualityDefault:    //标清
            videoSize = self.hdVideoSize;
            break;
        case YYTMovieQualityHD: //高清
            videoSize = self.uhdVideoSize;
            break;
        case YYTMovieQualityUHD:    //超清
            videoSize = self.shdVideoSize;
            break;
        default:
            break;
    }
    
    return videoSize;
}

- (VideoType)videoType{
    VideoType videoStatus;
    if (self.shdUrl) {
        videoStatus = VideoSHD;
    }else if (!self.shdUrl && self.uhdUrl){
        videoStatus = VideoHD;
    }else {
        videoStatus = UNVideoHD;
    }
    return videoStatus;
}

- (NSString *)getVidepDuration{
    return [NSString stringWithTime:[self.duration intValue]];
}

@end
