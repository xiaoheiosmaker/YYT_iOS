//
//  MVCollectionViewController.m
//  YYTHD
//
//  Created by IAN on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVCollectionViewController.h"
#import "MVItemView.h"
#import "MVDataController.h"
#import "MVDetailViewController.h"
#import "AddMVToMLAssistantController.h"
#import "MVItem.h"
#import <SIAlertView.h>
#import "ArtistDetailViewController.h"
#import "ExButton.h"
#import "PullToRefreshView.h"

@interface MVCollectionViewController ()<GMGridViewActionDelegate,GMGridViewDataSource,MVItemViewDelegate>
{
    ExButton *_editBtn;
}
@property (nonatomic, strong) NSArray *collectionArray;
@property (nonatomic, strong) GMGridView *gridView;
@property (nonatomic, strong) MVDataController *dataController;
@property (nonatomic, assign) NSInteger curPage;

@end

@implementation MVCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [MVDataController sharedDataController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.emptyViewController.holderImage = IMAGE(@"没有收藏");
    self.emptyViewController.holderText = NOCOLLECTMV;
    
    //为全屏大小的ScrollView添加contentInset，为上层控件留白。
    CGFloat topEdge = kTopBarHeight+5;
    if (![SystemSupport versionPriorTo7]) {
        topEdge += 20;
    }
    
    [self.topView isShowSideButton:YES];
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"myCollection_title"]];
    
    UIImage *normalImg = [UIImage imageNamed:@"ml_edit"];
    UIImage *highImg = [UIImage imageNamed:@"ml_edit_h"];
    CGSize size = normalImg.size;
    CGFloat x = 1024 - (size.width + 10);
    CGFloat y = (kTopBarHeight - size.height) / 2;
    ExButton *editBtn = [[ExButton alloc] initWithFrame:CGRectMake(x, y, size.width, size.height)];
    [editBtn setNormalImage:normalImg highlightedImage:highImg];
    [editBtn setExSelectedImage:[UIImage imageNamed:@"ml_confirm"] highlightedImage:[UIImage imageNamed:@"ml_confirm_h"]];
    [editBtn addTarget:self
                 action:@selector(editBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:editBtn];
    _editBtn = editBtn;
    
    __weak MVCollectionViewController *weekSelf = self;
    [self.gridView addPullToRefreshWithActionHandler:^{
        [weekSelf refreshCollections];
    }];
    
    [self.gridView addInfiniteScrollingWithActionHandler:^{
        [weekSelf requestCollectionsAtPage:weekSelf.curPage+1];
    }];
    
    UIScrollView *scrollView = self.gridView;
//    [scrollView.pullToRefreshView setTitle:@"正在刷新" forState:SVPullToRefreshStateLoading];
//    [scrollView.pullToRefreshView setTitle:@"下拉可以刷新" forState:SVPullToRefreshStateStopped];
//    [scrollView.pullToRefreshView setTitle:@"松开可以刷新" forState:SVPullToRefreshStateTriggered];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    
    [scrollView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
    UIEdgeInsets edges = UIEdgeInsetsMake(topEdge, 0, kButtomBarHeight+5, 0);;
    CGRect frame = UIEdgeInsetsInsetRect(self.view.bounds, edges);
    self.gridView.frame = frame;
    self.gridView.sortingDelegate = nil; //禁止长按拖动
    self.gridView.centerGrid = NO;
    self.gridView.itemSpacing = 4;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showLoading];
    [self refreshCollections];
    //[self.gridView.pullToRefreshView startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BOOL isEditing = [_editBtn exSelected];
    if (isEditing) {
        [self editBtnClicked:_editBtn];
    }
}

#pragma mark - Btn actions
- (void)editBtnClicked:(ExButton *)sender
{
    BOOL isEditing = [sender exSelected];
    if (!self.collectionArray.count && !isEditing) {
        return;
    }
    
    self.gridView.editing = !isEditing;
    //[self.gridView setEditing:!isEditing animated:YES];
    [sender setExSelected:!isEditing];
    //[self makeAllModuleEntranceDisappear:!isEditing];
}

#pragma mark -
#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    [self checkEmpty:self.collectionArray];
    return self.collectionArray.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return [MVItemView defaultSize];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        //添加删除按钮
        cell.deleteButtonIcon = [UIImage imageNamed:@"delete"];
        cell.deleteButtonOffset = CGPointMake(-5, -5);
        
        MVItemView *itemView = [MVItemView defaultSizeView];
        itemView.delegate = self;
        cell.contentView = itemView;
    }
    
    MVItem *item = [self.collectionArray objectAtIndex:index];
    
    MVItemView *itemView = (MVItemView *)cell.contentView;
    [itemView setContentWithMVItem:item];
    itemView.tag = index;
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{

}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    MVItem *item = [self.collectionArray objectAtIndex:index];
    
    YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"确定要移除此收藏？"
                                           confirmBlock:^{
                                               [self removeCollection:item];
                                           }];
    [alert showInView:self.view];
}

- (void)removeCollection:(MVItem *)item
{
    __weak GMGridView *gridView = self.gridView;
    [self.dataController removeCollection:item
                    withCompletionHandler:^(NSArray *collections, NSError *error) {
                        if (error) {
                            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
                        } else {
                            [AlertWithTip flashSuccessMessage:@"删除收藏成功！"];
                        }
                        self.collectionArray = collections;
                        
                        [gridView reloadData];
                    }];
}

#pragma mark - MVItemView Delegate
- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView
{
    MVItem *item = [self.collectionArray objectAtIndex:mvItemView.tag];
    [[AddMVToMLAssistantController sharedInstance] setMvToAdd:item];
}

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView
{
    MVItem *item = [self.collectionArray objectAtIndex:mvItemView.tag];
    MVDetailViewController *viewController = [[MVDetailViewController alloc] initWithId:[item.keyID stringValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist{
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

#pragma mark - Request
- (NSRange)rangeFromPage:(NSInteger)page
{
    static NSInteger pageSize = 20;
    NSRange range = {0, pageSize*(page+1)};
    return range;
}

- (void)requestCollectionsAtPage:(NSInteger)page
{
    __weak MVCollectionViewController *weekSelf = self;
    NSRange range = [self rangeFromPage:page];
    [_dataController getCollectionsWithRange:range completionHandler:^(NSArray *collections, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
            [weekSelf checkEmpty:weekSelf.collectionArray];
            return;
        }
        weekSelf.curPage = page;
        weekSelf.collectionArray = collections;
        
        [weekSelf.gridView reloadData];
        [weekSelf.gridView.infiniteScrollingView stopAnimating];
    }];
}

- (void)refreshCollections
{
    __weak MVCollectionViewController *weekSelf = self;
    NSRange range = [self rangeFromPage:0];
    [_dataController refreshCollectionsWithlength:range.length
                                completionHandler:^(NSArray *collections, NSError *error) {
                                    [self hideLoading];
                                    if (error) {
                                        [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
                                        [weekSelf checkEmpty:weekSelf.collectionArray];
                                        return;
                                    }
                                    weekSelf.curPage = 0;
                                    weekSelf.collectionArray = collections;
                                    
                                    [weekSelf.gridView reloadData];
                                    [weekSelf.gridView.pullToRefreshView stopAnimating];
                                }];
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self refreshCollections];
}

@end
