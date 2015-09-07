//
//  YYTPlayerControlView.m
//  YYTHD
//
//  Created by IAN on 13-12-10.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPlayerControlView.h"
#import "YYTMoviePlayerController.h"
#import "PopoverView.h"
#import "YYTPlayerMVPickerView.h"

static const NSTimeInterval HideBarsDelay = 5.0f;
static BOOL LoadingCautionViewClosed = NO;

@interface YYTPlayerControlView ()<PopoverViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,YYTPlayerMVPickerDelegate>
{
    __weak PopoverView *_qualityPopView;
    __weak PopoverView *_volumePopView;
    __weak PopoverView *_playOrderPopView;
    
    UIView *_loadingCautionView;
    
    UIView *_miniSuperView;
    CGRect _miniFrame;
    
    BOOL _playBarIsShown;
    BOOL _needRefreshProgress;
    BOOL _lockBar;
}

@property (nonatomic, weak) YYTMoviePlayerController *moviePlayer;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) YYTPlayerBar *playerBar;
@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation YYTPlayerControlView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
        self.controlView = view;
        
        [self setupPlayerBar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayViewAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _playBarIsShown = YES;
        _needRefreshProgress = YES;
    }
    return self;
}

- (void)showLoadingCautionView
{
    CGFloat y = CGRectGetHeight(self.controlView.frame) - CGRectGetHeight(self.playerBar.frame)-25;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.controlView.frame), 25)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    
    const CGFloat originY = 5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, originY, 260, 25)];
    label.text = @"当前网络网速较慢，建议您切换到";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHEXColor:0xe5e5e5];
    [label sizeToFit];
    [view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 24, 25);
    [btn setTitle:@"标清" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor yytGreenColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(switchToDefaultQuality) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), originY, 100, 25)];
    label.text = @"下播放";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHEXColor:0xe5e5e5];
    [label sizeToFit];
    [view addSubview:label];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(CGRectGetWidth(view.frame)-30, 0, 25, 25);
    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [closeBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"btn_close_h"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeLoadingCautionView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.controlView addSubview:view];
    
    _loadingCautionView = view;
}

- (void)switchToDefaultQuality
{
    [self applyVideoQuality:YYTMovieQualityDefault];
    [_loadingCautionView removeFromSuperview];
}

- (void)closeLoadingCautionView
{
    [_loadingCautionView removeFromSuperview];
    LoadingCautionViewClosed = YES;
}


- (void)addPlayerTopBar:(UIView *)topBar
{
    if (self.topBar) {
        [self.topBar removeFromSuperview];
    }
    
    _topBar = topBar;
    [self.controlView addSubview:topBar];
}

- (void)addMVPickerView:(YYTPlayerMVPickerView *)mvPickerView
{
    if (self.mvPickerView) {
        [self.mvPickerView removeFromSuperview];
    }
    
    _mvPickerView = mvPickerView;
    mvPickerView.delegate = self;
    mvPickerView.scrollDelegate = self;
    [self.controlView addSubview:mvPickerView];
}

- (void)exitFullScreen
{
    if (self.fullScreen) {
        [self quitFullScreenBtnClicked:nil];
    }
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    self.topBar.hidden = !fullScreen;
}

- (void)setupPlayerBar
{
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.bounds)-50, CGRectGetWidth(self.bounds),50);
    YYTPlayerBar *playerBar = [[YYTPlayerBar alloc] initWithFrame:frame];
    playerBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.controlView addSubview:playerBar];
    self.playerBar = playerBar;
    
    //为playerBar中的按钮添加对应方法
    UIButton *btn = playerBar.playBtn;
    [btn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.prevBtn;
    [btn addTarget:self action:@selector(playPrevBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.nextBtn;
    [btn addTarget:self action:@selector(playNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.qualityBtn;
    [btn addTarget:self action:@selector(videoQualityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.volumeBtn;
    [btn addTarget:self action:@selector(volumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.playOrderBtn;
    [btn addTarget:self action:@selector(playOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.singleRepBtn;
    [btn addTarget:self action:@selector(singleRepBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn = playerBar.fullScreenBtn;
    [btn addTarget:self action:@selector(fullScreenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    YYTSlider *slider = _playerBar.progressSlider;
    [slider addTarget:self action:@selector(progressSliderBeginTouch:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(progressDidChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(progressSliderEndTouch:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
}

#pragma mark - Player Bar Actions
- (void)playPrevBtnClicked:(id)sender
{
    [self.moviePlayer playPrev];
}

- (void)playNextBtnClicked:(id)sender
{
    [self.moviePlayer playNext];
}

- (void)playBtnClicked:(ExButton *)sender
{
    bool paused = [sender exSelected];
    if (!paused) {
        [self.moviePlayer play];
    }
    else {
        [self.moviePlayer pause];
    }
}

#pragma mark progress
- (void)progressDidChanged:(YYTSlider *)sender
{
    [self progressTimeLabel];
}

- (void)progressSliderBeginTouch:(YYTSlider *)sender
{
    [self showBarsWithAutoHide:NO];
}

- (void)progressSliderEndTouch:(YYTSlider *)sender
{
    CGFloat progress = sender.progress;
    NSTimeInterval targetTime = self.moviePlayer.duration * progress;
    self.moviePlayer.currentPlaybackTime = targetTime;
    [self showBarsWithAutoHide:YES];
}

- (void)singleRepBtnClicked:(id)sender
{
    BOOL rep = [sender isSelected];
    if (rep) {
        self.moviePlayer.yytRepeatMode = YYTMovieRepeatModeNone;
    }
    else {
        self.moviePlayer.yytRepeatMode = YYTMovieRepeatModeOne;
        [AlertWithTip flashSuccessMessage:@"单曲循环"];
    }
    
    [sender setSelected:!rep];
}

#pragma mark VideoQuality
- (void)videoQualityBtnClicked:(id)sender
{
    if (_qualityPopView) {
        return;
    }
    
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    if (!item) {
        return;
    }
    
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:2];
    NSInteger qualitys[] = {YYTMovieQualityUHD, YYTMovieQualityHD, YYTMovieQualityDefault};
    YYTMovieQuality curQuality = self.moviePlayer.playingQuality;
    for (int i=0; i < 3; ++i) {
        YYTMovieQuality quality = qualitys[i];
        if (item && ![item movieURLForQuality:quality]) {
            continue;
        }
        YYTMovieQualityButton *btn = [[YYTMovieQualityButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        btn.quality = quality;
        btn.selected = (quality==curQuality);
        [btn addTarget:self action:@selector(videoQualityBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:btn];
    }
    
    CGFloat x = [sender center].x;
    CGFloat y = CGRectGetMinY([sender frame]);
    CGPoint point = [self convertPoint:CGPointMake(x, y) fromView:[sender superview]];
    PopoverView* popView = [PopoverView showPopoverAtPoint:point inView:self withViewArray:views delegate:self];
    _qualityPopView = popView;

    [self lockBars];
}

- (void)videoQualityBtnDidSelected:(YYTMovieQualityButton *)sender
{
    [self applyVideoQuality:sender.quality];
    [_qualityPopView dismiss:YES];
}

- (void)applyVideoQuality:(YYTMovieQuality)quality
{
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    NSURL *url = [item movieURLForQuality:quality];
    if (item && !url) {
        //该清晰度不可选
        return;
    }
    
    NSURL *playingURL = self.moviePlayer.contentURL;
    if (![url isEqual:playingURL]) {
        self.moviePlayer.preferredQuality = quality;
        self.playerBar.qualityBtn.quality = quality;
    }
}

- (void)volumeBtnClicked:(id)sender
{
    if (_volumePopView) {
        return;
    }
    
    CGFloat x = [sender center].x;
    CGFloat y = CGRectGetMinY([sender frame]);
    
    CGPoint point = [self convertPoint:CGPointMake(x, y) fromView:[sender superview]];
    UIView *volSliderView = self.playerBar.volumeView;
    PopoverView* popView = [PopoverView showPopoverAtPoint:point inView:self withContentView:volSliderView delegate:self];
    _volumePopView = popView;
    
    [self lockBars];
}

- (void)playOrderBtnClicked:(id)sender
{
    if (_playOrderPopView) {
        return;
    }
    
    YYTMoviePlayOrder orders[] = {YYTMoviePlayOrderNone, YYTMoviePlayOrderRepeatAll, YYTMoviePlayOrderRepeatOne, YYTMoviePlayOrderShuffle};
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; ++i) {
        YYTPlayOrderButton *btn = [[YYTPlayOrderButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        btn.playOrder = orders[i];
        [btn addTarget:self action:@selector(playOrderBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:btn];
    }
    
    CGFloat x = [sender center].x;
    CGFloat y = CGRectGetMinY([sender frame]);
    CGPoint point = [self convertPoint:CGPointMake(x, y) fromView:[sender superview]];
    PopoverView* popView = [PopoverView showPopoverAtPoint:point inView:self withViewArray:views delegate:self];
    _playOrderPopView = popView;
    
    [self lockBars];
}

- (void)playOrderBtnDidSelected:(YYTPlayOrderButton *)sender
{
    YYTMoviePlayOrder order = [sender playOrder];
    [self applyMoviePlayOrder:order];
    [_playOrderPopView dismiss];
    _playOrderPopView = nil;
}

- (void)applyMoviePlayOrder:(YYTMoviePlayOrder)order
{
    self.playerBar.playOrderBtn.playOrder = order;
    
    YYTMovieRepeatMode repeatMode;
    BOOL shuffle = NO;
    NSString *tip = nil;
    NSString *mobLabel = nil;
    switch (order) {
        case YYTMoviePlayOrderNone:
        {
            tip = @"顺序播放";
            repeatMode = YYTMovieRepeatModeNone;
            mobLabel = @"选择悦单顺序模式";
            break;
        }
        case YYTMoviePlayOrderRepeatOne:
        {
            tip = @"单曲循环";
            repeatMode = YYTMovieRepeatModeOne;
            mobLabel = @"选择悦单循环模式";
            break;
        }
        case YYTMoviePlayOrderRepeatAll:
        {
            tip = @"全部循环";
            repeatMode = YYTMovieRepeatModeAll;
            mobLabel = @"选择悦单单曲循环";
            break;
        }
        case YYTMoviePlayOrderShuffle:
        {
            tip = @"随机播放";
            repeatMode = YYTMovieRepeatModeAll;
            mobLabel = @"选择悦单随机播放";
            shuffle = YES;
            break;
        }
        default:
            break;
    }
    
    self.moviePlayer.yytRepeatMode = repeatMode;
    self.moviePlayer.shuffle = shuffle;
    [AlertWithTip flashSuccessMessage:tip];
    [MobClick event:@"About_Yuedan" label:mobLabel];
}

- (void)fullScreenBtnClicked:(ExButton *)sender
{
    if (!self.moviePlayer) {
        return;
    }
    
    if (self.fullScreen) {
        [self quitFullScreenBtnClicked:sender];
        return;
    }
    
    UIView *movieView = [self movieView];
    _miniSuperView = movieView.superview;
    _miniFrame = movieView.frame;
    
    //使动画更加平滑
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *rootView = rootViewController.view;
    //加入一个黑色透明
    if (!self.maskView) {
        UIView *mask = [[UIView alloc] initWithFrame:rootView.bounds];
        mask.backgroundColor = [UIColor clearColor];
        self.maskView = mask;
    }
    [rootView addSubview:self.maskView];
    
    //转换坐标系
    CGRect frame = [rootView convertRect:self.bounds fromView:self];
    movieView.frame = frame;
    [rootView addSubview:movieView];
    
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.fullScreen = YES;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.playerBar.singleRepBtn.hidden = NO;
                         [self.playerBar.fullScreenBtn setExSelected:YES];
                         movieView.frame = rootViewController.view.bounds;
                         self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
                     }
                     completion:^(BOOL finished) {
                         //[self.playerView addSubview:self.topBar];
                         self.topBar.hidden = NO;
                     }
     ];
}

- (void)quitFullScreenBtnClicked:(id)sender
{
    self.topBar.hidden = YES;
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *rootView = rootViewController.view;
    UIView *mask = self.maskView;
    
    CGRect frame = [rootView convertRect:_miniFrame fromView:_miniSuperView];
    
    UIView *movieView = [self movieView];
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.fullScreen = NO;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.playerBar.singleRepBtn.hidden = YES;
                         [self.playerBar.fullScreenBtn setExSelected:NO];
                         movieView.frame = frame;
                         mask.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         movieView.frame = _miniFrame;
                         [_miniSuperView addSubview:movieView];
                         _miniSuperView = nil;
                         [mask removeFromSuperview];
                     }];
}

- (BOOL)canExitFullScreen
{
    return (_miniSuperView != nil);
}

- (UIView *)movieView
{
    return self.superview;
}

#pragma mark - show & hide bar
- (void)tapPlayViewAction:(UIGestureRecognizer *)sender
{
    if (_playBarIsShown) {
        if(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
            [self hideBars];
        }
    }
    else {
        [self showBarsWithAutoHide:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isMemberOfClass:[UIControl class]]) {
        [self showBarsWithAutoHide:YES];
        return NO;
    }
    return YES;
}

- (void)lockBars
{
    _lockBar = YES;
    [self showBarsWithAutoHide:NO];
}

- (void)unlockBars
{
    _lockBar = NO;
    [self showBarsWithAutoHide:YES];
}

- (void)showBarsWithAutoHide:(BOOL)autoHide
{
    //取消上一次自动隐藏
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBars) object:nil];
    
    if (autoHide) {
        if (self.moviePlayer.playbackState != MPMoviePlaybackStatePlaying || _lockBar) {
            autoHide = NO;
        }
    }

    
    if (!self.controlView.hidden) {
        if (autoHide) {
            [self hideBarsAfterDelay:HideBarsDelay];
        }
        return;
    }

    _playBarIsShown = YES;
    self.topBar.hidden = !self.fullScreen;
    self.controlView.hidden = NO;
    if (![SystemSupport versionPriorTo7] && self.fullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    [UIView animateWithDuration:0.35f
                     animations:^{
                         self.controlView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         //自动隐藏
                         if (autoHide) {
                             [self hideBarsAfterDelay:HideBarsDelay];
                         }
                     }];
}

- (void)hideBars
{
    if (self.controlView.hidden || _lockBar) {
        return;
    }
    
    _playBarIsShown = NO;
    if (![SystemSupport versionPriorTo7] && self.fullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    [UIView animateWithDuration:0.35f
                     animations:^{
                         self.controlView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.controlView.hidden = YES;
                     }];
}

- (void)hideBarsAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hideBars) withObject:nil afterDelay:delay];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    [self unlockBars];
}

#pragma mark - 刷新进度
- (void)refreashProgress
{
    if (!_needRefreshProgress) {
        return;
    }
    
    NSTimeInterval playTime = self.moviePlayer.currentPlaybackTime;
    NSTimeInterval length = self.moviePlayer.duration;
    NSTimeInterval playableDuration = self.moviePlayer.playableDuration;
    
    CGFloat progress = playTime/length;
    CGFloat bufferProgress = playableDuration/length;
    
    [self.playerBar.progressLabel setCurrentPlayTime:playTime];
    [self.playerBar.progressLabel setDuration:length];
    
    YYTSlider *slider = self.playerBar.progressSlider;
    slider.progress = progress;
    slider.bufferProgress = bufferProgress;
    //[self.playerBar.progressSlider setValue:progress animated:YES];
}

- (void)progressTimeLabel
{
    NSTimeInterval length = self.moviePlayer.duration;
    if (length > 0) {
        YYTSlider *slider = self.playerBar.progressSlider;
        CGFloat progress = slider.progress;
        NSTimeInterval playTime = length * progress;
        
        [self.playerBar.progressLabel setCurrentPlayTime:playTime];
        [self.playerBar.progressLabel setDuration:length];
    }
}

- (void)resetProgress
{
    CGFloat progress = 0;
    [self.playerBar.progressSlider setProgress:progress];
    [self.playerBar.progressSlider setBufferProgress:progress];

    [self.playerBar.progressLabel setCurrentPlayTime:0];
    [self.playerBar.progressLabel setDuration:0];
}
#pragma mark - MVPickerView
- (void)pickerView:(YYTPlayerMVPickerView *)pickerView didSelectMVItemAtIndex:(NSUInteger)index
{
    [self.moviePlayer playMovieAtIndex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self showBarsWithAutoHide:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self showBarsWithAutoHide:YES];
}

#pragma mark - ObserveMoviePlayer
- (void)reset
{
    [self moviePlayerPlaybackStateDidChange:nil];
    [self moviePlayerPlayingQualityDidChange:nil];
    [self moviePlayerLoadStateDidChange:nil];
    
    //check playOrder
}

- (void)observeMoviePlayer:(YYTMoviePlayerController *)moviePlayerController
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if (self.moviePlayer != moviePlayerController) {
        [center removeObserver:self];
        self.moviePlayer = moviePlayerController;
    }
    
    [self reset];
    
    MPMoviePlayerController *player = moviePlayerController;
    [center addObserver:self
               selector:@selector(moviePlayerPlaybackStateDidChange:)
                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerLoadStateDidChange:)
                   name:MPMoviePlayerLoadStateDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerNowPlayingMovieDidChange:)
                   name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerPlayingQualityDidChange:)
                   name:YYTMoviePlayerPlayingQualityDidChangeNotificaiton
                 object:player];
    [center addObserver:self
               selector:@selector(moviePlayerLoadingCaution:)
                   name:YYTMoviePlayerLoadingCautionNotificaiton
                 object:player];
    
    [center addObserver:self
               selector:@selector(moviePlayerDidFinish:)
                   name:MPMoviePlayerPlaybackDidFinishNotification
                 object:player];
}

- (void)moviePlayerNowPlayingMovieDidChange:(id)sender
{
    if (!self.moviePlayer.contentURL) {
        return;
    }
    
    NSUInteger index = self.moviePlayer.currentIndex;
    [self.mvPickerView showPlayMarkAtIndex:index];
    
    id<YYTMovieItem> item = self.moviePlayer.playingMovieItem;
    UILabel *titleLabel = (UILabel *)[self.topBar viewWithTag:379];
    titleLabel.text = [item title];
    
    MPMovieLoadState state = self.moviePlayer.loadState;
    if (! (state & MPMovieLoadStatePlayable)) {
        [self showLoading];
        //self.playerBar.playBtn.enabled = NO;
    }
}

- (void)moviePlayerPlaybackStateDidChange:(id)sender
{
    MPMoviePlaybackState state = self.moviePlayer.playbackState;
    switch (state) {
        case MPMoviePlaybackStatePlaying:
        {
            [self.playerBar.playBtn setExSelected:YES];
            [self showBarsWithAutoHide:YES];
            if (!self.refreshTimer) {
                self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                     target:self
                                                                   selector:@selector(refreashProgress)
                                                                   userInfo:nil
                                                                    repeats:YES];
            }
            break;
        }
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateInterrupted:
        {
            [self.playerBar.playBtn setExSelected:NO];
            [self showBarsWithAutoHide:NO];
        }
            break;
        case MPMoviePlaybackStateSeekingForward:
            break;
        case MPMoviePlaybackStateSeekingBackward:
            break;
        default:
            break;
    }
}

- (void)moviePlayerDidFinish:(id)sender
{
    [self resetProgress];
    [self hideLoading];
    //self.playerBar.playBtn.enabled = YES;
    
    if (self.refreshTimer) {
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
}

- (void)moviePlayerLoadStateDidChange:(id)sender
{
    MPMovieLoadState state = self.moviePlayer.loadState;
    
    if (state & MPMovieLoadStatePlayable) {
        [self hideLoading];
        //self.playerBar.playBtn.enabled = YES;
    }
    
    if (state & MPMovieLoadStateStalled) {
        [self showLoading];
        //self.playerBar.playBtn.enabled = NO;
    }
    
}

- (void)moviePlayerPlayingQualityDidChange:(id)sender
{
    YYTMovieQuality quality = self.moviePlayer.playingQuality;
    if (quality != YYTMovieQualityNotAvailable) {
        self.playerBar.qualityBtn.quality = quality;
    }
}

- (void)moviePlayerLoadingCaution:(id)sender
{
    if (!LoadingCautionViewClosed && !self.mvPickerView) {
        if (self.moviePlayer.playingQuality != YYTMovieQualityDefault) {
            [self showLoadingCautionView];
        }
    }
}

- (void)showLoading
{
    //UIView *movieView = self.movieView;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.labelText = [NSString stringWithFormat:@"正在加载中..."];
    [self insertSubview:hud atIndex:0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

- (void)hideLoading
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

@end
