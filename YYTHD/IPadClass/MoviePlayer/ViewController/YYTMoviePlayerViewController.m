//
//  YYTMoviePlayerViewController.m
//  YYTHD
//
//  Created by IAN on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTMoviePlayerViewController.h"
#import "YYTMoviePlayerController.h"
#import "MVPickerItemView.h"
#import "YYTPlayerControlView.h"
#import "PopoverView.h"
#import "DownloadManager.h"
#import "MVItem.h"
#import "UserDataController.h"
#import "MVDataController.h"
#import "PlatformSelectViewController.h"
#import "YYTPopoverBackgroundView.h"
#import "PlayHistoryDataController.h"
#import "YYTPlayerStatisticHelper.h"

#import "YYTLocalPlayerViewController.h"
#import "YYTMLPlayerViewController.h"

@implementation YYTMoviePlayerViewController

+ (YYTMoviePlayerViewController *)downloadMoviePlayerViewController
{
    YYTLocalPlayerViewController *playerViewController = [[YYTLocalPlayerViewController alloc] init];
    
    return playerViewController;
}

+ (YYTMoviePlayerViewController *)moviePlayerViewController
{
    YYTMoviePlayerViewController *playerViewController = [[YYTMoviePlayerViewController alloc] init];
    
    return playerViewController;
}

+ (YYTMoviePlayerViewController *)movieListPlayerViewControllerWithMLItem:(MLItem *)mlItem
{
    YYTMoviePlayerViewController *playerViewController = [[YYTMLPlayerViewController alloc] initWithMLItem:mlItem];
    return playerViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.moviePlayer = [[YYTMoviePlayerController alloc] init];
        self.statisticHelper = [[YYTPlayerStatisticHelper alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self stopPlaying];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"player_bg"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:imageView];
    
    [self.view addSubview:self.controlView];
    [self.controlView addPlayerTopBar:self.topView];
    
    //MV播放界面
    YYTPlayerBar *playerBar = self.controlView.playerBar;
    playerBar.prevBtn.hidden = YES;
    playerBar.nextBtn.hidden = YES;
    playerBar.playOrderBtn.hidden = YES;
    playerBar.volumeBtn.hidden = NO;
    playerBar.singleRepBtn.hidden = YES;
    [playerBar setNeedsLayout];
    
    self.controlView.fullScreen = NO;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    
    [self observeMoviePlayerNotifications];
    [self.statisticHelper workWithMoviePlayer:self.moviePlayer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPlaying];
}

#pragma mark - Getter
- (YYTPlayerControlView *)controlView
{
    if (!_controlView) {
        YYTPlayerControlView *controlView = [[YYTPlayerControlView alloc] initWithFrame:self.view.bounds];
        [controlView observeMoviePlayer:self.moviePlayer];
        _controlView = controlView;
    }
    return _controlView;
}

- (NSInteger)currentIndex
{
    return self.moviePlayer.currentIndex;
}

#pragma mark -
- (void)loadPlayList:(NSArray *)playList startImmediately:(BOOL)immediately
{
    [self.moviePlayer setMoviePlayListWithMovieItems:playList];
    if (immediately) {
        [self playMVItemAtIndex:0];
    }
}

- (void)playMVItemAtIndex:(NSInteger)index
{
    [self.moviePlayer playMovieAtIndex:index];
}

- (void)stopPlaying
{
    [self.moviePlayer stop];
}

#pragma mark - MoviePlayer Notification
- (void)observeMoviePlayerNotifications
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerReadyForDisplayDidChange:)
                                                     name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                                   object:self.moviePlayer];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieDidFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerNowPlayingMovieDidChange:)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(airPlayVideoActiveDidChange:)
                                                 name:MPMoviePlayerIsAirPlayVideoActiveDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieTimedOutStateDidChange:)
                                                 name:YYTMoviePlayerTimedOutStateDidChangeNotificaiton
                                               object:self.moviePlayer];
}

- (void)moviePlayerNowPlayingMovieDidChange:(id)sender
{
    if (self.moviePlayer.contentURL) {
        [self addHistoryRecord];
        [self removeTimedOutView];
    }
}

- (void)moviePlayerReadyForDisplayDidChange:(id)sender
{
    if (!self.moviePlayer.contentURL) {
        return;
    }
    
    UIView *movieView = self.moviePlayer.view;
    if (self.movieView != movieView) {
        //[self.controlView removeFromSuperview];
        [self.movieView removeFromSuperview];
        self.movieView = movieView;
        if (movieView) {
            movieView.frame = self.view.bounds;
            movieView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.view insertSubview:movieView belowSubview:self.controlView];
            //[movieView addSubview:self.controlView];
            //[self.view addSubview:movieView];
        }
    }
}

- (void)movieDidFinished:(id)sender
{
    if (self.movieView) {
        //self.movieView.hidden = YES;
    }
}

- (void)showTimedOutView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"视频长时间没有开始播放，请点击刷新" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(timedOutBtnTapEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [self.view insertSubview:view aboveSubview:self.controlView];
    _timedOutView = view;
}

- (void)removeTimedOutView
{
    if (_timedOutView) {
        [_timedOutView removeFromSuperview];
        _timedOutView = nil;
    }
}

- (void)timedOutBtnTapEvent:(id)sender
{
    [self.moviePlayer stop];
    [self.moviePlayer play];
    [self removeTimedOutView];
}

- (void)movieTimedOutStateDidChange:(id)sender
{
    if (self.moviePlayer.timedOut) {
        [self showTimedOutView];
    }
    else {
        [self removeTimedOutView];
    }
}

- (void)airPlayVideoActiveDidChange:(id)sender
{
    if (self.moviePlayer.airPlayVideoActive == YES) {
        [MobClick event:@"Airplay" label:@"Airplay点击次数"];
    }
}

#pragma mark - Top Bar Actions
- (IBAction)backBtnClicked:(id)sender
{
    if ([self.controlView canExitFullScreen]) {
        [self.controlView exitFullScreen];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)downloadBtnClicked:(id)sender
{
    if (_downloadPopover) {
        return;
    }
    
    id<YYTMovieItem> item = [self.moviePlayer playingMovieItem];
    
    CGFloat btnWidth = 309;
    CGFloat btnHeight = 46;
    CGFloat space_x = 10;
    CGFloat space_y = 10;
    
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:3];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, btnWidth, 30)];
    label.text = @"请选择清晰度：";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    [views addObject:view];
    
    if ([item movieURLForQuality:YYTMovieQualityDefault]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, btnHeight+space_y*2)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(downloadQualityBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"标清" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(space_x, 0, btnWidth, btnHeight)];
        btn.tag = YYTMovieQualityDefault;
        [view addSubview:btn];
        
        [views addObject:view];
    }
    
    if ([item movieURLForQuality:YYTMovieQualityHD]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, btnHeight+space_y*2)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(downloadQualityBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"高清" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(space_x, 0, btnWidth, btnHeight)];
        btn.tag = YYTMovieQualityHD;
        [view addSubview:btn];
        
        [views addObject:view];
    }
    
    CGFloat x = [sender center].x;
    CGFloat y = CGRectGetHeight([[sender superview] bounds]);
    CGPoint point = [self.controlView convertPoint:CGPointMake(x, y) fromView:[sender superview]];
    PopoverView* popView = [PopoverView showPopoverAtPoint:point inView:self.controlView withViewArray:views delegate:self];
    _downloadPopover = popView;
    
    [self.controlView lockBars];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    [self.controlView unlockBars];
}

- (void)downloadQualityBtnDidSelected:(UIButton *)sender
{
    [_downloadPopover dismiss:YES];
    
    id item = [self.moviePlayer playingMovieItem];
    if ([item isKindOfClass:[MVItem class]]) {
        YYTMovieQuality qualiy = sender.tag;
        [MobClick event:@"Down_Mv" label:@"全屏播放页"];
        [[DownloadManager sharedDownloadManager] downloadMVItem:item quality:qualiy];
    }
}

- (IBAction)collectBtnClicked:(id)sender
{
    id item = [self.moviePlayer playingMovieItem];
    if (item == nil) {
        return;
    }
    
    if (![[UserDataController sharedInstance] isLogin]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        CGSize origSize = loginViewController.view.frame.size;
        [self presentViewController:loginViewController animated:NO completion:^{
            UIView *view = loginViewController.view;
            UIView *superView = view.superview;
            superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            NSArray *subViews = superView.subviews;
            for (UIView *subView in subViews) {
                if (subView != view) {
                    subView.hidden = YES;
                }
            }
            CGPoint curCenter = superView.center;
            superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
            superView.center = curCenter;
        }];
        return;
    }
    
    [sender setEnabled:NO];
    [MobClick event:@"Collect_Mv" label:@"全屏播放页"];
    [[MVDataController sharedDataController] addCollection:item
                                     withCompletionHandler:^(NSString *message, NSError *error) {
                                         [sender setEnabled:YES];
                                         if (error) {
                                             if (message == nil) {
                                                 message = [error yytErrorMessage];
                                             }
                                             [self alertFailedMessage:message];
                                         }
                                         else {
                                             [self alertSucessMessage:message];
                                         }
                                     }];
}

- (IBAction)shareBtnClicked:(id)sender
{
    id item = [self.moviePlayer playingMovieItem];
    if (item) {
        [MobClick event:@"Share_Mv" label:@"全屏播放页点击分享"];
        [self.sharePopoverController presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.controlView lockBars];
    }
}

#pragma mark - Share
- (UIPopoverController *)sharePopoverController
{
    if (_sharePopoverController == nil) {
        PlatformSelectViewController *viewController = [[PlatformSelectViewController alloc] init];
        viewController.delegate = self;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
        popover.delegate = self;
        popover.popoverBackgroundViewClass = [YYTPopoverBackgroundView class];
        _sharePopoverController = popover;
    }
    
    return _sharePopoverController;
}

- (void)selectOpenPlatform:(int)opType
{
    [self.sharePopoverController dismissPopoverAnimated:YES];
    [self.controlView unlockBars];
    
    MVItem *item = (MVItem *)[self.moviePlayer playingMovieItem];
    NSNumber *videoId = nil;
    NSString *imagePath = nil;
    if ([item isKindOfClass:[MVDownloadItem class]]) {
        MVDownloadItem *downloadItem = (MVDownloadItem *)item;
        videoId = [downloadItem videoID];
        imagePath = [downloadItem.thumbnailPic absoluteString];
    }
    else {
        videoId = item.keyID;
        imagePath = [item.coverImageURL absoluteString];
    }
    
    [MobClick event:@"Share_Mv" label:@"全屏播放页点击分享"];
    UIViewController *container = self.presentingViewController ? self : nil;
    [[ShareAssistantController sharedInstance] shareMVItem:item toOpenPlatform:opType inViewController:self completion:^(BOOL success, NSError *err) {
        
    }];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.sharePopoverController) {
        //[self.controlView showBarsWithAutoHide:YES];
        [self.controlView unlockBars];
    }
}

#pragma mark - PlayHistory
- (void)addHistoryRecord
{
    MVItem *item = (MVItem *)self.moviePlayer.playingMovieItem;
    if ([item isKindOfClass:[MVItem class]]) {
        [[PlayHistoryDataController sharedInstance] addMVItem:item];
    }
}

#pragma mark - Alert & Loading
- (void)alertSucessMessage:(NSString *)message
{
    [AlertWithTip flashSuccessMessage:message];
}

- (void)alertFailedMessage:(NSString *)message
{
    [AlertWithTip flashFailedMessage:message];
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
