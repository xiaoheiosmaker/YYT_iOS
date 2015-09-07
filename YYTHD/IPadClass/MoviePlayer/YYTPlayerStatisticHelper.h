//
//  YYTPlayerStatisticHelper.h
//  YYTHD
//
//  Created by IAN on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYTMoviePlayerController;
@class MLItem;

@interface YYTPlayerStatisticHelper : NSObject

@property (nonatomic, weak,readonly)YYTMoviePlayerController *moviePlayer;
- (void)workWithMoviePlayer:(YYTMoviePlayerController *)moviePlayer;


+ (void)sendMLStatisticWithMLItem:(MLItem *)mlItem;

@end
