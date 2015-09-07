//
//  MVViewController.m
//  YYTHD
//
//  Created by btxkenshin on 10/10/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVChannelViewController.h"
#import <GMGridView.h>
#import "MVChannelDataController.h"
#import "MVDescriptionView.h"
#import "MVItem.h"
#import "ArtistComSearchView.h"
#import "MVChannelChooseView.h"
#import "MVSearchCondition.h"
#import "MVDetailViewController.h"
#import "UserDataController.h"
#import "AddMVToMLAssistantController.h"
#import "YYTActivityIndicatorView.h"
#import "ArtistDetailViewController.h"
#import "PullToRefreshView.h"

@interface MVChannelViewController () <GMGridViewDataSource,GMGridViewActionDelegate,ArtistComSearchViewDelegate,MVChannelListViewDelegate,MVItemViewDelegate>
{
    MVChannelDataController *_dataController;

    __weak IBOutlet UIButton *_channelBtn;
    __weak IBOutlet UIButton *_searchBtn;
    BOOL _isAnimating;
    
    __weak IBOutlet UIButton *_newSortBtn;
    __weak IBOutlet UIButton *_hotSortBtn;
    
    
    UIView *_movingShadow;
    UIView *_searchView;
    MVChannelChooseView *_channelListView;
    CGFloat _topMargin;
    
    UIView *_loadingView;
}

@property (nonatomic, strong) NSArray *mvList;
@property (nonatomic, strong) IBOutlet GMGridView *gridView;
@property (nonatomic, strong) MVChannelDataController *dataController;
@property (nonatomic, assign) NSInteger currentPage;

- (void)doFresh;
@end

@implementation MVChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [[MVChannelDataController alloc] init];
        _isAnimating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self resetTopView:YES];
    
    self.emptyViewController.holderImage = IMAGE(@"网络断开");
    self.emptyViewController.holderText = NONETWORK;
    
    //为全屏大小的ScrollView添加contentInset，为上层控件留白。
    CGFloat topEdge = kTopBarHeight+75;
    if ([SystemSupport versionPriorTo7]) {
        topEdge -= 20;
    }
    [self.topView setTitleImage:[UIImage imageNamed:@"MVChannel_title"]]; 
    
    _topMargin = topEdge;
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_shadow"]];
    [self.view addSubview:shadow];
    _movingShadow = shadow;
    [self resetGridEdgeInsets];
    
    _gridView.centerGrid = NO;
    _gridView.sortingDelegate = nil; //禁止长按拖动
    _gridView.transformDelegate = nil; //禁止缩放手势
    _gridView.actionDelegate = nil;
    _gridView.itemSpacing = 4;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _newSortBtn.selected = YES; //默认按照时间排序
    
    //添加下拉刷新，上拉更多
    __weak MVChannelViewController *weekSelf = self;
    [_gridView addPullToRefreshWithActionHandler:^ {
        [weekSelf loadPageAtIndex:0 refreshData:YES];
    }];
    
    [_gridView addInfiniteScrollingWithActionHandler:^{
        [weekSelf loadPageAtIndex:weekSelf.currentPage+1];
    }];
    
    //正在刷新提示
    UIScrollView *scrollView = self.gridView;
//    [scrollView.pullToRefreshView setTitle:@"正在刷新" forState:SVPullToRefreshStateLoading];
//    [scrollView.pullToRefreshView setTitle:@"下拉可以刷新" forState:SVPullToRefreshStateStopped];
//    [scrollView.pullToRefreshView setTitle:@"松开可以刷新" forState:SVPullToRefreshStateTriggered];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    

    [scrollView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
    //加载搜索条件
    //搜索条件目前写在本地，不会发生请求失败
    [self loadSearchCondition];
    
    [self doFresh];
}

- (void)doFresh
{
    //加载频道列表，成功后加载数据
    [self loadChannelList];
}

- (void)loadSearchViewWithConditions:(NSArray *)cdiArray
{
    const CGFloat rowHeight = 40;
    CGFloat height = [cdiArray count]*rowHeight+10;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, _topMargin, CGRectGetWidth(self.view.frame), height)];
    CGFloat x = 0;
    CGFloat y = 7;
    NSInteger i = 0;
    for (MVSearchCondition *condition in cdiArray) {
        ArtistComSearchView *view = [[ArtistComSearchView alloc] initWithFrame:CGRectMake(x, y+(i++)*rowHeight, CGRectGetWidth(searchView.frame), rowHeight) condition:condition];
        view.actionDelegate = self;
        [searchView addSubview:view];
    }
    searchView.backgroundColor = [UIColor yytTransparentBlackColor];
    searchView.clipsToBounds = YES;
    [self.view addSubview:searchView];
    _searchView = searchView;
    _searchView.hidden = YES;
}

- (void)loadChannelListViewWithlist:(NSArray *)channelList
{
    CGFloat height = 90;
    MVChannelChooseView *listView = [[MVChannelChooseView alloc] initWithFrame:CGRectMake(0, _topMargin, CGRectGetWidth(self.view.frame), height) channelList:channelList];
    listView.delegate = self;
    listView.clipsToBounds = YES;
    [self.view addSubview:listView];
    listView.hidden = YES;
    _channelListView = listView;
}

- (void)animeToolView:(UIView *)toolView hidden:(BOOL)hidden completion:(void(^)(BOOL))completion
{
    CGRect frame = toolView.frame;
    CGRect startFrame = frame;
    CGRect targetFrame = frame;
    if (!hidden) {
        startFrame.size.height = 0;
    } else {
        targetFrame.size.height = 0;
    }
    
    toolView.frame = startFrame;
    toolView.hidden = NO;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         toolView.frame = targetFrame;
                     }
                     completion:^(BOOL finished) {
                         toolView.frame = frame;
                         toolView.hidden = hidden;
                         completion(finished);
                     }];
}

- (NSArray *)animatedFramesWithView:(UIView *)toolView hidden:(BOOL)hidden
{
    CGRect frame = toolView.frame;
    CGRect startFrame = frame;
    CGRect targetFrame = frame;
    if (!hidden) {
        startFrame.size.height = 0;
    } else {
        targetFrame.size.height = 0;
    }
    
    return @[[NSValue valueWithCGRect:frame],[NSValue valueWithCGRect:startFrame],[NSValue valueWithCGRect:targetFrame]];
}

- (void)resetGridEdgeInsets
{
    CGFloat topEdge = _topMargin;
    if (_channelListView.hidden == NO) {
        topEdge += CGRectGetHeight(_channelListView.frame);
    }
    
    if (_searchView.hidden == NO) {
        topEdge += CGRectGetHeight(_searchView.frame);
    }
    
    CGRect shadowFrame = _movingShadow.frame;
    shadowFrame.origin.y = topEdge;
    _movingShadow.frame = shadowFrame;
    
    UIEdgeInsets edges = UIEdgeInsetsMake(topEdge, 0, kButtomBarHeight+10, 0);
    CGRect frame = UIEdgeInsetsInsetRect(self.view.bounds, edges);
    self.gridView.frame = frame;
}

- (void)resetGridEdgeInsetsAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            [self resetGridEdgeInsets];
        }];
    } else {
        [self resetGridEdgeInsets];
    }
}

#pragma mark - BtnActions
- (IBAction)channelBtnClicked:(id)sender
{
    if (_channelListView == nil || _channelListView.editing || _isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    void(^completion)(BOOL) = ^(BOOL finished){
        //normal状态不显示channelListView
        BOOL shown = ![_channelBtn isSelected];
        [_channelBtn setSelected:shown];
        
        if (shown) {
            [MobClick event:@"Mv_Channel" label:@"展开频道"];
        }
        
        [self animeToolView:_channelListView
                     hidden:!shown
                 completion:^(BOOL finished){
                     _isAnimating = NO;
        }];
        
        if (sender == _channelBtn) {
            [self resetGridEdgeInsetsAnimated:YES];
        }
    };
    
    if (_searchView.hidden == NO) {
        [_searchBtn setSelected:NO];
        [self animeToolView:_searchView hidden:YES completion:completion];
        [self resetGridEdgeInsetsAnimated:YES];
    }
    else {
        completion(YES);
    }
}

- (IBAction)searchBtnClicked:(id)sender
{
    if (_channelListView.editing || _isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    void(^completion)(BOOL) = ^(BOOL finished){
        //normal状态不显示channelListView
        BOOL shown = ![_searchBtn isSelected];
        [_searchBtn setSelected:shown];
        
        if (shown) {
            [MobClick event:@"Sort_switching" label:@"组合查询"];
        }
        
        [self animeToolView:_searchView
                     hidden:!shown
                 completion:^(BOOL finished){
                     _isAnimating = NO;
                 }];
        
        if (sender == _searchBtn) {
            [self resetGridEdgeInsetsAnimated:YES];
        }
    };
    
    if (_channelListView.hidden == NO) {
        [_channelBtn setSelected:NO];
        [self animeToolView:_channelListView hidden:YES completion:completion];
        [self resetGridEdgeInsetsAnimated:YES];
    }
    else {
        completion(YES);
    }}


- (IBAction)hotSortBtnClicked:(id)sender
{
    if ([_hotSortBtn isSelected]) {
        return;
    }
    
    _hotSortBtn.selected = YES;
    _newSortBtn.selected = NO;
    [MobClick event:@"Sort_switching" label:@"最热播放"];
    [self showLoading];
    [self loadPageAtIndex:0 refreshData:YES];
}


- (IBAction)newSortBtnClicked:(id)sender
{
    if ([_newSortBtn isSelected]) {
        return;
    }
    
    _hotSortBtn.selected = NO;
    _newSortBtn.selected = YES;
    [MobClick event:@"Sort_switching" label:@"最新发布"];
    [self showLoading];
    [self loadPageAtIndex:0 refreshData:YES];
}

#pragma mark -
- (void)conditionViewDidSelectedOption:(ArtistComSearchView *)conditionView
{
    [self showLoading];
    [self loadPageAtIndex:0];
}

- (BOOL)channelListViewShouldBeEdited:(MVChannelChooseView *)channelListView
{
    BOOL result = [[UserDataController sharedInstance] isLogin];
    if (!result) {
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
    else {
        [MobClick event:@"Mv_Channel" label:@"点击频道编辑"];
    }
    
    return result;
}


- (void)channelListView:(MVChannelChooseView *)channelListView didSelectedChannel:(MVChannel *)channel
{
    [self showLoading];
    [self loadPageAtIndex:0 refreshData:YES];
}

- (void)channelListView:(MVChannelChooseView *)channelListView didFinishEditingWithSubscribeChannels:(NSArray *)channels
{
    [self.dataController saveSubscribeChannels:channels
                                       success:^(MVChannelDataController *dataController) {
                                       }
                                       failure:^(MVChannelDataController *dataController, NSError *error) {
                                           [AlertWithTip flashFailedMessage:@"保存频道失败"];
                                       }];
}

#pragma mark - 数据请求

- (void)loadChannelList
{
    [self showLoading];
    __weak MVChannelViewController *weekSelf = self;
    [_dataController getChannelListSuccess:^(MVChannelDataController *dataController, NSArray *channelList) {
        [self hideLoading];
        [weekSelf loadChannelListViewWithlist:channelList];
        [weekSelf.gridView.pullToRefreshView startAnimating];
        [weekSelf loadPageAtIndex:0 refreshData:YES];
    } failure:^(MVChannelDataController *dataController, NSError *error) {
        [self hideLoading];
        [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        NSLog(@"%s error:%@",__func__,error);
        
        [self checkEmpty:_mvList];
    }];
}

- (void)loadSearchCondition
{
    __weak MVChannelViewController *weekSelf = self;
    [_dataController getSearchConditionSuccess:^(MVChannelDataController *dataController, NSArray *conditionList) {
        [weekSelf loadSearchViewWithConditions:conditionList]; //加载搜索条件界面
        //[weekSelf loadPageAtIndex:0]; //加载数据
    } failure:NULL];
}

//转换page与range
- (NSRange)rangeFromPageIndex:(NSInteger)index
{
    static const int pageSize = 20;
    NSRange range = NSMakeRange(0, pageSize*(index+1));
    return range;
}

- (void)loadPageAtIndex:(NSInteger)pageIndex;
{
    [self loadPageAtIndex:pageIndex refreshData:NO];
}

- (void)refreshData
{
    [self loadPageAtIndex:0 refreshData:YES];
}

- (void)loadPageAtIndex:(NSInteger)pageIndex refreshData:(BOOL)refresh
{
    if (_searchView==nil || _channelListView==nil) {
        return;
    }
    
    /*
    if (refresh) {
        [self.gridView.pullToRefreshView startAnimating];
    }
    else {
        [self.gridView.infiniteScrollingView startAnimating];
    }*/
    
    //range
    NSRange range = [self rangeFromPageIndex:pageIndex];
    
    //搜索条件
    UIView *searchView = _searchView;
    NSMutableSet *set = [NSMutableSet setWithCapacity:[[searchView subviews] count]];
    for (UIView *view in [searchView subviews]) {
        if ([view isKindOfClass:[ArtistComSearchView class]]) {
            MVSearchCondition *condition = [(ArtistComSearchView *)view condition];
            [set addObject:condition];
        }
    }
    
    //排序条件
    MVSearchCondition *condition = [MVSearchCondition MVOrderCondition];
    if ([_newSortBtn isSelected]) {
        [condition selectOptionAtIndex:0];
    } else {
        [condition selectOptionAtIndex:1];
    }
    [set addObject:condition];
    
    //频道
    NSArray *channels = [_channelListView selectedChannelArray];
    
    //发送请求
    __weak MVChannelViewController *weekSelf = self;
    
    void(^successBlock)(MVChannelDataController *, NSArray *) = ^(MVChannelDataController *dataController, NSArray *mvArray) {
        [self hideLoading];
        weekSelf.mvList = mvArray;
        weekSelf.currentPage = pageIndex;
        [weekSelf.gridView reloadData];
        if (refresh) {
            [weekSelf.gridView.pullToRefreshView stopAnimating];
            [weekSelf.gridView scrollToObjectAtIndex:0 atScrollPosition:GMGridViewScrollPositionTop animated:YES];
        }
        else {
            [weekSelf.gridView.infiniteScrollingView stopAnimating];
        }
    };
    
    void(^failureBlock)(MVChannelDataController *, NSError *) = ^(MVChannelDataController *dataController, NSError *error) {
        [self hideLoading];
        if (refresh) {
            [weekSelf.gridView.pullToRefreshView stopAnimating];
        } else {
            [weekSelf.gridView.infiniteScrollingView stopAnimating];
        }
    };
    
    if (refresh) {
        [self.dataController refreshSearchResultWithChannels:channels
                                            searchConditions:set
                                                      length:range.length
                                                     success:successBlock
                                                     failure:failureBlock];
    }
    else {
        [_dataController searchMVListWithChannels:channels
                                 searchConditions:set
                                            range:range
                                          success:successBlock
                                          failure:failureBlock];
    }
}

#pragma mark - GMGridView
#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    [self checkEmpty:_mvList];
    
    return [_mvList count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return [MVDescriptionView defaultSize];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        MVDescriptionView *itemView = [MVDescriptionView defaultSizeView];
        itemView.delegate = self;
        //itemView.tag = 111;
        //[cell addSubview:itemView];
        cell.contentView = itemView;
    }
    
    MVItem *item = [_mvList objectAtIndex:index];
    MVDescriptionView *itemView = (MVDescriptionView *)[cell contentView];
    itemView.tag = index;
    [itemView setContentWithMVItem:item];
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

#pragma GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
}

/*
 - (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
 {
 MVItem *item = [self.mvList objectAtIndex:position];
 YYTPlayerViewController *viewController = [[YYTPlayerViewController alloc] init];
 [self presentModalViewController:viewController animated:YES];
 [viewController loadPlayList:@[item] startImmediately:YES];
 }
 */

#pragma mark MVItemViewDelegate
- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView
{
    NSInteger index = mvItemView.tag;
    MVItem *item = [self.mvList objectAtIndex:index];
    MVDetailViewController *viewController = [[MVDetailViewController alloc] initWithId:[item.keyID stringValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView
{
    NSInteger index = mvItemView.tag;
    MVItem *item = [self.mvList objectAtIndex:index];
    [[AddMVToMLAssistantController sharedInstance] setMvToAdd:item];
}

- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist
{
    ArtistDetailViewController *viewController = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self doFresh];
}
@end
