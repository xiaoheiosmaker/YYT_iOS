//
//  RootViewController.m
//  YYTHD
//
//  Created by btxkenshin on 10/10/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "RootViewController.h"
#import "UserDataController.h"
#import "HomeViewController.h"
#import "PickMLViewController.h"
#import "MVChannelViewController.h"
#import "MLViewController.h"
#import "FavoriteMLViewController.h"
#import "OwnMLViewController.h"
#import "VViewController.h"
#import "SettingsViewController.h"
#import "MVCollectionViewController.h"
#import "ArtistOrderViewController.h"
#import "MyDownloadViewController.h"
#import "YYTShowWebViewController.h"
#import "NewsListViewController.h"
#import "NoticeViewController.h"

@interface RootViewController ()<UIAlertViewDelegate>
{
    VViewController *vBangcontroller;
    MVChannelViewController *mvController;
    HomeViewController *homeController;
    PickMLViewController *mlController;
    YYTShowWebViewController *webView;
    NoticeViewController *noticeController;
    NewsListViewController *newsController;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UINavigationController *navControllerHome;
@property (nonatomic, strong) UINavigationController *navControllerMV;
@property (nonatomic, strong) UINavigationController *navControllerVBang;
@property (nonatomic, strong) UINavigationController *navControllerML;
@property (nonatomic, strong) UINavigationController *navControllerSetting;
@property (nonatomic, strong) UINavigationController *navControllerGame;
@property (nonatomic, strong) UINavigationController *navControllerNews;
@property (nonatomic, strong) UINavigationController *navControllerNotice;

@property (nonatomic, strong) UINavigationController *navControllerDown;
@property (nonatomic, strong) UINavigationController *navControllerFavMV;
@property (nonatomic, strong) UINavigationController *navControllerFavML;
@property (nonatomic, strong) UINavigationController *navControllerOwnML;
@property (nonatomic, strong) UINavigationController *navControllerOrderArtist;

- (IBAction)homeBtnClicked:(id)sender;
- (IBAction)mvBtnClicked:(id)sender;
- (IBAction)VBtnClicked:(id)sender;
- (IBAction)MLBtnClicked:(id)sender;
- (IBAction)clickedSettings:(id)sender;
- (IBAction)gameBtnClicked:(id)sender;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.singleButtonGroup = [[SingleButtonGroup alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.clipsToBounds = YES;
    
    //[self.view addSubview:self.navControllerHome.view];
    self.navControllerHome.view.frame = self.contentView.bounds;
    [self fixViewSize:self.navControllerHome.view];
    [self.contentView addSubview:self.navControllerHome.view];
    self.selectedViewController = self.navControllerHome;
    
    [self.homeBtn setImage:[UIImage imageNamed:@"首页1"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.mvBtn setImage:[UIImage imageNamed:@"MV1"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.vButton setImage:[UIImage imageNamed:@"V榜1"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.mlBtn setImage:[UIImage imageNamed:@"悦单1"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.settingButton setImage:[UIImage imageNamed:@"设置1"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.gameButton setImage:[UIImage imageNamed:@"game_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
    
    [self.singleButtonGroup addItem:self.homeBtn];
    [self.singleButtonGroup addItem:self.mvBtn];
    [self.singleButtonGroup addItem:self.vButton];
    [self.singleButtonGroup addItem:self.mlBtn];
    [self.singleButtonGroup addItem:self.settingButton];
    [self.singleButtonGroup addItem:self.gameButton];
    [self.singleButtonGroup addItem:self.newsButton];
    
    [self.singleButtonGroup selectItem:self.homeBtn];

    [self checkSetupDate];
}

NSString * const SetupDateKey = @"SetupDateKey";
NSString * const ShowRatingAlertKey = @"ShowRatingAlertKey";

- (void)checkSetupDate
{
    BOOL shown = [[NSUserDefaults standardUserDefaults] boolForKey:ShowRatingAlertKey];
    if (shown) {
        return;
    }
    
    NSTimeInterval setupDateInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:SetupDateKey];
    if (setupDateInterval == 0) {
        //first run the app
        setupDateInterval = [NSDate timeIntervalSinceReferenceDate];
        [[NSUserDefaults standardUserDefaults] setDouble:setupDateInterval forKey:SetupDateKey];
    }
    else {
        NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
        const NSTimeInterval tipInterval = 3*24*60*60;
        if (tipInterval < (nowInterval-setupDateInterval)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"求助！！音悦台HD，需要您的一份鼓励" message:nil delegate:self cancelButtonTitle:@"马上前往评价" otherButtonTitles:@"别再提示我", nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", APP_ID];
        if ([SystemSupport versionPriorTo7])
            str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ShowRatingAlertKey];
}

- (void)showBottomViewAnimated:(BOOL)animated
{
    UIView *view = self.bottomView;
    
    view.hidden = NO;
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(view.frame);
    if (animated) {
        [UIView animateWithDuration:0.35f
                         animations:^{
                             view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else {
        view.frame = frame;
    }
}

- (void)hideBottomViewAnimated:(BOOL)animated
{
    UIView *view = self.bottomView;
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds);
    if (animated) {
        [UIView animateWithDuration:0.35f
                         animations:^{
                             view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             view.hidden = YES;
                         }];
    }
    else {
        view.frame = frame;
        view.hidden = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UINavigationController *)navControllerHome
{
    if (_navControllerHome == nil) {
        homeController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        self.navControllerHome = [[UINavigationController alloc] initWithRootViewController:homeController];
        self.navControllerHome.navigationBarHidden = YES;
        [self addChildViewController:self.navControllerHome];
    } else {
        [_navControllerHome popToRootViewControllerAnimated:NO];
    }
    return _navControllerHome;
}

- (UINavigationController *)navControllerMV
{
    if (_navControllerMV == nil) {
        mvController = [[MVChannelViewController alloc] init];
        self.navControllerMV = [[UINavigationController alloc] initWithRootViewController:mvController];
        self.navControllerMV.navigationBarHidden = YES;
        [self addChildViewController:self.navControllerFavMV];
    } else {
        [_navControllerMV popToRootViewControllerAnimated:NO];
    }
    return _navControllerMV;
}

- (UINavigationController *)navControllerML
{
    if (_navControllerML == nil) {
        mlController = [[PickMLViewController alloc] init];
        _navControllerML = [[UINavigationController alloc] initWithRootViewController:mlController];
        _navControllerML.navigationBarHidden = YES;
        [self addChildViewController:_navControllerML];
    } else {
        [_navControllerML popToRootViewControllerAnimated:NO];
    }
    return _navControllerML;
}

- (UINavigationController *)navControllerVBang
{
    if (_navControllerVBang == nil) {
        vBangcontroller = [[VViewController alloc] init];
        self.navControllerVBang = [[UINavigationController alloc] initWithRootViewController:vBangcontroller];
        self.navControllerVBang.navigationBar.hidden = YES;
        [self addChildViewController:_navControllerVBang];
    } else {
        [_navControllerVBang popToRootViewControllerAnimated:NO];
    }
    return _navControllerVBang;
}

- (UINavigationController *)navControllerSetting
{
    if (_navControllerSetting == nil) {
        SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        self.navControllerSetting = [[UINavigationController alloc] initWithRootViewController:controller];
        [self addChildViewController:self.navControllerSetting];
        self.navControllerSetting.navigationBarHidden = YES;
    } else {
        [_navControllerSetting popToRootViewControllerAnimated:NO];
    }
    return _navControllerSetting;
}

- (UINavigationController *)navControllerGame {
    if (_navControllerGame == nil) {
        webView = [[YYTShowWebViewController alloc] init];
        [webView setHidesBottomBarWhenPushed:YES];
        [webView loadRequestWithURL:[NSURL URLWithString:URL_Game_Formal]];
        [self.navigationController pushViewController:webView animated:YES];
        self.navControllerGame = [[UINavigationController alloc] initWithRootViewController:webView];
        [self addChildViewController:self.navControllerGame];
        self.navControllerGame.navigationBarHidden = YES;
    } else {
        [webView loadRequestWithURL:[NSURL URLWithString:URL_Game_Formal]];                                                                                                                                                                                                                                                                                          
        [_navControllerGame popToRootViewControllerAnimated:NO];
    }
    return _navControllerGame;
}
- (UINavigationController *)navControllerNotice{
    if (_navControllerNotice == nil) {
        noticeController = [[NoticeViewController alloc] init];
        _navControllerNotice = [[UINavigationController alloc] initWithRootViewController:noticeController];
        _navControllerNotice.navigationBarHidden = YES;
        [self addChildViewController:_navControllerNotice];
    } else {
        [noticeController readData];
        [_navControllerNotice popToRootViewControllerAnimated:NO];
    }
    return _navControllerNotice;
}

- (UINavigationController *)navControllerNews {
    if (_navControllerNews == nil) {
        newsController = [[NewsListViewController alloc] initWithNibName:@"NewsListViewController" bundle:nil];
        self.navControllerNews = [[UINavigationController alloc] initWithRootViewController:newsController];
        self.navControllerNews.navigationBar.hidden = YES;
        [self addChildViewController:_navControllerNews];
    } else {
        [_navControllerNews popToRootViewControllerAnimated:NO];
    }
    return _navControllerNews;

}


- (IBAction)homeBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        BOOL isRoot = [[_navControllerHome viewControllers] count] == 1;
        if (isRoot) {
            [homeController reloadHome];
        }
        else {
            //[_navControllerHome popToRootViewControllerAnimated:YES];
        }
        //return;
    }
    [self.selectedViewController.view removeFromSuperview];
    //self.contentView.autoresizesSubviews = YES;
    //self.navControllerHome.view.frame = self.contentView.bounds;
    [self fixViewSize:self.navControllerHome.view];
    //[self.navControllerHome viewWillAppear:YES];
    
    [self.contentView addSubview:self.navControllerHome.view];
    self.selectedViewController = self.navControllerHome;
    
    [self.singleButtonGroup selectItem:sender];
    [MobClick endEvent:@"TopBar_Select" label:@"首页"];
    
}


- (IBAction)mvBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        BOOL isRoot = [[_navControllerMV viewControllers] count] == 1;
        if (isRoot) {
            [mvController refreshData];
        }
        else {
            //[_navControllerMV popToRootViewControllerAnimated:YES];
        }
        //return;
    }
    [self.selectedViewController.view removeFromSuperview];
    //self.contentView.autoresizesSubviews = YES;
    [self fixViewSize:self.navControllerMV.view];
    [self.contentView addSubview:self.navControllerMV.view];
    self.selectedViewController = self.navControllerMV;
    
    [self.singleButtonGroup selectItem:sender];
    [MobClick endEvent:@"TopBar_Select" label:@"MV"];
}

- (IBAction)VBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        BOOL isRoot = [[_navControllerVBang viewControllers] count] == 1;
        if (isRoot) {
            [vBangcontroller refresh];
        }
    }
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:self.navControllerVBang.view];
    [self.contentView addSubview:self.navControllerVBang.view];
    self.selectedViewController = self.navControllerVBang;
    [self.singleButtonGroup selectItem:sender];
    [MobClick endEvent:@"TopBar_Select" label:@"V榜"];
}

- (IBAction)MLBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        BOOL isRoot = [[_navControllerML viewControllers] count] == 1;
        if (isRoot) {
            [mlController refreshData];
        }
        else {
            //[_navControllerML popToRootViewControllerAnimated:YES];
        }
        //return;
    }
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:self.navControllerML.view];
    [self.contentView addSubview:self.navControllerML.view];
    self.selectedViewController = self.navControllerML;
    
    [self.singleButtonGroup selectItem:sender];
    [MobClick endEvent:@"TopBar_Select" label:@"悦单"];
}

- (IBAction)clickedSettings:(id)sender
{
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:self.navControllerSetting.view];
    [self.contentView addSubview:self.navControllerSetting.view];
    self.selectedViewController = self.navControllerSetting;
    
    [self.singleButtonGroup selectItem:sender];
    
    [MobClick endEvent:@"TopBar_Select" label:@"设置"];
}

- (IBAction)gameBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [webView refreshWebPage];
    }
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:self.navControllerGame.view];
    [self.contentView addSubview:self.navControllerGame.view];
    webView.backBtn.hidden = YES;
    webView.refreshBtn.hidden = NO;
    webView.topView.titleImageView.hidden = NO;
    [webView.topView setTitleImage:[UIImage imageNamed:@"game_text"]];
    self.selectedViewController = self.navControllerGame;
    [MobClick endEvent:@"Recommend_app" label:@"应用推荐按钮点击次数"];
    [self.singleButtonGroup selectItem:sender];
}

- (IBAction)newsBtnClicked:(UIButton *)button {
    if (button.selected) {
        BOOL isRoot = [[_navControllerNews viewControllers] count] == 1;
        if (isRoot) {
            [newsController refreshData];
        }
    }
    [self.selectedViewController.view removeFromSuperview];
    
    UINavigationController * navi = self.navControllerNews;
    [self fixViewSize:navi.view];
    [self.contentView addSubview:navi.view];
    self.selectedViewController = navi;
    
    [self.singleButtonGroup selectItem:button];
    [MobClick endEvent:@"TopBar_Select" label:@"资讯"];
}


- (UINavigationController *)navControllerDown
{
    if (_navControllerDown == nil) {
        MyDownloadViewController *controller = [[MyDownloadViewController alloc] initWithNibName:@"MyDownloadViewController" bundle:nil];
        _navControllerDown = [[UINavigationController alloc] initWithRootViewController:controller];
        _navControllerDown.navigationBarHidden = YES;
        [self addChildViewController:_navControllerDown];
    } else {
        [_navControllerML popToRootViewControllerAnimated:NO];
    }
    return _navControllerDown;
}

- (UINavigationController *)navControllerFavML
{
    if (_navControllerFavML == nil) {
        MLViewController *controller = [[FavoriteMLViewController alloc] initWithEditable:YES];
        _navControllerFavML = [[UINavigationController alloc] initWithRootViewController:controller];
        _navControllerFavML.navigationBarHidden = YES;
        [self addChildViewController:_navControllerFavML];
    } else {
        [_navControllerFavML popToRootViewControllerAnimated:NO];
    }
    return _navControllerFavML;
}

- (UINavigationController *)navControllerOwnML
{
    if (_navControllerOwnML == nil) {
        MLViewController *controller = [[OwnMLViewController alloc] initWithEditable:YES];
        _navControllerOwnML = [[UINavigationController alloc] initWithRootViewController:controller];
        _navControllerOwnML.navigationBarHidden = YES;
        [self addChildViewController:_navControllerOwnML];
    } else {
        [_navControllerOwnML popToRootViewControllerAnimated:NO];
    }
    return _navControllerOwnML;
}

- (void)showMyDownload
{
    UIViewController *viewController = self.navControllerDown;
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:viewController.view];
    [self.contentView addSubview:viewController.view];
    self.selectedViewController = viewController;
}

- (void)showNotice{
    UIViewController *viewController = self.navControllerNotice;
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:viewController.view];
    [self.contentView addSubview:viewController.view];
    self.selectedViewController = viewController;
}

- (void)showViewController:(UIViewController *)viewController {
    UINavigationController *navi = (UINavigationController *)self.selectedViewController;
    [navi pushViewController:viewController animated:YES];
}

- (void)showFavoriteML
{
    UIViewController *viewController = self.navControllerFavML;
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:viewController.view];
    [self.contentView addSubview:viewController.view];
    self.selectedViewController = viewController;
}

- (void)showOwnML
{
    UIViewController *viewController = self.navControllerOwnML;
    [self.selectedViewController.view removeFromSuperview];
    [self fixViewSize:viewController.view];
    [self.contentView addSubview:viewController.view];
    self.selectedViewController = viewController;
}

- (UINavigationController *)navControllerFavMV
{
    if (_navControllerFavMV == nil) {
        MVCollectionViewController *controller = [[MVCollectionViewController alloc] init];
        _navControllerFavMV = [[UINavigationController alloc] initWithRootViewController:controller];
        _navControllerFavMV.navigationBarHidden = YES;
        [self addChildViewController:_navControllerFavMV];
    } else {
        [_navControllerFavMV popToRootViewControllerAnimated:NO];
    }
    return _navControllerFavMV;
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

- (void)showMyMVCollections
{
    if ([[UserDataController sharedInstance] isLogin]) {
        UIViewController *viewController = self.navControllerFavMV;
        [self.selectedViewController.view removeFromSuperview];
        [self fixViewSize:viewController.view];
        [self.contentView addSubview:viewController.view];
        self.selectedViewController = viewController;
    }
    else {
        [self doLogin];
    }
}
- (UINavigationController *)navControllerOrderArtist
{
    if (_navControllerOrderArtist == nil) {
       ArtistOrderViewController *controller = [[ArtistOrderViewController alloc] initWithNibName:@"ArtistOrderViewController" bundle:nil];
        _navControllerOrderArtist = [[UINavigationController alloc] initWithRootViewController:controller];
        _navControllerOrderArtist.navigationBarHidden = YES;
        [self addChildViewController:_navControllerOrderArtist];
    } else {
        [_navControllerOrderArtist popToRootViewControllerAnimated:NO];
    }
    return _navControllerOrderArtist;
}

- (void)showMyOrderArtist
{
    if ([[UserDataController sharedInstance] isLogin]) {
        UIViewController *viewController = self.navControllerOrderArtist;
        [self.selectedViewController.view removeFromSuperview];
        [self fixViewSize:viewController.view];
        [self.contentView addSubview:viewController.view];
        self.selectedViewController = viewController;
    }
    else {
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
}


- (void)fixViewSize:(UIView *)controllerView
{
    controllerView.frame = CGRectMake(0, 0, controllerView.frame.size.width, controllerView.frame.size.height);
    controllerView.frame = self.contentView.bounds;
}

@end
