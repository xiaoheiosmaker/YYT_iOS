//
//  HomeViewController.m
//  YYTHD
//
//  Created by btxkenshin on 10/10/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeDataController.h"
#import "MVItem.h"
#import "MLItem.h"
#import "FontPageItem.h"
#import "MVDetailViewController.h"
#import "AddMVToMLAssistantController.h"
#import "UserDataController.h"
#import "MLParticularViewController.h"
#import "YYTShowWebViewController.h"
#import "ArtistDetailViewController.h"
#import "PageDetaiView.h"
#import "HomeMVItemView.h"
#import "YYTScrollView.h"
#import "NoticeDataController.h"

@interface HomeViewController () <
    UIWebViewDelegate,
    HomeMVItemViewDelegate,
    UIScrollViewDelegate,
    YYTScrollViewDelegate>
{
    __weak IBOutlet UIView *_areaOptionView;
    __weak IBOutlet UIButton *_selectedAreaBtn;
    __weak IBOutlet UIView *_premiereView;
    
}
@property (nonatomic, strong) HomeDataController *homeDataController;
@property (strong, nonatomic) NSArray *pageDataArray;
@property (strong, nonatomic) IBOutlet YYTScrollView *cycleScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *premiereScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *areaIndicator;

- (void)reloadHome;

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _homeDataController = [[HomeDataController alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetTopView:YES];
    // Do any additional setup after loading the view from its nib.
    
    self.emptyViewController.holderImage = IMAGE(@"网络断开");
    self.emptyViewController.holderText = NONETWORK;
    
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    
    self.topView.titleImageView.image = IMAGE(@"logo");
    self.topView.titleImageView.frame = CGRectMake(self.topView.titleImageView.frame.origin.x, self.topView.titleImageView.frame.origin.y+10, 160/2, 75/2);
    self.topView.titleImageView.center = CGPointMake(self.topView.frame.size.width/2, self.topView.frame.size.height/2);

    _cycleScrollView.delegate = self;
//    _cycleScrollView.datasource = self;
    _cycleScrollView.backgroundColor = [UIColor yytBackgroundColor];
    
    _premiereScrollView.backgroundColor = [UIColor yytBackgroundColor];
    _premiereView.hidden = YES;
    
    
    self.premiereScrollView.delegate = self;
    [self reloadHome];
}

- (void)reloadHome
{
    [self showLoading];
    
    [_homeDataController loadFontPage:^(NSArray *list, NSError *err) {
        if (!err) {
            self.pageDataArray = list;
            [_cycleScrollView setContentViewWithItems:self.pageDataArray];
        }
    }];
    
    [_homeDataController loadMVPremiere:^(NSArray *list, NSError *err) {
        if (!err) {
            [self hideLoading];
            [self reloadPremiere:list];
        }
        //视为首页是否有数据
        [self checkEmpty:list];
        [self.view bringSubviewToFront:self.topView];
    }];
}

- (void)showWebViewWithURL:(NSURL *)url title:(NSString*)title{
    YYTShowWebViewController *webView = [[YYTShowWebViewController alloc] init];
    [webView setHidesBottomBarWhenPushed:YES];
    [webView loadRequestWithURL:[NSURL URLWithString:@"http://live.yinyuetai.com/breath/666666#a2Mspl"]];
    webView.titleLabel.text = title;
    //    @"http://live.yinyuetai.com/hall/666666"
    [self.navigationController pushViewController:webView animated:YES];
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

#pragma mark - CycleScrollView delegate
- (void)didClickPage:(YYTScrollView *)csView atIndex:(NSInteger)index
{
    FontPageItem *pageItem = [self.pageDataArray objectAtIndex:index];
    if ([pageItem.type isEqualToString:@"VIDEO"]) {
        MVDetailViewController *mvdetailViewController = [[MVDetailViewController alloc] initWithId:[pageItem.keyID stringValue]];
        [self.navigationController pushViewController:mvdetailViewController animated:YES];
        
    }else if ([pageItem.type isEqualToString:@"PLAYLIST"]) {
        MLItem *mlItem = [[MLItem alloc] init];
        mlItem.keyID = pageItem.keyID;
        MLParticularViewController *mlParticularViewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
        [self.navigationController pushViewController:mlParticularViewController animated:YES];
        
    }else if ([pageItem.type isEqualToString:@"PROGRAM"]){
        if ([pageItem.subType isEqualToString:@"VIDEO"]) {
            MVDetailViewController *mvdetailViewController = [[MVDetailViewController alloc] initWithId:[pageItem.keyID stringValue]];
            [self.navigationController pushViewController:mvdetailViewController animated:YES];
            
        }else if ([pageItem.subType isEqualToString:@"PLAYLIST"]) {
            MLItem *mlItem = [[MLItem alloc] init];
            mlItem.keyID = pageItem.keyID;
            MLParticularViewController *mlParticularViewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
            [self.navigationController pushViewController:mlParticularViewController animated:YES];
        }
    } else if ([pageItem.type isEqualToString:@"WEEK_MAIN_STAR"]){
        if ([pageItem.subType isEqualToString:@"VIDEO"]) {
            MVDetailViewController *mvdetailViewController = [[MVDetailViewController alloc] initWithId:[pageItem.keyID stringValue]];
            [self.navigationController pushViewController:mvdetailViewController animated:YES];
            
        }else if ([pageItem.subType isEqualToString:@"PLAYLIST"]) {
            MLItem *mlItem = [[MLItem alloc] init];
            mlItem.keyID = pageItem.keyID;
            MLParticularViewController *mlParticularViewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
            [self.navigationController pushViewController:mlParticularViewController animated:YES];
        }
    }else if ([pageItem.type isEqualToString:@"LIVE"]){
        //            if (![[UserDataController sharedInstance] isLogin]) {
        //                [self doLogin];
        //            }else{
        //                NSString *accessToken = [NSString stringWithFormat:@"?Authorization=Bearer %@",[UserDataController sharedInstance].loginInfo.access_token];
        //                NSString *url = [pageItem.url stringByAppendingString:accessToken];
        [self showWebViewWithURL:[NSURL URLWithString:pageItem.url] title:pageItem.title];
        //            }
    }else {
        [self showWebViewWithURL:[NSURL URLWithString:pageItem.url] title:pageItem.title];
    }
}
 
#pragma mark - Premiere
- (IBAction)areaBtnClicked:(UIButton *)sender
{
    if (_selectedAreaBtn == sender) {
        return;
    }
    
    [MobClick event:@"Mv_Premiere" label:@"语种切换"];
    
    [_selectedAreaBtn setSelected:NO];
    [sender setSelected:YES];
    _selectedAreaBtn = sender;
    
    CGPoint center = self.areaIndicator.center;
    center.x = sender.center.x;
    [UIView beginAnimations:nil context:nil];
    self.areaIndicator.center = center;
    [UIView commitAnimations];
    
    [self showLoading];
    [_homeDataController loadMVPremiere:^(NSArray *list, NSError *err) {
        if (!err) {
            [self hideLoading];
            [self reloadPremiere:list];
        }
    } areaType:sender.tag];
}

- (void)reloadPremiere:(NSArray *)list
{
    if (_premiereView.hidden == YES) {
        _premiereView.hidden = NO;
    }
    
    UIScrollView *scrollView = self.premiereScrollView;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat space = 2;
    CGFloat itemWidth = [HomeMVItemView defaultSize].width;
    __block CGFloat x = 0;
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat addition = space;
        if ((idx+1)%3 == 0) {
            addition = 0;
        }
        
        HomeMVItemView *itemView = [HomeMVItemView defaultSizeView];
        CGRect frame = itemView.frame;
        frame.origin.x = x;
        itemView.frame = frame;
        
        [itemView setContentWithMVItem:obj];
        itemView.delegate = self;
        [scrollView addSubview:itemView];
        
        x += (itemWidth+addition);
    }];
    
    CGFloat contentWidth = x;
    CGFloat contentHeight = CGRectGetHeight(scrollView.frame);
    scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    scrollView.contentOffset = CGPointZero;
}

- (void)homeMVItemViewDidClickedAddBtn:(HomeMVItemView *)mvItemView
{
    if (![[UserDataController sharedInstance] isLogin]){
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
        return;
    }
    
    MVItem *item = mvItemView.mvItem;
    [AddMVToMLAssistantController sharedInstance].mvToAdd = item;
}

- (void)homeMVItemVIew:(HomeMVItemView *)mvItemView didClickedArtist:(Artist *)artist
{
    NSString *artistId = artist.keyID;
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artistId];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

- (void)homeMVItemViewDidClickedImage:(HomeMVItemView *)mvItemView
{
    MVItem *item = mvItemView.mvItem;
    MVDetailViewController *detailViewController = [[MVDetailViewController alloc] initWithId:[item.keyID stringValue]];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

static NSInteger currentPage = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    currentPage = [self getPageFromScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger nearestPage = [self getPageFromScrollView:scrollView];
    if (nearestPage == currentPage) {
        return;
    }
    
    currentPage = nearestPage;
    if (nearestPage == 1) {
        [MobClick event:@"Mv_Premiere" label:@"滑动1次"];
    }
    else if (nearestPage == 2) {
        [MobClick event:@"Mv_Premiere" label:@"滑动2次"];
    }
}

- (NSInteger)getPageFromScrollView:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    float position = point.x / width;
    NSInteger nearestPage = position;
    if (position > nearestPage + 0.5) {
        ++nearestPage;
    }
    
    return nearestPage;
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self reloadHome];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

@end
