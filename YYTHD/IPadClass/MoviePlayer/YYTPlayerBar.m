//
//  VideoPlayerBar.m
//  YYTHD
//
//  Created by IAN on 13-10-24.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPlayerBar.h"
#import "ExButton.h"
#import "YYTSlider.h"
#import "YYTVolumeView.h"


const CGFloat NormalBtnSize = 50;

@implementation YYTPlayerBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, NormalBtnSize, NormalBtnSize);
        [btn setImage:[UIImage imageNamed:@"player_prev"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"player_prev_h"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        _prevBtn = btn;
        _prevBtn.hidden = YES;
        
        ExButton *exbtn = [[ExButton alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        [exbtn setNormalImage:[UIImage imageNamed:@"player_play"] highlightedImage:[UIImage imageNamed:@"player_play_h"]];
        [exbtn setExSelectedImage:[UIImage imageNamed:@"player_pause"] highlightedImage:[UIImage imageNamed:@"player_pause_h"]];
        [self addSubview:exbtn];
        _playBtn = exbtn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, NormalBtnSize, NormalBtnSize);
        [btn setImage:[UIImage imageNamed:@"player_next"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"player_next_h"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        _nextBtn = btn;
        _nextBtn.hidden = YES;
        
        MPVolumeView *volumeView = [[YYTVolumeView alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        volumeView.showsVolumeSlider = NO;
        volumeView.showsRouteButton = YES;
        [self addSubview:volumeView];
        _airplayView = volumeView;
        
        YYTMovieQualityButton *qualityBtn = [[YYTMovieQualityButton alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        qualityBtn.quality = YYTMovieQualityDefault;
        [self addSubview:qualityBtn];
        _qualityBtn = qualityBtn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, NormalBtnSize, NormalBtnSize);
        [btn setImage:[UIImage imageNamed:@"player_vol"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"player_vol_h"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        _volumeBtn = btn;
        
        YYTPlayOrderButton *poBtn = [[YYTPlayOrderButton alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        poBtn.playOrder = YYTMoviePlayOrderNone;
        [self addSubview:poBtn];
        _playOrderBtn = poBtn;
        _playOrderBtn.hidden = YES;
        
        poBtn = [[YYTPlayOrderButton alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        poBtn.playOrder = YYTMoviePlayOrderRepeatOne;
        [self addSubview:poBtn];
        _singleRepBtn = poBtn;

        exbtn = [[ExButton alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        [exbtn setNormalImage:[UIImage imageNamed:@"player_fullScreen_enter"] highlightedImage:[UIImage imageNamed:@"player_fullScreen_enter_h"]];
        [exbtn setExSelectedImage:[UIImage imageNamed:@"player_fullScreen_quit"] highlightedImage:[UIImage imageNamed:@"player_fullScreen_quit_h"]];
        //[btn setTitle:@"全屏" forState:UIControlStateNormal];
        [self addSubview:exbtn];
        _fullScreenBtn = exbtn;
        
        YYTSlider *slider = [[YYTSlider alloc] initWithFrame:CGRectMake(0, 0, NormalBtnSize, NormalBtnSize)];
        [self addSubview:slider];
        _progressSlider = slider;
        
        YYTPlayTimeLabel *label = [[YYTPlayTimeLabel alloc] initWithFrame:CGRectMake(0, 0, 80, NormalBtnSize)];
        [self addSubview:label];
        _progressLabel = label;
    }
    return self;
}

- (UIView *)volumeView
{
    if (!_volumeView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
        YYTVolumeView *volView = [[YYTVolumeView alloc] initWithFrame:CGRectMake(5, 15, 220, 20)];
        volView.showsVolumeSlider = YES;
        volView.showsRouteButton = NO;
        [view addSubview:volView];
        view.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        _volumeView = view;
    }
    return _volumeView;
}

- (void)setAirplayBtnHidden:(BOOL)hidden
{    
    if (_airplayView.hidden != hidden) {
        _airplayView.hidden = NO;
        [self setNeedsLayout];
    }
}

- (void)setVideoRelatedBtnEnabled:(BOOL)enable
{
    self.progressSlider.enabled = enable;
    self.qualityBtn.enabled = enable;
}

- (void)layoutSubviews
{
    const CGFloat space = 4;
    CGFloat itemWidth = NormalBtnSize + space;
    
    CGFloat x = itemWidth/2;
    CGFloat y = 25;

    
    if (self.prevBtn.hidden == NO) {
        self.prevBtn.center = CGPointMake(x, y);
        x += itemWidth;
    }
    
    if (self.playBtn.hidden == NO) {
        self.playBtn.center = CGPointMake(x, y);
        x += itemWidth;
    }
    
    if (self.nextBtn.hidden == NO) {
        self.nextBtn.center = CGPointMake(x, y);
        x += itemWidth;
    }
    //进度条前按钮完毕，设x为进度条起始值
    x -= itemWidth/2;
    
    
    CGFloat endX = CGRectGetWidth(self.bounds)+itemWidth/2;
    
    if (self.fullScreenBtn.hidden == NO) {
        endX -= itemWidth;
        //self.fullScreenBtn.backgroundColor = [UIColor blueColor];
        self.fullScreenBtn.center = CGPointMake(endX, y);
    }
    
    if (self.playOrderBtn.hidden == NO) {
        endX -= itemWidth;
        self.playOrderBtn.center = CGPointMake(endX, y);
    }
    
    if (self.singleRepBtn.hidden == NO) {
        endX -= itemWidth;
        //self.singleRepBtn.backgroundColor = [UIColor yellowColor];
        self.singleRepBtn.center = CGPointMake(endX, y);
    }
    
    if (self.volumeBtn.hidden == NO) {
        endX -= itemWidth;
        self.volumeBtn.center = CGPointMake(endX, y);
    }
    
    if (self.qualityBtn.hidden == NO) {
        endX -= itemWidth;
        //self.qualityBtn.backgroundColor = [UIColor greenColor];
        self.qualityBtn.center = CGPointMake(endX, y);
    }
    
    if (_airplayView.hidden == NO) {
        endX -= itemWidth;
        _airplayView.center = CGPointMake(endX, y);
        itemWidth = CGRectGetWidth(_airplayView.frame);
    }
    
    if (self.progressLabel.hidden == NO) {
        endX -= itemWidth/2;
        itemWidth = CGRectGetWidth(self.progressLabel.frame)+space;
        endX -= itemWidth/2;
        self.progressLabel.center = CGPointMake(endX, y);
    }
    
    endX -= itemWidth/2;
    
    //播放进度
    if (self.progressSlider.hidden == NO) {
        //得到进度条长度
        CGFloat width = endX - x;
        self.progressSlider.frame = CGRectMake(x, 0, width, NormalBtnSize);
    }
    
}

@end
