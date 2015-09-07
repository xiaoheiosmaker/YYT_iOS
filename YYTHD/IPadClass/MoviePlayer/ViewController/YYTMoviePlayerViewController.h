//
//  YYTMoviePlayerViewController.h
//  YYTHD
//
//  Created by IAN on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "PlatformSelectViewController.h"
#import "YYTPlayerControlView.h"
#import "YYTMoviePlayerController.h"

@class YYTPlayerStatisticHelper;

@interface YYTMoviePlayerViewController : UIViewController

+ (YYTMoviePlayerViewController *)downloadMoviePlayerViewController;
+ (YYTMoviePlayerViewController *)moviePlayerViewController;
+ (YYTMoviePlayerViewController *)movieListPlayerViewControllerWithMLItem:(MLItem *)mlItem;

@property (nonatomic, readonly) YYTMoviePlayerController *moviePlayer;

- (void)loadPlayList:(NSArray *)playList startImmediately:(BOOL)immediately;

- (void)playMVItemAtIndex:(NSInteger)index;
- (void)stopPlaying;

- (NSInteger)currentIndex;

@end


@interface YYTMoviePlayerViewController () <UIPopoverControllerDelegate,PlatformSelectViewControllerDelegate,PopoverViewDelegate>
{
    __weak PopoverView *_downloadPopover;
    UIView *_timedOutView;
}

@property (nonatomic, strong) YYTPlayerStatisticHelper *statisticHelper;

@property (nonatomic, strong) YYTPlayerControlView *controlView;
@property (nonatomic, strong) YYTMoviePlayerController *moviePlayer;
@property (nonatomic, weak) UIView *movieView;
@property (nonatomic, strong) UIPopoverController *sharePopoverController;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@end