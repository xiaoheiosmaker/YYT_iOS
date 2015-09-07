//
//  YYTMovieQualityButton.m
//  YYTHD
//
//  Created by IAN on 14-2-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "YYTMovieQualityButton.h"

@implementation YYTMovieQualityButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _quality = YYTMovieQualityNotAvailable;
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 50, 50)];
    return self;
}

- (void)setQuality:(YYTMovieQuality)quality
{
    if (_quality != quality) {
        _quality = quality;
        UIImage *image = [self imageForQuality:quality highlighted:NO];
        [self setImage:image forState:UIControlStateNormal];
        image = [self imageForQuality:quality highlighted:YES];
        [self setImage:image forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateSelected];
    }
}

- (UIImage *)imageForQuality:(YYTMovieQuality)quality highlighted:(BOOL)highlighted
{
    UIImage *image = nil;
    switch (quality) {
        case YYTMovieQualityDefault:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_quality_def"];
            }
            else {
                image = [UIImage imageNamed:@"player_quality_def_h"];
            }
            break;
        }
        case YYTMovieQualityHD:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_quality_hd"];
            }
            else {
                image = [UIImage imageNamed:@"player_quality_hd_h"];
            }
            break;
        }
        case YYTMovieQualityUHD:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_quality_uhd"];
            }
            else {
                image = [UIImage imageNamed:@"player_quality_uhd_h"];
            }
            break;
        }
        default:
            break;
    }
    
    return image;
}


@end
