//
//  BaseViewController.h
//  YYTHD
//
//  Created by btxkenshin on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuView.h"
#import "TopView.h"
#import "SearchDataController.h"
#import "SearchViewController.h"
#import "SearchHistoryDataController.h"
#import "RNFrostedSidebar.h"
#import "DRNRealTimeBlurView.h"
#import "EmptyViewController.h"

@interface BaseViewController : UIViewController<TopViewDelegate,PreSearchViewControllerDelegate,RNFrostedSidebarDelegate,EmptyViewControllerDelegate>{
    SearchDataController *searchDataController;
    SearchHistoryDataController *searchHistoryDataController;
}
@property (strong, nonatomic)DRNRealTimeBlurView *blurView;
@property (nonatomic ,assign) BOOL isHistory;
@property (nonatomic, strong) NSArray *searchSuggestList;
@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) UIView *statusBarBackView;
@property (retain,nonatomic) PreSearchViewController* preSearchViewController;
@property (strong, nonatomic) UIView *textBackgroungView;

//无数据时的界面
@property(retain,nonatomic) EmptyViewController* emptyViewController;
- (void)checkEmpty:(id)data;

- (void)resetTopView:(BOOL)isRoot;

- (void)btnBackWillClicked;
- (void)btnBackClicked;
- (void)showUnreadImage;

- (void)makeAllModuleEntranceDisappear:(BOOL)disappear;

@end
