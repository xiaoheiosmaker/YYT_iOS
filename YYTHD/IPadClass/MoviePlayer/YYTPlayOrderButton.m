//
//  YYTPlayOrderButton.m
//  YYTHD
//
//  Created by IAN on 14-2-14.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "YYTPlayOrderButton.h"

@implementation YYTPlayOrderButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _playOrder = -1;
    }
    return self;
}

- (void)setPlayOrder:(YYTMoviePlayOrder)playOrder
{
    if (_playOrder != playOrder) {
        UIImage *image = [self imageForOrder:playOrder highlighted:NO];
        [self setImage:image forState:UIControlStateNormal];
        image = [self imageForOrder:playOrder highlighted:YES];
        [self setImage:image forState:UIControlStateHighlighted];
        [self setImage:image forState:UIControlStateSelected];
        
        _playOrder = playOrder;
    }
}

- (UIImage *)imageForOrder:(YYTMoviePlayOrder)order highlighted:(BOOL)highlighted
{
    UIImage *image = nil;
    switch (order) {
        case YYTMoviePlayOrderNone:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_order_def"];
            }
            else {
                image = [UIImage imageNamed:@"player_order_def_h"];
            }
            break;
        }
        case YYTMoviePlayOrderRepeatAll:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_order_rep"];
            }
            else {
                image = [UIImage imageNamed:@"player_order_rep_h"];
            }
            break;
        }
        case YYTMoviePlayOrderRepeatOne:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_order_single"];
            }
            else {
                image = [UIImage imageNamed:@"player_order_single_h"];
            }
            break;
        }
        case YYTMoviePlayOrderShuffle:
        {
            if (!highlighted) {
                image = [UIImage imageNamed:@"player_order_suff"];
            }
            else {
                image = [UIImage imageNamed:@"player_order_suff_h"];
            }
            break;
        }
        default:
            break;
    }
    
    return image;
}

@end
