//
//  YYTPlayerControlView.h
//  YYTHD
//
//  Created by IAN on 13-12-10.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTPlayerBar.h"
#import "YYTMovieItem.h"

@class YYTMoviePlayerController;
@class YYTPlayerMVPickerView;

@interface YYTPlayerControlView : UIView

@property (nonatomic, readonly) YYTPlayerMVPickerView *mvPickerView;
@property (nonatomic, readonly) UIView *topBar;
@property (nonatomic, readonly) YYTPlayerBar *playerBar;
@property (nonatomic, readwrite) BOOL fullScreen;

- (void)observeMoviePlayer:(YYTMoviePlayerController *)moviePlayerController;
//- (void)showBarsWithAutoHide:(BOOL)autoHide;

- (void)lockBars;
- (void)unlockBars;

- (void)addPlayerTopBar:(UIView *)topBar;
- (void)addMVPickerView:(YYTPlayerMVPickerView *)mvPickerView;

- (void)exitFullScreen;
- (BOOL)canExitFullScreen;

@end
