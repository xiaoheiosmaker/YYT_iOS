//
//  ListViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLViewController.h"
#import "MLItemView.h"
#import "MLItem.h"
#import "MLList.h"
#import "MLDataController.h"
#import "MLAuthor.h"
#import "YYTInfiniteView.h"
#import "UserDataController.h"
#import <QuartzCore/QuartzCore.h>
#import "MLParticularViewController.h"

#define LENGTH_PER_REQUEST 20
#define TOP_BAR_RIGHT_SPACE 10.0

@interface MLViewController ()

- (void)addMoreMLs:(NSMutableArray *)moreMLs;
@end

@implementation MLViewController
@synthesize mlList = _mlList;
- (id)initWithEditable:(BOOL)editable
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.editable = editable;
        self.needCommit = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithEditable:NO];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.view.backgroundColor = [UIColor colorWithHEXColor:0xffffff];
    
    GMGridView *gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.style = GMGridViewStylePush;
    gridView.itemSpacing = 8;
    gridView.centerGrid = NO;
    gridView.dataSource = self;
    gridView.actionDelegate = self;
    [self.view addSubview:gridView];
    _gridView = gridView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.editable) {
        [self.topView addSubview:self.editBtn];
        [self.topView addSubview:self.doneBtn];
        self.doneBtn.hidden = YES;
        self.editing = NO;
        [self.topView isShowTextField:NO];
        [self.topView isShowTimeButton:NO];
    }
    
    CGFloat statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    CGFloat yytTopBarHeight = kTopBarHeight;
    CGFloat yytBottomBarHeight = kButtomBarHeight;
    
    CGRect restRect = self.view.bounds;
    restRect.size.height -= statusBarHeight + yytTopBarHeight + yytBottomBarHeight;
    restRect.origin.y = statusBarHeight + yytTopBarHeight;
    
    _gridView.frame = restRect;
    int topInset = 4;
    int sideInset = 7;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(topInset, sideInset, topInset, sideInset);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.editing)
        self.editing = NO;
}

- (NSMutableArray *)mlList
{
    if (!_mlList) {
        _mlList = [NSMutableArray array];
    }
    return _mlList;
}

- (void)setMlList:(NSMutableArray *)mlList
{
    [self.mlList removeAllObjects];
    [self.mlList addObjectsFromArray:mlList];
    [_gridView reloadData];
    [_gridView scrollToObjectAtIndex:0 atScrollPosition:GMGridViewScrollPositionTop animated:YES];
}

- (void)setEditing:(BOOL)editing
{
    if (super.editing != editing) {
        super.editing = editing;
        _gridView.editing = super.editing;
    }
}

- (void)editBtnClicked:(id)sender
{
    self.editing = YES;
}

- (void)doneBtnClicked:(id)sender
{
    self.editing = NO;
}

- (void)addMoreMLs:(NSMutableArray *)moreMLs
{
    int mlCount = [self.mlList count];
    [self.mlList addObjectsFromArray:moreMLs];
    int countDelta = [self.mlList count] - mlCount;
    for (int i = 0; i < countDelta; i++) {
        [_gridView insertObjectAtIndex:mlCount + i withAnimation:GMGridViewItemAnimationFade];
    }
}

- (void)completeLoadingData
{
    [self hideLoading];
    if (_gridView.showsPullToRefresh) {
        [_gridView.pullToRefreshView stopAnimating];
    }
    if (_gridView.showsInfiniteScrolling) {
        [_gridView.infiniteScrollingView stopAnimating];
    }
    
    [self checkEmpty:self.mlList];
}

- (void)fetchPickMLList
{
    [self showLoading];
    NSRange range = NSMakeRange(0, LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
        else {
            self.mlList = [list mutableCopy];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchPickMLListForRange:range completion:completionBlock];
}

- (void)morePickMLList
{
    NSRange range = NSMakeRange([self.mlList count], LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        } else {
            [self addMoreMLs:[list mutableCopy]];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchPickMLListForRange:range completion:completionBlock];
}

- (void)fetchFavoriteMLList
{
    [self showLoading];
    NSRange range = NSMakeRange(0, LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
        else {
            self.mlList = [list mutableCopy];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchFavoriteMLList:range completion:completionBlock];
}

- (void)moreFavoriteMLList
{
    NSRange range = NSMakeRange([self.mlList count], LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        } else {
            [self addMoreMLs:[list mutableCopy]];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchFavoriteMLList:range completion:completionBlock];
}

- (void)fetchOwnMLList
{
    [self showLoading];
    NSRange range = NSMakeRange(0, LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
        else {
            self.mlList = [list mutableCopy];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchOwnMLListForRange:range completion:completionBlock];
}

- (void)moreOwnMLList
{
    NSRange range = NSMakeRange([self.mlList count], LENGTH_PER_REQUEST);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (error) {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
        else {
            [self addMoreMLs:[list mutableCopy]];
        }
        [self completeLoadingData];
    };
    [[MLDataController sharedObject] fetchOwnMLListForRange:range completion:completionBlock];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    MLItem *item = [self.mlList objectAtIndex:position];
    MLParticularViewController *particularViewController = [[MLParticularViewController alloc] init];
    particularViewController.item = item;
    [self.navigationController pushViewController:particularViewController animated:YES];
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"确定删除此悦单?" confirmBlock:^{
        [self deleteItem:[self.mlList objectAtIndex:index]];
    }];
    [alert viewShow];
}

- (void)deleteItem:(MLItem *)item
{
}

#pragma mark - GMGridViewDataSource
- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(245, 296);
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.mlList count];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    MLItemView *itemView;
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"delete"];
        cell.deleteButtonOffset = CGPointMake(cell.deleteButtonIcon.size.width / -2.0, cell.deleteButtonIcon.size.height / -2.0);
        cell.deleteButtonOffset = CGPointMake(0, 0);
        itemView = [[[NSBundle mainBundle] loadNibNamed:@"MLItemView" owner:nil options:nil] lastObject];
        UIImage *background = [UIImage imageNamed:@"ml_list_item_background2"];
        background = [background imageWithAlignmentRectInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        itemView.backgoundView.image = background;
        background = [UIImage imageNamed:@"ml_list_header_backgorund"];
        itemView.authorImageView.image = background;
        itemView.origin = CGPointMake(itemView.origin.x, itemView.origin.y - 3);
        itemView.authorImageView.layer.cornerRadius = 24.0f;
        itemView.authorImageView.layer.masksToBounds = YES;
        cell.contentView = itemView;
    }
    itemView = (MLItemView *)cell.contentView;
    [itemView.coverImageView cancelCurrentImageLoad];
    [itemView.coverImageView setImage:nil];
    [itemView.authorImageView cancelCurrentImageLoad];
    [itemView.authorImageView setImage:nil];
    itemView.authorLabel.text = @"";
    itemView.titleLabel.text = @"";
    [itemView.loadingIndicator startAnimating];
    
    MLItem *item = [self.mlList objectAtIndex:index];
    itemView.authorLabel.text = item.author.nickName;
    itemView.titleLabel.text = item.title;
    NSURL *coverImageURL = item.playListBigPic ? item.playListBigPic : item.playListPic;
    
    [itemView.coverImageView setImageWithURL:coverImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            [itemView.loadingIndicator stopAnimating];
        }];
    
    NSURL *creatorAvatar;
    if (item.author) {
        creatorAvatar = item.author.largeAvatar;
    }
    else if ([[UserDataController sharedInstance] isLogin])
    {
        creatorAvatar = [[UserDataController sharedInstance] currentUser].largeAvatar;
    }
    if (creatorAvatar) {
        [itemView.authorImageView setImageWithURL:creatorAvatar placeholderImage:[UIImage imageNamed:@"headIcon"]];
    }
    
    return cell;
}


@end
