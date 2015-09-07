//
//  YYTPlayTimeLabel.h
//  YYTHD
//
//  Created by IAN on 13-11-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTPlayTimeLabel : UIView

@property (nonatomic, readonly) UILabel *playTimeLabel;
@property (nonatomic, readonly) UILabel *durationLabel;

- (void)setCurrentPlayTime:(NSTimeInterval)playTime;
- (void)setDuration:(NSTimeInterval)duration;

@end
