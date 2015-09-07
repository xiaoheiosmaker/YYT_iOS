//
//  YYTMoviePlayList.h
//  YYTHD
//
//  Created by IAN on 13-12-10.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTMovieItem.h"

@interface YYTMoviePlayList : NSObject

- (id)initWithMoiveItems:(NSArray *)items;
- (NSArray *)movieItems;
- (NSUInteger)count;

- (id<YYTMovieItem>)movieItemAtIndex:(NSInteger)index;
- (NSInteger)nextIndex:(NSInteger)index repeatMode:(YYTMovieRepeatMode)repeatMode;
- (NSInteger)prevIndex:(NSInteger)index repeatMode:(YYTMovieRepeatMode)repeatMode;

@property (nonatomic, readonly) BOOL shuffle;

- (void)shufflePlayList:(BOOL)shuffle;
- (void)shufflePlayList:(BOOL)shuffle withHeaderIndex:(NSInteger)index;

@end
