//
//  YYTLocalPlayerViewController.m
//  YYTHD
//
//  Created by IAN on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTLocalPlayerViewController.h"

@interface YYTLocalPlayerViewController ()

@end

@implementation YYTLocalPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"YYTMoviePlayerViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    YYTPlayerBar *playerBar = self.controlView.playerBar;
    
    self.downloadBtn.hidden = YES;
    playerBar.prevBtn.hidden = YES;
    playerBar.nextBtn.hidden = YES;
    playerBar.playOrderBtn.hidden = YES;
    playerBar.qualityBtn.enabled = NO;
    playerBar.volumeBtn.hidden = NO;
    playerBar.singleRepBtn.hidden = NO;
    playerBar.fullScreenBtn.hidden = YES;
    [playerBar setNeedsLayout];
    
    self.controlView.fullScreen = YES;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
