//
//  SearchViewController.h
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDataController.h"
#import "ArtistDetailView.h"
#import "MVItemView.h"
#import "Artist.h"
#import "MVAristDataController.h"
#import "CombinationView.h"
#import "PreSearchViewController.h"
#import "ArtistComSearchView.h"
#import "SearchHistoryDataController.h"
#import "YYTActivityIndicatorView.h"
#import "EmptyViewController.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ArtistDetailViewDelegate,MVItemViewDelegate,CombinationViewDelegate,PreSearchViewControllerDelegate,UITextFieldDelegate,ArtistComSearchViewDelegate,YYTActivitySubViewDelegate,EmptyViewControllerDelegate>{
    SearchDataController *searchDataController;
    MVAristDataController *artistDataController;
    int currentIndex;
    int topHight;
    ArtistComSearchView *areaView;
    ArtistComSearchView *singerTypeView;
    ArtistComSearchView *videoTypeView;
    int addComSearch;
    SearchHistoryDataController *searchHistoryDataController;
    UIView *_searchView;
    
}
@property (strong, nonatomic) UIView *textBackgroungView;
@property (weak, nonatomic) IBOutlet UIButton *cleanTextBtn;
@property (weak, nonatomic) IBOutlet UIButton *comSearch;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UIImageView *searchBackVIew;
@property (weak, nonatomic) IBOutlet UIButton *searchByNewBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchByHotBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (assign, nonatomic) BOOL isHistory;
@property (strong, nonatomic) NSArray *searchSuggestList;
@property(retain,nonatomic) PreSearchViewController* preSearchViewController;
@property (strong, nonatomic) NSArray *videoList;
@property (strong, nonatomic) Artist *artist;
@property (copy, nonatomic) NSString *keyword;

@property(assign,nonatomic) BOOL bOn;   //YES出现条件选择
@property (strong, nonatomic) NSMutableDictionary *searchParams;

//无数据时的界面
@property(retain,nonatomic) EmptyViewController* emptyViewController;
- (void)checkEmpty:(id)data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyWord:(NSString *)keyWord;

@end
