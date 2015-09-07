//
//  YYTPlayTimeLabel.m
//  YYTHD
//
//  Created by IAN on 13-11-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPlayTimeLabel.h"
#import "NSString+TimeCategory.h"

@implementation YYTPlayTimeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat fix = 5;
        
        CGFloat width = CGRectGetWidth(frame)/2;
        CGFloat height = CGRectGetHeight(frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-fix, height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        _playTimeLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(width-fix, 0, width+fix, height)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        _durationLabel = label;
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)duration
{
    NSString *text = [NSString stringWithTime:duration];
    self.durationLabel.text = [NSString stringWithFormat:@"/%@",text];
}

- (void)setCurrentPlayTime:(NSTimeInterval)playTime
{
    NSString *text = [NSString stringWithTime:playTime];
    self.playTimeLabel.text = text;
}

/*
- (void)sizeToFit
{
    [self.playTimeLabel sizeToFit];
    [self.durationLabel sizeToFit];
    
    CGFloat width1 = CGRectGetWidth(self.playTimeLabel.frame);
    CGFloat width2 = CGRectGetHeight(self.durationLabel.frame);
    
    CGRect frame = self.playTimeLabel.frame;
    CGFloat y = (CGRectGetHeight(self.frame)-CGRectGetHeight(frame))/2;
    frame.origin.y = y;
    self.playTimeLabel.frame = frame;
    
//    frame = self.durationLabel.frame;
//    y = (CGRectGetHeight(self.frame)-CGRectGetHeight(frame))/2;
//    frame.origin.x = width1;
    
}
*/


@end
