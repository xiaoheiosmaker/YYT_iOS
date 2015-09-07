//
//  YYTMoviePlayList.m
//  YYTHD
//
//  Created by IAN on 13-12-10.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTMoviePlayList.h"

#pragma mark YYTMoviePlayListItem
@interface YYTMoviePlayListItem : NSObject

- (id)initWithMovieItem:(id<YYTMovieItem>)item;

@property (nonatomic, readonly) id<YYTMovieItem> movieItem;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, assign) NSInteger prevIndex;

@end

@implementation YYTMoviePlayListItem

- (id)initWithMovieItem:(id<YYTMovieItem>)item
{
    if (self = [super init]) {
        _movieItem = item;
    }
    return self;
}

@end

#pragma mark - YYTMoviePlayList

@interface YYTMoviePlayList ()
{
    NSInteger _headerIndex;
}
@property (nonatomic, strong) NSMutableArray *playList;

@end

@implementation YYTMoviePlayList

- (id)initWithMoiveItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:items.count+1];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            YYTMoviePlayListItem *item = [[YYTMoviePlayListItem alloc] initWithMovieItem:obj];
            [array addObject:item];
        }];
        
        self.playList = array;
        _shuffle = NO;
        [self resetIndex];
    }
    return self;
}

- (NSArray *)movieItems
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (YYTMoviePlayListItem *item in self.playList) {
        [array addObject:item.movieItem];
    }
    
    return array;
}

- (NSUInteger)count
{
    return [self.playList count];
}

- (id<YYTMovieItem>)movieItemAtIndex:(NSInteger)index
{
    YYTMoviePlayListItem *item = [self.playList objectAtIndex:index];
    return item.movieItem;
}

- (NSInteger)prevIndex:(NSInteger)index repeatMode:(YYTMovieRepeatMode)repeatMode
{
    if (index == _headerIndex) {
        if (repeatMode != YYTMovieRepeatModeAll) {
            return NSNotFound;
        }
    }
    
    YYTMoviePlayListItem *item = [self.playList objectAtIndex:index];
    NSInteger prevIndex = item.prevIndex;
    return prevIndex;
}

- (NSInteger)nextIndex:(NSInteger)index repeatMode:(YYTMovieRepeatMode)repeatMode
{
    YYTMoviePlayListItem *item = [self.playList objectAtIndex:index];
    NSInteger nextIndex = item.nextIndex;
    if (nextIndex == _headerIndex) {
        if (repeatMode != YYTMovieRepeatModeAll) {
            return NSNotFound;
        }
    }
    return nextIndex;
}

- (void)shufflePlayList:(BOOL)shuffle
{
    [self shufflePlayList:shuffle withHeaderIndex:0];
}

- (void)shufflePlayList:(BOOL)shuffle withHeaderIndex:(NSInteger)index
{
    _shuffle = shuffle;
    if (shuffle) {
        _headerIndex = index;
        [self shuffleIndex];
    }
    else {
        _headerIndex = 0;
        [self resetIndex];
    }
}

- (void)shuffleIndex
{
    if (![self.playList count]) {
        return;
    }
    
    NSInteger size = [self.playList count];
    for (int i=0; i<size; ++i) {
        NSInteger p = arc4random()%size;
        [self swapItemAtIndex:i withIndex:p];
    }
}

- (void)resetIndex
{
    if (![self.playList count]) {
        return;
    }
    
    [self.playList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        YYTMoviePlayListItem *item = obj;
        item.prevIndex = idx-1;
        item.nextIndex = idx+1;
    }];
    
    YYTMoviePlayListItem *item = [self.playList objectAtIndex:0];
    item.prevIndex = [self.playList count]-1;
    item = [self.playList lastObject];
    item.nextIndex = _headerIndex;
}

- (void)swapItemAtIndex:(NSInteger)aIndex withIndex:(NSInteger)bIndex
{
    if (aIndex == bIndex) {
        return;
    }
    
    NSInteger aNext = [self nextIndex:aIndex repeatMode:YYTMovieRepeatModeAll];
    NSInteger aPrev = [self prevIndex:aIndex repeatMode:YYTMovieRepeatModeAll];
    BOOL near = (aNext==bIndex);
    if (!near && (aPrev == bIndex)) {
        near = YES;
        //若a,b相邻，保证a在前
        NSInteger temp = aIndex;
        aIndex = bIndex;
        bIndex = temp;
    }
    
    printf("swap %d <-> %d\n",aIndex,bIndex);
    YYTMoviePlayListItem *aItem, *bItem;
    YYTMoviePlayListItem *aPrevItem, *aNextItem;
    YYTMoviePlayListItem *bPrevItem, *bNextItem;
    
    
    aItem = [self.playList objectAtIndex:aIndex];
    bItem = [self.playList objectAtIndex:bIndex];
    
    aPrevItem = [self.playList objectAtIndex:aItem.prevIndex];
    aNextItem = [self.playList objectAtIndex:aItem.nextIndex];
    
    bPrevItem = [self.playList objectAtIndex:bItem.prevIndex];
    bNextItem = [self.playList objectAtIndex:bItem.nextIndex];
    
    if (near) {
        //处理相邻情况
        aPrevItem.nextIndex = bIndex;
        bNextItem.prevIndex = aIndex;
        
        NSInteger prevIndex = aItem.prevIndex;
        aItem.prevIndex = bIndex;
        aItem.nextIndex = bItem.nextIndex;
        bItem.prevIndex = prevIndex;
        bItem.nextIndex = aIndex;
    }
    else {
        aPrevItem.nextIndex = bIndex;
        aNextItem.prevIndex = bIndex;
        bPrevItem.nextIndex = aIndex;
        bNextItem.prevIndex = aIndex;
        
        NSInteger temp;
        temp = aItem.prevIndex;
        aItem.prevIndex = bItem.prevIndex;
        bItem.prevIndex = temp;
        temp = aItem.nextIndex;
        aItem.nextIndex = bItem.nextIndex;
        bItem.nextIndex = temp;
    }
}



@end
