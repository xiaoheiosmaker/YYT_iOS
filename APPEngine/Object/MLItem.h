//
//  YueDanList.h
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/8/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLAuthor;

@interface MLItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *keyID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *coverPic;
@property (nonatomic, strong) NSNumber *videoCount;
@property (nonatomic, strong, readonly)NSURL *traceUrl;
@property (nonatomic, strong, readonly)NSURL *clickUrl;
@property (nonatomic, strong, readonly)NSURL *playUrl;
@property (nonatomic, strong, readonly)MLAuthor *author;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong, readonly) NSNumber *totalViews;
@property (nonatomic, strong, readonly) NSNumber *totalFavorites;
@property (nonatomic, strong, readonly) NSURL *playListPic;
@property (nonatomic, strong, readonly) NSURL *playListBigPic;
@property (nonatomic, copy) NSMutableArray *videos;
@property (nonatomic, strong) UIImage *coverImage;

@end
