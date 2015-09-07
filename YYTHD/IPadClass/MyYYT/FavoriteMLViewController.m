//
//  FavoriteMLViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "FavoriteMLViewController.h"
#import "UserDataController.h"
#import "MLItem.h"
#import "MLDataController.h"
#import "TopView.h"
#import "AlertWithTip.h"
#import "PullToRefreshView.h"

@implementation FavoriteMLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emptyViewController.holderImage = IMAGE(@"没有收藏");
    self.emptyViewController.holderText = NOCOLLECTML;
   
    [self.topView isShowTimeButton:NO];
    [self.topView isShowTextField:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"ml_favoritelist_title"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetchFavoriteMLList];
    [_gridView addPullToRefreshWithActionHandler:^{
        [self fetchFavoriteMLList];
    }];
    [_gridView addInfiniteScrollingWithActionHandler:^{
        [self moreFavoriteMLList];
    }];
    
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    [_gridView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    [MobClick event:@"Edit" label:@"编辑我收藏的悦单"];
}

#pragma mark - Override BaseViewController
- (void)btnBackClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self fetchFavoriteMLList];
}

#pragma mark - Override MLViewController
- (void)deleteItem:(MLItem *)item
{
    void (^completion)(NSArray *, NSError *) = ^(NSArray *newList, NSError *error){
        if (error) {
            [AlertWithTip flashFailedMessage:[error localizedDescription]];
        }
        else {
            self.mlList = [newList mutableCopy];
            [AlertWithTip flashSuccessMessage:@"删除收藏成功"];
        }
        
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] deleteFavoriteML:item completionBlock:completion];
}

@end
