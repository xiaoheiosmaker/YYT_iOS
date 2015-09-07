//
//  VideoPlayerBar.h
//  YYTHD
//
//  Created by IAN on 13-10-24.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTPlayTimeLabel.h"
#import "ExButton.h"
#import "YYTSlider.h"
#import "YYTMovieQualityButton.h"
#import "YYTPlayOrderButton.h"

@class MPVolumeView;

@interface YYTPlayerBar : UIView
{
    MPVolumeView *_airplayView;
    UIView *_volumeView;
}
//播放按钮
@property (nonatomic, readonly) ExButton *playBtn;
@property (nonatomic, readonly) UIButton *prevBtn;
@property (nonatomic, readonly) UIButton *nextBtn;

//进度条
@property (nonatomic, readonly) YYTSlider *progressSlider;
@property (nonatomic, readonly) YYTPlayTimeLabel *progressLabel;

//功能按钮
@property (nonatomic, readonly) YYTMovieQualityButton *qualityBtn;
@property (nonatomic, readonly) UIButton *volumeBtn;
@property (nonatomic, readonly) YYTPlayOrderButton *singleRepBtn;
@property (nonatomic, readonly) YYTPlayOrderButton *playOrderBtn;
@property (nonatomic, readonly) ExButton *fullScreenBtn;

@property (nonatomic, readonly) UIView *volumeView;

- (void)setAirplayBtnHidden:(BOOL)hidden;

- (void)setVideoRelatedBtnEnabled:(BOOL)enable;

@end