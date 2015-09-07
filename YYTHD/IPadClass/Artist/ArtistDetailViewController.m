//
//  ArtistDetailViewController.m
//  YYTHD
//
//  Created by ssj on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "ArtistShow.h"
#import "MVChannelDataController.h"
#import "ArtistMVCell.h"
#import "ArtistDetailView.h"
#import "MVItemView.h"
#import "MVItem.h"
#import "MVDetailViewController.h"
#import "CombinationView.h"
#import "UserDataController.h"
#import "ArtistDetailViewController.h"
#import "MVSearchCondition.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PullToRefreshView.h"
#import "MVItemViewForSearch.h"

@interface ArtistDetailViewController (){
    YYTActivityIndicatorView *indicatorView;
}
@property(assign,nonatomic) BOOL bOn;   //YES出现条件选择
@property (assign,nonatomic)BOOL isAnimating;
@end

@implementation ArtistDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil artistID:(NSString *)artistID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.videoTableView.hidden = YES;
        [self refreshWithId:artistID];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak id weakSelf = self;
    self.bOn = YES;
    self.isAnimating = NO;
    topEdge = 0;
    UIView *searchView;

    if ([SystemSupport versionPriorTo7]) {
        topEdge = 0;
        self.videoTableView.contentInset = UIEdgeInsetsMake(60 + topEdge, 0, 60, 0);
        searchView = [[UIView alloc] initWithFrame:CGRectMake(0, topEdge + 59, CGRectGetWidth(self.view.frame), 60)];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        [self.view addSubview:view];
        topEdge = 20;
        self.videoTableView.contentInset = UIEdgeInsetsMake(60, 0, 60, 0);
        self.backBtn.centerY = self.backgroundImageView.centerY = self.comSearch.centerY = self.titleImageView.centerY = self.searchByHotBtn.centerY = self.searchByNewBtn.centerY += 20;
        searchView = [[UIView alloc] initWithFrame:CGRectMake(0, topEdge + 58, CGRectGetWidth(self.view.frame), 60)];
    }
    self.videoTableView.scrollIndicatorInsets = self.videoTableView.contentInset;
    [self.videoTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreVideos];
    }];
     self.searchByNewBtn.selected = YES;
    [self.searchByNewBtn setImage:IMAGE(@"sortByNew_s") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.searchByHotBtn setImage:IMAGE(@"sortByHot_s") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.comSearch setImage:IMAGE(@"Artist_Combination_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    
    // 添加组合查询条件
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:searchView.bounds];
    UIImage *image = [UIImage imageNamed:@"navi_bg"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    imageView.image = [image resizableImageWithCapInsets:edgeInsets];
//    searchView.backgroundColor = [UIColor yytTransparentBlackColor];
    searchView.clipsToBounds = YES;
    [searchView addSubview:imageView];
    _searchView = searchView;
    videoTypeView = [[ArtistComSearchView alloc] initWithFrame:CGRectMake(0, 0, 1024, 60) condition:[MVSearchCondition videoTypeCondition]];
    videoTypeView.actionDelegate = self;
    videoTypeView.tag = 1000;
    [_searchView addSubview:videoTypeView];
    [self.view addSubview:_searchView];
    [_searchView setHidden:YES];
    
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    self.videoTableView.backgroundColor = [UIColor clearColor];
    
    [self.videoTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
}

- (void)getMoreVideos{
    NSString *size= [NSString stringWithFormat:@"%d",(int)(self.videoList.count) + 24];
    if (self.searchByNewBtn.selected && !self.comSearch.selected) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artistID, @"artistId", size, @"size", nil];
        [artistDataController getArtistDetailWithArtistParams:params success:^(MVAristDataController *dataController, ArtistShow *artistShow) {
            self.videoList = artistShow.videos;
            self.artist = artistShow.artist;
            [self.videoTableView reloadData];
            [self cleanLoadingView];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else if (self.searchByHotBtn.selected && !self.comSearch.selected){
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"VideoPubDate",@"order",size,@"size", nil];
        [artistDataController searchByParams:params success:^(MVAristDataController *dataController, NSArray *videoArray) {
            self.videoList = videoArray;
            [self.videoTableView reloadData];
            [self cleanLoadingView];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else if (self.comSearch.selected){
        [self.searchParams setObject:size forKey:@"size"];
        [artistDataController searchByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *videoArray) {
            self.videoList = videoArray;
            [self.videoTableView reloadData];
            [self cleanLoadingView];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
   
}

- (void)cleanLoadingView
{
    if (self.videoTableView.showsInfiniteScrolling) {
        [self.videoTableView.infiniteScrollingView stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWithId:(NSString *)keyId{
    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
    [indicatorView setTipText:@"正在加载艺人详情,请稍候"];

    [self showLoading];
    
    self.videoTableView.backgroundColor = [UIColor yytBackgroundColor];
    self.videoList = [[NSArray alloc] init];
    self.artist = [[Artist alloc] init];
    self.artistID = keyId;
    self.searchParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.videoList = [[NSArray alloc] init];
    artistDataController = [[MVAristDataController alloc] init];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artistID, @"artistId", @"24", @"size", nil];
    [artistDataController getArtistDetailWithArtistParams:params success:^(MVAristDataController *dataController, ArtistShow *artistShow) {
//        [indicatorView stopAnimating];
        [self hideLoading];
        self.videoTableView.hidden = NO;
        self.videoList = artistShow.videos;
        self.artist = artistShow.artist;
        [self.videoTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        NSLog(@"%@",error);
//        [indicatorView stopAnimating];
    }];

}

- (void)animeToolView:(UIView *)toolView hidden:(BOOL)hidden
{
    self.isAnimating = YES;
    CGRect frame = toolView.frame;
    CGRect startFrame = frame;
    CGRect targetFrame = frame;
    UIEdgeInsets inset;
    if (!hidden) {
        startFrame.size.height = 0;
        inset = UIEdgeInsetsMake(60+topEdge + 60, 0, 60, 0);
    } else {
        targetFrame.size.height = 0;
        inset = UIEdgeInsetsMake(60+topEdge, 0, 60, 0);
    }
    
    toolView.frame = startFrame;
    toolView.hidden = NO;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         toolView.frame = targetFrame;
                         self.videoTableView.contentInset = inset;
                         if (self.videoList.count>0) {
                             [self.videoTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         toolView.frame = frame;
                         toolView.hidden = hidden;
                         self.isAnimating = NO;
                     }];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.videoList.count + 1;
    if (self.videoList.count % 4 == 0) {
        return self.videoList.count/4+1;
    }else{
        return self.videoList.count/4+2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [ArtistDetailView defaultSize].height + 10;
    }else{
        return [MVItemView defaultSize].height +10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID  = @"CELLID";
    ArtistMVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArtistMVCell" owner:self options:nil] lastObject];
    }
    for (UIView *aView in cell.contentView.subviews) {
        if ([aView isKindOfClass:[MVItemView class]] || [aView isKindOfClass:[ArtistDetailView class]]) {
            [aView removeFromSuperview];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    if (self.artist.name != nil && indexPath.row == 0) {
        ArtistDetailView *artistDetail = [[[NSBundle mainBundle] loadNibNamed:@"ArtistDetailView" owner:self options:nil] lastObject];
        artistDetail.frame = CGRectMake(5, 5, 330, 120);
        artistDetail.delegate = self;
        artistDetail.tag = 200;
        UIImage *image = [UIImage imageNamed:@"ArtistOrder_BackGroundView"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        cell.backgroundView.image = [image resizableImageWithCapInsets:edgeInsets];
        artistDetail.backgroundImageView.hidden = YES;
        [artistDetail setContentWithArtist:self.artist];
        if ([self.artist.sub boolValue]) {
            artistDetail.orderBtn.hidden = YES;
            artistDetail.cancelBtn.hidden = NO;
        }else{
            artistDetail.orderBtn.hidden = NO;
            artistDetail.cancelBtn.hidden = YES;
        }
        
        [cell.contentView addSubview:artistDetail];
    }else{
        NSInteger indexRow = self.videoList.count / 4;
        int surplus = self.videoList.count % 4;
        if (self.videoList.count == 0) {
            return cell;
        }
        if (indexRow == 0) {
            for (int i = 0; i < surplus; i++) {
                MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + i;
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:i]];
                [cell.contentView addSubview:mvItemView];
            }
            
        }else if (indexPath.row-1 < indexRow && indexRow != 0){
            for (int i = 0; i < 4; i++) {
                MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row-1)*4+i;
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1)*4+i]];
                [cell.contentView addSubview:mvItemView];
            }
        }else{
            for (int i = 0; i < surplus; i++) {
                MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row-1)*4+i;
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1)*4+i]];
                [cell.contentView addSubview:mvItemView];
            }
        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

#pragma mark - mvItemView delegate
- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView{
    if ([UserDataController sharedInstance].isLogin) {
        [AddMVToMLAssistantController sharedInstance].mvToAdd = mvItemView.mvItem;
    }else{
        [self doLogin];
    }
}

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView{
    MVItem *mvItem = [self.videoList objectAtIndex:mvItemView.tag - 200];
    MVDetailViewController *mvDetailVC = [[MVDetailViewController alloc] initWithId:[mvItem.keyID stringValue]];
    [self.navigationController pushViewController:mvDetailVC animated:YES];
}

- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist{
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

#pragma  mark - artistDetailView delegate

- (void)artistOrderClicked:(ArtistDetailView *)artistDetailView{
    //NSLog(@"indexorder == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    
    [artistDataController createArtistWithArtistID:self.artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistDetailView.orderBtn.hidden = YES;
        artistDetailView.cancelBtn.hidden = NO;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artistID, @"artistId", @"24", @"size", nil];
        [artistDataController getArtistDetailWithArtistParams:params success:^(MVAristDataController *dataController, ArtistShow *artistShow) {
//            [indicatorView stopAnimating];
            self.videoTableView.hidden = NO;
            self.videoList = artistShow.videos;
            self.artist = artistShow.artist;
            [self.videoTableView reloadData];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            NSLog(@"%@",error);
//            [indicatorView stopAnimating];
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

- (void)artistCancelClicked:(ArtistDetailView *)artistDetailView{
    //NSLog(@"indexcancel == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    [artistDataController deleteArtistWithArtistID:self.artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
            artistDetailView.orderBtn.hidden = NO;
            artistDetailView.cancelBtn.hidden = YES;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artistID, @"artistId", @"24", @"size", nil];
        [artistDataController getArtistDetailWithArtistParams:params success:^(MVAristDataController *dataController, ArtistShow *artistShow) {
            [indicatorView stopAnimating];
            self.videoTableView.hidden = NO;
            self.videoList = artistShow.videos;
            self.artist = artistShow.artist;
            [self.videoTableView reloadData];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            NSLog(@"%@",error);
//            [indicatorView stopAnimating];
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

#pragma mark - search
- (IBAction)seachByNew:(id)sender {
    [MobClick event:@"Sort_switching" label:@"最新发布"];
    self.searchByNewBtn.selected = YES;
    self.searchByHotBtn.selected = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"VideoPubDate",@"order",@"24",@"size", nil];
    [artistDataController searchByParams:params success:^(MVAristDataController *dataController, NSArray *videoArray) {
        self.videoList = videoArray;
        [self.videoTableView reloadData];
        [self cleanLoadingView];
        if (self.videoList.count>0) {
            [self.videoTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }

    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}
- (IBAction)searchByHot:(id)sender {
    [MobClick event:@"Sort_switching" label:@"最热播放"];
    self.searchByNewBtn.selected = NO;
    self.searchByHotBtn.selected = YES;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"TotalViews",@"order",@"24",@"size", nil];
    [artistDataController searchByParams:params success:^(MVAristDataController *dataController, NSArray *videoArray) {
        self.videoList = videoArray;
        [self.videoTableView reloadData];
        [self cleanLoadingView];
        if (self.videoList.count>0) {
            [self.videoTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}
- (IBAction)comSearch:(id)sender {
    self.comSearch.selected = !self.comSearch.selected;
    [MobClick event:@"Sort_switching" label:@"组合查询"];
    if (!self.isAnimating) {
        self.bOn = !self.bOn;
        [self animeToolView:_searchView hidden:self.bOn];
    }
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CombinationView delegate
- (void)comBtnClicked:(NSString *)condition{
    NSLog(@"condition == %@",condition);
//    self.videoTableView.tableHeaderView = nil;
    if (self.searchByNewBtn.selected) {
        [self.searchParams removeAllObjects];
         self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"VideoPubDate",@"order",@"24",@"size",condition,@"videoType", nil];
    }else{
        [self.searchParams removeAllObjects];
         self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"TotalViews",@"order",@"24",@"size",condition,@"videoType", nil];
    }
    [artistDataController searchByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *videoArray) {
        self.videoList = videoArray;
        [self.videoTableView reloadData];
        [self cleanLoadingView];
        if (self.videoList.count>0) {
            [self.videoTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

- (void)conditionViewDidSelectedOption:(ArtistComSearchView *)conditionView{
    [indicatorView setTipText:@"正在加载视频,请稍候"];
    [indicatorView startAnimating];
    NSDictionary * dict = [conditionView.condition resultForSever];
    if (self.searchByNewBtn.selected) {
        [self.searchParams removeAllObjects];
        if (dict == NULL) {
            self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"VideoPubDate",@"order",@"24",@"size", nil];
            [self.searchParams setObject:@"" forKey:@"videoType"];
        }else{
            if ([dict objectForKey:@"videoType"] != nil) {
                self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"VideoPubDate",@"order",@"24",@"size", nil];
                [self.searchParams setObject:[dict objectForKey:@"videoType"] forKey:@"videoType"];
            }
        }
    }else{
        [self.searchParams removeAllObjects];
        if (dict == NULL) {
            self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"TotalViews",@"order",@"24",@"size", nil];
            [self.searchParams setObject:@"" forKey:@"videoType"];
        }else{
            if ([dict objectForKey:@"videoType"] != nil) {
                self.searchParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.artist.name,@"keyword",@"TotalViews",@"order",@"24",@"size", nil];
                [self.searchParams setObject:[dict objectForKey:@"videoType"] forKey:@"videoType"];
            }
        }
    }
    [artistDataController searchByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *videoArray) {
        [indicatorView stopAnimating];
        self.videoList = videoArray;
        [self.videoTableView reloadData];
        [self cleanLoadingView];
        if (self.videoList.count>0) {
            [self.videoTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
        [indicatorView stopAnimating];
    }];}

@end
