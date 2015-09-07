//
//  BaseViewController.m
//  YYTHD
//
//  Created by btxkenshin on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BaseViewController.h"
#import "ArtistOrderViewController.h"
//#import "ArtistViewController.h"
#import "MLViewController.h"
#import "FavoriteMLViewController.h"
#import "OwnMLViewController.h"
#import "UserDataController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "PlayHistoryViewController.h"
#import "MLParticularViewController.h"
#import "MVDetailViewController.h"
#import "MLItem.h"
#import "TopView.h"
#import "AppDelegate.h"
#import "SettingsDataController.h"
#import "YYTPopoverBackgroundView.h"
#import "NoticeDataController.h"

@interface BaseViewController ()<SideMenuViewDelegate,TopViewDelegate,PlayHistoryActionDelegate>

@property (retain,nonatomic) SideMenuView* sideMenuView;
@property (strong, nonatomic) UIPopoverController *historyPopoverController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray *recommendArray;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

//
//- (void)loadView
//{
//    [super loadView];
//    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//    self.view = view;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat y = 0;
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    //适配ios7
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //为StatusBar加一个半透明的底色
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9f];
        [self.view addSubview:view];
        y = 20;
        self.statusBarBackView = view;
    }
    
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y+62, self.view.width, self.view.height)];
    view.backgroundColor = [UIColor clearColor];
    self.textBackgroungView = view;
    self.textBackgroungView.hidden = YES;
    [self.view addSubview:self.textBackgroungView];
    searchHistoryDataController = [[SearchHistoryDataController alloc] init];
    _searchSuggestList = [[NSArray alloc] init];
    searchDataController = [[SearchDataController alloc] init];
    self.topView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:self options:nil] lastObject];
    CGRect naviframe = self.topView.frame;
    naviframe.origin.y = y;
    self.topView.frame = naviframe;
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
    
    self.sideMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SideMenuView" owner:self options:nil] lastObject];
    self.sideMenuView.delegate = self;
    [self.view addSubview:self.sideMenuView];
    self.sideMenuView.hidden = YES;
    
    CGRect rect = _topView.frame;
    CGRect frame = self.sideMenuView.frame;
    frame.origin.y = rect.origin.y + rect.size.height;
    self.sideMenuView.frame = frame;
    
    self.preSearchViewController = [[PreSearchViewController alloc] initWithNibName:@"PreSearchViewController" bundle:nil];
    self.preSearchViewController.delegate = self;
    [self.view addSubview:self.preSearchViewController.backImageView];
    self.preSearchViewController.backImageView.frame = CGRectMake(815, self.topView.frame.origin.y+28, 192, 220+33);
    self.preSearchViewController.backImageView.hidden = YES;
    [self.view addSubview:self.preSearchViewController.searchTableView];
    self.preSearchViewController.searchTableView.frame = CGRectMake(817, self.topView.frame.origin.y+58, 188, 218);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUnReadCount) name:@"UnReadCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUnreadImage) name:@"UnReadImage" object:nil];
    
    //添加空白时的页面显示
    self.emptyViewController = [[EmptyViewController alloc] initWithNibName:@"EmptyViewController" bundle:nil];
    self.emptyViewController.delegate = self;
    [self.emptyViewController view];//调用viewDidLoad进行初始化
    self.emptyViewController.holderImage = IMAGE(@"");//子类确定
    self.emptyViewController.holderText = NONETWORK;//子类确定
    [self.view addSubview:self.emptyViewController.view];
    self.emptyViewController.view.hidden = YES;//先隐藏
    
    //设置emptyViewController的视图位置
    rect = self.emptyViewController.view.frame;
    CGFloat shadowHeight = 2.0f;
    rect.origin.y = self.topView.frame.origin.y + self.topView.frame.size.height - shadowHeight;
    self.emptyViewController.view.frame = rect;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSearchView) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanTextFild) name:@"TextFieldNULL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSideButtonSelected) name:@"setSideButtonSelected" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TextFieldNULL" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setSideButtonSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnReadImage" object:nil];
}


- (void)showUnreadImage{
    self.topView.unreadNoticeImage.hidden = ![NoticeDataController sharedInstance].isNew;
}

- (void)changeSideButtonSelected{
    self.topView.sideButton.selected = NO;
}

- (void)cleanTextFild{
    if(self.topView.searchTextField.text.length == 0){
        self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
        for (NSString *str in self.preSearchViewController.dataArray) {
            NSLog(@"%@",str);
        }
        [self.preSearchViewController.searchTableView reloadData];
    }
}
- (void)dismissSearchView{
    self.preSearchViewController.backImageView.hidden = YES;
    self.preSearchViewController.searchTableView.hidden = YES;
    self.topView.closeBtn.hidden = YES;
    [self.topView setSearchBackgroundImage:@"Search_Back_White"];
}

- (void)dismissTableView:(BOOL)isShow{
    self.preSearchViewController.backImageView.hidden = isShow;
    self.preSearchViewController.searchTableView.hidden = isShow;
    if (isShow) {
        self.topView.closeBtn.hidden = YES;
        [self.topView setSearchBackgroundImage:@"Search_Back_White"];
    }
}

- (void)onBurger{
    NSArray *images = @[
                        [UIImage imageNamed:@"DOWNLOAD"],
                        [UIImage imageNamed:@"MY_COLLECTMV"],
                        [UIImage imageNamed:@"MY_COLLECT_LIST"],
                        [UIImage imageNamed:@"MY_PLAYLIST"],
                        [UIImage imageNamed:@"MY_ORDERAERIST"],
                        
                        ];
    /*
    NSArray *colors = @[[UIColor clearColor],
                        [UIColor clearColor],
                        [UIColor clearColor],
                        [UIColor clearColor],
                        [UIColor clearColor],
                        ];*/
    
//    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    self.topView.sideButton.selected = YES;
    callout.showFromRight = NO;
    [callout show];
}

- (void)makeAllModuleEntranceDisappear:(BOOL)disappear
{
    [self.topView isShowSideButton:!disappear];
    RootViewController *rootViewController = (RootViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (disappear) {
        [rootViewController hideBottomViewAnimated:YES];
    } else {
        [rootViewController showBottomViewAnimated:YES];
    }
}

- (void)doLogin
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = loginViewController.view.frame.size;
    [self presentViewController:loginViewController animated:NO completion:^{
        UIView *view = loginViewController.view;
        UIView *superView = view.superview;
        superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        NSArray *subViews = superView.subviews;
        for (UIView *subView in subViews) {
            if (subView != view) {
                subView.hidden = YES;
            }
        }
        CGPoint curCenter = superView.center;
        superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
        superView.center = curCenter;
    }];
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    self.topView.sideButton.selected = NO;
    RootViewController *rootViewController = (RootViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    rootViewController.homeBtn.selected = NO;
    rootViewController.mvBtn.selected = NO;
    rootViewController.vButton.selected = NO;
    rootViewController.mlBtn.selected = NO;
    rootViewController.settingButton.selected = NO;
    NSString *eventName;
    NSString *event;
    if (index == 0) {
        RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        eventName = @"我下载的MV";
        [rootViewcontroller showMyDownload];
    }else if (index == 1){
        RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        eventName = @"我收藏的MV";
        event = @"我的音悦-MV收藏";
        [rootViewcontroller showMyMVCollections];
    }else if (index == 2){
        RootViewController *rootViewController = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        eventName = @"我收藏的悦单";
        event = @"我的音悦-悦单收藏";
        if ([[UserDataController sharedInstance] isLogin]) {
            [rootViewController showFavoriteML];
        } else {
            [self doLogin];
        }
    }else if (index == 3){
        RootViewController *rootViewController = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        eventName = @"我创建的悦单";
        event = @"我的音悦-创建的悦单";
        if ([[UserDataController sharedInstance] isLogin]) {
            [rootViewController showOwnML];
        } else {
            [self doLogin];
        }
    }else if (index == 4){
        RootViewController *rootViewController = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        eventName = @"我订阅的艺人";
        event = @"我的音悦-艺人订阅";
        if ([[UserDataController sharedInstance] isLogin]) {
            [rootViewController showMyOrderArtist];
        } else {
            [self doLogin];
        }
    }
    [MobClick event:@"MyMusic_Select" label:eventName];
    [MobClick event:@"Login_Event" label:eventName];
    [sidebar dismiss];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

- (void)showUnReadCount{
    if ([ShareApp.unReadCount integerValue]>99) {
        ShareApp.unReadCount = @"99";
    }
    if ([ShareApp.unReadCount integerValue]>0) {
        self.topView.unReadCountLabel.text = [NSString stringWithFormat:@"%@",ShareApp.unReadCount];
        self.topView.unReadImageView.hidden = NO;
        self.topView.unReadCountLabel.hidden = NO;
    }else{
        self.topView.unReadCountLabel.text = [NSString stringWithFormat:@"%@",ShareApp.unReadCount];
        self.topView.unReadImageView.hidden = YES;
        self.topView.unReadCountLabel.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.topView.searchTextField.text = @"";
    [super viewWillAppear:animated];
    self.topView.unreadNoticeImage.hidden = ![NoticeDataController sharedInstance].isNew;
    if ([ShareApp.unReadCount integerValue]>99) {
        ShareApp.unReadCount = @"99";
    }
    if ([ShareApp.unReadCount integerValue]>0) {
        self.topView.unReadCountLabel.text = [NSString stringWithFormat:@"%@",ShareApp.unReadCount];
        self.topView.unReadImageView.hidden = NO;
        self.topView.unReadCountLabel.hidden = NO;
    }else{
        self.topView.unReadCountLabel.text = [NSString stringWithFormat:@"%@",ShareApp.unReadCount];
        self.topView.unReadImageView.hidden = YES;
        self.topView.unReadCountLabel.hidden = YES;
    }
}

- (void)resetTopView:(BOOL)isRoot
{
    if (isRoot) {
        self.topView.sideButton.hidden = NO;
        
    } else {
        self.topView.sideButton.hidden = YES;
        [self.topView.unReadCountLabel removeFromSuperview];
        [self.topView.unReadImageView removeFromSuperview];
        UIImage *normalImg = [UIImage imageNamed:@"navi_back"];
        UIImage *highlightedImg = [UIImage imageNamed:@"navi_back_h"];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, (kTopBarHeight-normalImg.size.height)/2, normalImg.size.width  , normalImg.size.height);
        [backBtn setImage:normalImg forState:UIControlStateNormal];
        [backBtn setImage:highlightedImg forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:backBtn];
    }
}

- (void)btnBackWillClicked
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.sideMenuView.hidden = YES;
}

- (void)btnBackClicked
{
    [self btnBackWillClicked];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)btnMyYYTClicked
{
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.topView setSearchBackgroundImage:@"Search_Back_White"];
    self.sideMenuView.hidden = YES;
    
    [self.view bringSubviewToFront:self.textBackgroungView];
    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
    if (![touch.view isKindOfClass:[UITextField class]] || touch.view == self.textBackgroungView) {
        [self dismissTableView:YES];
        self.topView.closeBtn.hidden = YES;
        [self.topView.searchTextField resignFirstResponder];
        self.textBackgroungView.hidden = YES;
    }
//    self.preSearchViewController.searchTableView.hidden = YES;
//    [self.navView.searchTextField resignFirstResponder];
}

- (void)sideMenuView:(SideMenuView*)menuView clickedDownloadMV:(id)sender
{
    NSLog(@"点击我的下载MV");
    RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [rootViewcontroller showMyDownload];
}

- (void)sideMenuView:(SideMenuView*)menuView clickedCollectMV:(id)sender
{
    NSLog(@"点击我的收藏MV");
    RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [rootViewcontroller showMyMVCollections];
}

- (void)sideMenuView:(SideMenuView*)menuView clickedCollectML:(id)sender
{
    NSLog(@"点击我的收藏悦单");
    RootViewController *rootViewController = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    if ([[UserDataController sharedInstance] isLogin]) {
        [rootViewController showFavoriteML];
    } else {
        [self doLogin];
    }
}

- (void)sideMenuView:(SideMenuView*)menuView clickedMyML:(id)sender
{
    NSLog(@"点击我创建的悦单");
    RootViewController *rootViewController = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    if ([[UserDataController sharedInstance] isLogin]) {
        [rootViewController showOwnML];
    } else {
        [self doLogin];
    }
}

- (void)sideMenuView:(SideMenuView*)menuView clickedOrderArtist:(id)sender
{
    NSLog(@"点击我订阅的艺人");
    void (^completionBlock)(YYTLoginInfo *, NSError *) = ^(YYTLoginInfo *info, NSError *error) {
        if (error) {
            [UIAlertView alertViewWithTitle:@"无法查看订阅的艺人" message:@"登录失败"];
            return;
        }
        RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [rootViewcontroller showMyOrderArtist];
    };
    if ([UserDataController sharedInstance].isLogin) {
        completionBlock(nil, nil);
    }else{
        [self doLogin];
    }
}

- (void)topView:(TopView *)topView clickedSideMenu:(id)sender
{
    [self dismissTableView:YES];
    self.topView.closeBtn.hidden = YES;
    [self.topView.searchTextField resignFirstResponder];
    self.textBackgroungView.hidden = YES;
    [self onBurger];
    [MobClick endEvent:@"TopBar_Select" label:@"我的音悦"];
//    self.sideMenuView.hidden = !self.sideMenuView.hidden;
//    [self.view bringSubviewToFront:self.sideMenuView];
}

//历史纪录
- (UIPopoverController *)historyPopoverController
{
    if (_historyPopoverController == nil) {
        PlayHistoryViewController *viewController = [[PlayHistoryViewController alloc] init];
        viewController.actionDelegate = self;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
        popover.popoverBackgroundViewClass = [YYTPopoverBackgroundView class];
        _historyPopoverController = popover;
    }
    
    return _historyPopoverController;
}

- (void)topView:(TopView *)topView clickedNoticeBtn:(id)sender{
    self.topView.unreadNoticeImage.hidden = YES;
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
    }else{
        [NoticeDataController sharedInstance].isNew = NO;
        RootViewController *rootViewcontroller = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [rootViewcontroller showNotice];
    }
}


- (void)topView:(TopView *)topView clickedRecent:(id)sender
{
    [self dismissTableView:YES];
    self.topView.closeBtn.hidden = YES;
    [self.topView.searchTextField resignFirstResponder];
    self.textBackgroungView.hidden = YES;
    [self.historyPopoverController presentPopoverFromRect:[sender frame] inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)playHistoryViewController:(PlayHistoryViewController *)controller didSelectedHistoryEntity:(PlayHistoryEntity *)playHistoryEntity
{
    UIViewController *viewController = nil;
    
    PlayHistoryType playHistoryType = [playHistoryEntity.type integerValue];
    if (playHistoryType == PlayHistoryMVType) {
        //进入MV详情页
        viewController = [[MVDetailViewController alloc] initWithId:[playHistoryEntity.keyID stringValue]];
    }
    else if(playHistoryType == PlayHistoryMLType) {
        //进入悦单
        MLItem *mlItem = [[MLItem alloc] init];
        mlItem.keyID = playHistoryEntity.keyID;
        viewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [self.historyPopoverController dismissPopoverAnimated:NO];
}

- (void)searchFinished:(id)sender{
    RootViewController *rootViewController = (RootViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    rootViewController.homeBtn.selected = NO;
    rootViewController.mvBtn.selected = NO;
    rootViewController.vButton.selected = NO;
    rootViewController.mlBtn.selected = NO;
    rootViewController.settingButton.selected = NO;
    [searchHistoryDataController addToHistory:self.topView.searchTextField.text];
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil keyWord:self.topView.searchTextField.text];
    [self.navigationController pushViewController:searchViewController animated:YES];
    self.topView.searchTextField.text = @"";
    [self dismissTableView:YES];
    self.topView.closeBtn.hidden = YES;
    [self.topView.searchTextField resignFirstResponder];
}

- (void)searchTextChange:(id)sender{
    UITextField *searchInput = (UITextField *)sender;
    UITextRange *selectedRange = [searchInput markedTextRange];
    //UITextPosition *position = [searchInput positionFromPosition:selectedRange.start offset:0];
    if(selectedRange.start == nil  && selectedRange.end == nil)
    {
        self.isHistory = NO;
        if (searchInput.text.length == 0) {
            self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
            for (NSString *str in self.preSearchViewController.dataArray) {
            }
            [self.preSearchViewController.searchTableView reloadData];
            if ([searchHistoryDataController getHistoryArray].count == 0) {
                //    搜索推荐
                [searchDataController searchRecommendSuccess:^(SearchDataController *dataController, NSArray *recommendArray) {
                    self.recommendArray = recommendArray;
                    self.preSearchViewController.dataArray = recommendArray;
                    [self.preSearchViewController.searchTableView reloadData];
                } failure:^(SearchDataController *dataController, NSError *error) {
                    NSLog(@"recommend error :%@",error);
                }];
            }else{
                [MobClick endEvent:@"TopBar_Select" label:@"播放历史"];
            }
            return;
        }
        [searchDataController searchSuggestByKeyWord:searchInput.text success:^(SearchDataController *dataController, NSArray *suggestArray) {
            self.searchSuggestList = suggestArray;
            self.preSearchViewController.dataArray = suggestArray;
            [self dismissTableView:NO];
            [self.preSearchViewController.searchTableView reloadData];
        } failure:^(SearchDataController *dataController, NSError *error) {
            
        }];
    }
    if(searchInput.text.length == 0){
        self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
        for (NSString *str in self.preSearchViewController.dataArray) {
            NSLog(@"%@",str);
        }
        [self.preSearchViewController.searchTableView reloadData];
        if ([searchHistoryDataController getHistoryArray].count == 0) {
            //    搜索推荐
            [searchDataController searchRecommendSuccess:^(SearchDataController *dataController, NSArray *recommendArray) {
                self.recommendArray = recommendArray;
                self.preSearchViewController.dataArray = recommendArray;
                [self.preSearchViewController.searchTableView reloadData];
            } failure:^(SearchDataController *dataController, NSError *error) {
                NSLog(@"recommend error :%@",error);
            }];
        }else{
            [MobClick endEvent:@"TopBar_Select" label:@"播放历史"];
        }
    }
}

- (void)searchText:(NSString *)searchText{
    RootViewController *rootViewController = (RootViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    rootViewController.homeBtn.selected = NO;
    rootViewController.mvBtn.selected = NO;
    rootViewController.vButton.selected = NO;
    rootViewController.mlBtn.selected = NO;
    rootViewController.settingButton.selected = NO;
    self.topView.searchBackground.image = IMAGE(@"Search_Back_White");
    [searchHistoryDataController addToHistory:searchText];
    self.topView.searchTextField.text = searchText;
    [self.topView.searchTextField resignFirstResponder];
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil keyWord:searchText];
    [self.navigationController pushViewController:searchViewController animated:YES];
    [self dismissTableView:YES];
    self.topView.closeBtn.hidden = YES;
    
}

- (void)textBeginEdit{
    [MobClick endEvent:@"TopBar_Select" label:@"搜索栏"];
    self.textBackgroungView.hidden = NO;
    if (self.topView.searchTextField.text.length > 0) {
        self.topView.closeBtn.hidden = NO;
    }else{
        self.topView.closeBtn.hidden = YES;
    }
    [self.view bringSubviewToFront:self.preSearchViewController.backImageView];
    [self.view bringSubviewToFront:self.preSearchViewController.searchTableView];
    [self dismissTableView:NO];
    if(self.topView.searchTextField.text.length == 0){
        self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
        [self.preSearchViewController.searchTableView reloadData];
    }
    if ([searchHistoryDataController getHistoryArray].count == 0) {
        //    搜索推荐
        [searchDataController searchRecommendSuccess:^(SearchDataController *dataController, NSArray *recommendArray) {
            self.recommendArray = recommendArray;
            self.preSearchViewController.dataArray = recommendArray;
            [self.preSearchViewController.searchTableView reloadData];
        } failure:^(SearchDataController *dataController, NSError *error) {
            NSLog(@"recommend error :%@",error);
        }];
    }else{
        [MobClick endEvent:@"TopBar_Select" label:@"播放历史"];
    }
}

//- (void)dealloc{
//    [self removeObserver:self forKeyPath:@"UnReadCount"];
//}

- (void)checkEmpty:(id)data
{
    if(data == nil || [data isKindOfClass:[NSArray class]])
    {
        if([data count] == 0)
        {
            self.emptyViewController.hidden = NO;
            [self.emptyViewController bringToFront];
            [self.emptyViewController doneLoading];
        }
        else
        {
            self.emptyViewController.hidden = YES;
            [self.emptyViewController doneLoading];
        }
    }
    
}

@end
