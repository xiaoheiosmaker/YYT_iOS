//
//  YYTVolumeView.m
//  YYTHD
//
//  Created by IAN on 13-11-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTVolumeView.h"

@implementation YYTVolumeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0) {
            UIImage *maxTrackImage = [UIImage imageNamed:@"volMaxTrack"];
            //UIImage *maxTrackImage = [UIImage imageNamed:@"player_slider_maxTrack"];
            maxTrackImage = [maxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            UIImage *miniTrackImage = [UIImage imageNamed:@"volMiniTrack"];
            //UIImage *miniTrackImage = [UIImage imageNamed:@"player_slider_miniTrack"];
            miniTrackImage = [miniTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            [self setMaximumVolumeSliderImage:maxTrackImage forState:UIControlStateNormal];
            [self setMinimumVolumeSliderImage:miniTrackImage forState:UIControlStateNormal];
            
            UIImage *thumbImage = [UIImage imageNamed:@"volThumb"];
            [self setVolumeThumbImage:thumbImage forState:UIControlStateNormal];
            
            [self setRouteButtonImage:[UIImage imageNamed:@"player_airplay"] forState:UIControlStateNormal];
            [self setRouteButtonImage:[UIImage imageNamed:@"player_airplay_h"] forState:UIControlStateSelected];
        }
    }
    return self;
}

- (CGRect)volumeSliderRectForBounds:(CGRect)bounds
{
    CGFloat height = 10;
    CGRect trackRect = bounds;
    trackRect.size.height = height;
    trackRect.origin.y += (CGRectGetHeight(bounds)-height)/2;
    return trackRect;
}

- (CGRect)volumeThumbRectForBounds:(CGRect)bounds volumeSliderRect:(CGRect)rect value:(float)value
{
    CGFloat thumbSize = 20;
    CGFloat x = CGRectGetWidth(bounds) * value;
    CGFloat y = CGRectGetMidY(rect)-thumbSize/2;
    CGRect thumbRect = CGRectMake(x, y, thumbSize, thumbSize);
    return thumbRect;
}

@end
