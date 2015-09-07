//
//  NewsListViewController.m
//  YYTHD
//
//  Created by IAN on 14-3-11.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsItemCell.h"
#import "NewsItem.h"
#import "NewsDataController.h"
#import "YYTAlertView.h"
#import "NewsDetailViewController.h"
#import "PullToRefreshView.h"

static NSString * const kCellReuseIdentifier = @"NewsItemCell";
static const NSUInteger kPageSize = 10;

@interface NewsListViewController ()
{
    YYTNewsType _newsType;
    IBOutlet __weak UIButton *_selectedBtn;
}
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NewsDataController *dataController;

- (NSArray *)curNewsList;

@end

@implementation NewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [[NewsDataController alloc] init];
        _newsType = YYTNewsTypeML;
        
        NSNull *nullObject = [NSNull null];
        NSMutableArray *list = [NSMutableArray arrayWithObjects:nullObject,nullObject,nullObject,nullObject,nullObject,nullObject, nil];
        self.newsList = list;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.topView setTitleImage:[UIImage imageNamed:@"News_title"]];
    
    self.collectionView.backgroundColor = [UIColor yytBackgroundColor];
    if([SystemSupport versionPriorTo7]) {
        UIEdgeInsets contentInset = UIEdgeInsetsMake(130, 0, 62, 0);
        self.collectionView.contentInset = contentInset;
        self.collectionView.scrollIndicatorInsets = contentInset;
    }
    else {
        UIEdgeInsets contentInset = UIEdgeInsetsMake(150, 0, 62, 0);
        self.collectionView.contentInset = contentInset;
        self.collectionView.scrollIndicatorInsets = contentInset;
    }
    
    __weak NewsListViewController *wself = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [wself refreshData];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [wself loadMore];
    }];
    
    UIScrollView *scrollView = self.collectionView;
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [scrollView.pullToRefreshView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];
    

    //register Nib for collection view
    UINib *cellNib = [UINib nibWithNibName:@"NewsItemCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    //选中内地
    [self reloadData];
}

- (IBAction)areaChangeEvent:(UIButton *)sender
{
    if (_selectedBtn != sender) {
        YYTNewsType type = [self newsTypeForAreaBtnTag:sender.tag];
        [sender setSelected:YES];
        [_selectedBtn setSelected:NO];
        _selectedBtn = sender;
        
        _newsType = type;
        [self reloadData];
    }
}

- (YYTNewsType)newsTypeForAreaBtnTag:(NSInteger)tag
{
    YYTNewsType type = YYTNewsTypeML;
    switch (tag) {
        case 111:
            type = YYTNewsTypeML;
            break;
        case 112:
            type = YYTNewsTypeHK;
            break;
        case 113:
            type = YYTNewsTypeEU;
            break;
        case 114:
            type = YYTNewsTypeSK;
            break;
        case 115:
            type = YYTNewsTypeJP;
            break;
        case 116:
            type = YYTNewsTypeEX;
            break;
        default:
            break;
    }
    return type;
}

- (void)reloadData
{
    NSArray *array = [self curNewsList];
    if ([array count]) {
        [self.collectionView reloadData];
    }
    else {
        [self getNewsListForPage:0];
    }
}

- (void)refreshData
{
    self.page = 0;
    [self showLoading];
    __weak NewsListViewController *weekSelf = self;
    [self.dataController refreshNewsListWithType:_newsType
                                          length:kPageSize
                               completionHandler:^(NSArray *newsList, NSError *error) {
                                   [weekSelf hideLoading];
                                   [weekSelf.collectionView.pullToRefreshView stopAnimating];
                                   if (error) {
                                       NSString *message = [error yytErrorMessage];
                                       [YYTAlertView flashFailureMessage:message];
                                   }
                                   else {
                                       [self setNewsList:newsList forType:_newsType];
                                       [self.collectionView reloadData];
                                   }
                               }];
}

- (void)loadMore
{
    [self getNewsListForPage:self.page+1];
}

- (void)getNewsListForPage:(NSUInteger)pageIndex
{
    if (pageIndex == 0) {
        [self showLoading];
    }
    self.page = pageIndex;
    NSInteger length = (pageIndex+1)*kPageSize;
    __weak NewsListViewController *weekSelf = self;
    [self.dataController getNewsListWithType:_newsType
                                       range:NSMakeRange(0, length)
                           completionHandler:^(NSArray *newsList, NSError *error) {
                               [weekSelf hideLoading];
                               [weekSelf.collectionView.infiniteScrollingView stopAnimating];
                               if (error) {
                                   NSString *message = [error yytErrorMessage];
                                   [YYTAlertView flashFailureMessage:message];
                               }
                               else {
                                   [weekSelf setNewsList:newsList forType:_newsType];
                                   [weekSelf.collectionView reloadData];
                               }
                           }];
}

- (NSArray *)curNewsList
{
    NSInteger index = (NSInteger)_newsType;
    id obj = [self.newsList objectAtIndex:index];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

- (void)setNewsList:(NSArray *)newsList forType:(YYTNewsType)type
{
    NSInteger index = (NSInteger)type;
    [self.newsList replaceObjectAtIndex:index withObject:newsList];
}


#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.curNewsList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemCell *cell = (NewsItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    NewsItem *item = [self.curNewsList objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@   %@",item.userName,item.createTime];
    //cell.summaryLabel.text = item.summary;
    [cell setSummaryText:item.summary];
    [cell setImageWithURL:item.imageURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    NewsItem *item = [self.curNewsList objectAtIndex:indexPath.item];
    [detailViewController loadNewsWithID:item.keyID];
}

@end
