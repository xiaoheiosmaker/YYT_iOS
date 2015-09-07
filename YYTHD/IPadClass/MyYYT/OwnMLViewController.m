//
//  OwnMLViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "OwnMLViewController.h"
#import "UserDataController.h"
#import "MLItem.h"
#import "MLDataController.h"
#import "TopView.h"
#import "AlertWithTip.h"
#import "PullToRefreshView.h"
#import "EditableMLParticularViewController.h"

@interface OwnMLViewController ()

@end

@implementation OwnMLViewController

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
    
    self.emptyViewController.holderImage = IMAGE(@"无创建悦单");
    self.emptyViewController.holderText = NOOWNML;
    
    [self.topView isShowTimeButton:NO];
    [self.topView isShowTextField:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"ml_ownlist_title"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchOwnMLList];
    [_gridView addPullToRefreshWithActionHandler:^{
        [self fetchOwnMLList];
    }];
    [_gridView addInfiniteScrollingWithActionHandler:^{
        [self moreOwnMLList];
    }];
    
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [_gridView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    [_gridView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    [MobClick event:@"Edit" label:@"编辑我创建的悦单"];
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
            [AlertWithTip flashSuccessMessage:@"删除悦单成功"];
        }
        
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] deleteOwnML:item completionBlock:completion];
}

#pragma mark - Override BaseViewController
- (void)btnBackClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    MLItem *item = [self.mlList objectAtIndex:position];
    EditableMLParticularViewController *partVC = [[EditableMLParticularViewController alloc] init];
    partVC.item = item;
    [self.navigationController pushViewController:partVC animated:YES];
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self fetchOwnMLList];
}

@end
