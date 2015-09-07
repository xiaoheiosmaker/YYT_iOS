//
//  YYTMLPlayerViewController.m
//  YYTHD
//
//  Created by IAN on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTMLPlayerViewController.h"
#import "PlayHistoryDataController.h"
#import "MLItem.h"
#import "YYTPlayerStatisticHelper.h"
#import "YYTPlayerMVPickerView.h"

@interface YYTMLPlayerViewController ()<UIScrollViewDelegate>
{
    BOOL _newLoad;
}
@property (nonatomic, strong) MLItem *mlItem;
@property (nonatomic, strong) YYTPlayerMVPickerView *mvpickerView;

@end

@implementation YYTMLPlayerViewController

- (id)initWithMLItem:(MLItem *)mlItem
{
    self = [super initWithNibName:@"YYTMoviePlayerViewController" bundle:nil];
    if (self) {
        self.mlItem = mlItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    YYTPlayerBar *playerBar = self.controlView.playerBar;
    //悦单播放界面
    playerBar.prevBtn.hidden = NO;
    playerBar.nextBtn.hidden = NO;
    playerBar.volumeBtn.hidden = NO;
    playerBar.playOrderBtn.hidden = NO;
    playerBar.singleRepBtn.hidden = YES;
    playerBar.fullScreenBtn.hidden = YES;
    [playerBar setNeedsLayout];
    
    self.controlView.fullScreen = YES;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    [self loadPlayList:self.mlItem.videos startImmediately:NO];
}

- (void)loadPlayList:(NSArray *)playList startImmediately:(BOOL)immediately
{
    if (![playList count]) {
        return;
    }
    
    _newLoad = YES;
    [super loadPlayList:playList startImmediately:immediately];
    [self loadMVPickerView];
}

#pragma mark - MV Picker
- (void)loadMVPickerView
{
    if (!self.mvpickerView) {
        CGFloat top = 532;
        if ([SystemSupport versionPriorTo7]) {
            top = 512;
        }
        YYTPlayerMVPickerView *view = [[YYTPlayerMVPickerView alloc] initWithFrame:CGRectMake(0, top, 1024, 186)];
        [self.controlView addMVPickerView:view];
        self.mvpickerView = view;
    }
    
    NSArray *list = self.mlItem.videos;
    [self.mvpickerView setMVList:list];
}

#pragma mark - PlayHistory
- (void)addHistoryRecord
{
    if (_newLoad) {
        [[PlayHistoryDataController sharedInstance] addMLItem:self.mlItem];
        [YYTPlayerStatisticHelper sendMLStatisticWithMLItem:self.mlItem];
        _newLoad = NO;
    }
}

@end
