//
//  PullToRefreshView.m
//  YYTHD
//
//  Created by ssj on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PullToRefreshView.h"
#import "GifView.h"

@implementation PullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(55, 27);
}

+ (UIView *)setCustomViewWaiteForState:(SVPullToRefreshState)state{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 30, 30)];
    UIImageView *pullRefresh = [[UIImageView alloc] initWithFrame:CGRectMake(-3, 8, 15, 8)];
    pullRefresh.image = [UIImage imageNamed:@"pullToRefreshOther"];
    [view addSubview:pullRefresh];
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RefreshViewWaite@2x" ofType:@"gif"]];
    pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
    pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(-20, 0, 55, 27) data:localData];
    view.backgroundColor = [UIColor whiteColor];
    gifView.backgroundColor =[UIColor whiteColor];
    gifView.center = pullRefresh.center;
    [view addSubview:gifView];
    if (state == SVPullToRefreshStateLoading) {
        pullRefresh.hidden = YES;
        return view;
    }else if (state == SVPullToRefreshStateTriggered){
        //        pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
        //        pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
        pullRefresh.hidden = NO;
        gifView.hidden = YES;
        return view;
    }else if (state == SVPullToRefreshStateStopped){
        pullRefresh.hidden = YES;
        gifView.hidden = YES;
        return view;
    }else{
        pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
        pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
        pullRefresh.hidden = YES;
        gifView.hidden = YES;
        return view;
    }
    return view;
}


+ (UIView *)setCustomViewForState:(SVPullToRefreshState)state{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 30, 30)];
    UIImageView *pullRefresh = [[UIImageView alloc] initWithFrame:CGRectMake(-3, 8, 15, 8)];
    pullRefresh.image = [UIImage imageNamed:@"pullToRefreshOther"];
    [view addSubview:pullRefresh];
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RefreshView@2x" ofType:@"gif"]];
    pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
    pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(-20, 0, 55, 27) data:localData];
    view.backgroundColor = [UIColor clearColor];
    gifView.center = pullRefresh.center;
    [view addSubview:gifView];
    if (state == SVPullToRefreshStateLoading) {
        pullRefresh.hidden = YES;
        return view;
    }else if (state == SVPullToRefreshStateTriggered){
//        pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
//        pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
        pullRefresh.hidden = NO;
        gifView.hidden = YES;
        return view;
    }else if (state == SVPullToRefreshStateStopped){
        pullRefresh.hidden = YES;
        gifView.hidden = YES;
        return view;
    }else{
        pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
        pullRefresh.frame = CGRectMake(-3, -2, 15, 8);
        pullRefresh.hidden = YES;
        gifView.hidden = YES;
        return view;
    }
    return view;
}

//- (UIView *)setCustomViewForState:(SVPullToRefreshState)state{
//    
//    if (state == SVInfiniteScrollingStateLoading) {
//        pullImageView.hidden = YES;
//        firView.hidden = NO;
//        secView.hidden = NO;
//        thirView.hidden = NO;
////        [self viewBigAnimation:firView];
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(beginCycle) userInfo:nil repeats:YES];
//
//    }else if (state == SVInfiniteScrollingStateStopped){
//        pullImageView.hidden = NO;
//        firView.hidden = YES;
//        secView.hidden = YES;
//        thirView.hidden = YES;
//    }else if (state == SVInfiniteScrollingStateTriggered){
//        pullImageView.hidden = NO;
//        firView.hidden = YES;
//        secView.hidden = YES;
//        thirView.hidden = YES;
//    }
//    return self;
//}

@end
