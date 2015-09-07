//
//  PickMLViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/28/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "PickMLViewController.h"
#import "PullToRefreshView.h"

@interface PickMLViewController ()

@end

@implementation PickMLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emptyViewController.holderImage = IMAGE(@"网络断开");
    self.emptyViewController.holderText = NONETWORK;
    
    [self.topView setTitleImage:[UIImage imageNamed:@"ml_picklist_title"]];
    
    [self fetchPickMLList];
    
    [_gridView addPullToRefreshWithActionHandler:^{
        [self fetchPickMLList];
    }];
    [_gridView addInfiniteScrollingWithActionHandler:^{
        [self morePickMLList];
    }];
    
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    [_gridView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self fetchPickMLList];
}

- (void)refreshData
{
    [self fetchPickMLList];
}

@end
