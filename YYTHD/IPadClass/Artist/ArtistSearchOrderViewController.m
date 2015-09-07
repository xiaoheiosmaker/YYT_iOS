//
//  ArtistSearchOrderViewController.m
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistSearchOrderViewController.h"
#import "ArtistOrderView.h"
#import "ArtistOrderCell.h"
#import "ArtistDetailView.h"
#import "ArtistDetailViewController.h"
#import "ArtistMVCell.h"
#import "Artist.h"
#import "MVSearchConditionView.h"
#import "MVSearchCondition.h"
#import "UserDataController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PullToRefreshView.h"
@interface ArtistSearchOrderViewController ()
{
    
}
@property (assign, nonatomic) BOOL bOn;   //YES出现条件选择
@property (assign, nonatomic) BOOL isAnimating;
@end

@implementation ArtistSearchOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        artistDataController = [[MVAristDataController alloc] init];
        _artistList = [[NSArray alloc] init];
        _suggestArtistList = [[NSArray alloc] init];
        self.changeParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.searchParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.changeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6", @"size", nil];
        currentOffset = 0;
        
        [self getArtist];
    }
    return self;
}

- (void)getArtist{
    [self showLoading];
    [artistDataController getSuggestArtistWithParams:self.changeParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
//        [indicatorView stopAnimating];
        self.suggestArtistList = artistArray;
        [self.artistTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"24", @"size", nil];
    [artistDataController searchArtistByParams:dict success:^(MVAristDataController *dataController, NSArray *artistArray) {
        [self hideLoading];
//        [indicatorView stopAnimating];
        self.artistList = artistArray;
        [self.artistTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        [self hideLoading];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bOn = YES;
    self.isAnimating = NO;
    topEdge = 0;
    UIView *searchView;
    if ([SystemSupport versionPriorTo7]) {
        topEdge = 0;
        self.artistTableView.contentInset = UIEdgeInsetsMake(60 + topEdge, 0, 60, 0);
        searchView = [[UIView alloc] initWithFrame:CGRectMake(0, topEdge + 59, CGRectGetWidth(self.view.frame), 120)];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        [self.view addSubview:view];
        topEdge = 20;
        self.artistTableView.contentInset = UIEdgeInsetsMake(60, 0, 60, 0);
        self.backBtn.centerY = self.backgroundImageView.centerY = self.searchComBtn.centerY = self.titleImageView.centerY += 20;
        searchView = [[UIView alloc] initWithFrame:CGRectMake(0, topEdge + 58, CGRectGetWidth(self.view.frame), 120)];
    }
    self.artistTableView.scrollIndicatorInsets = self.artistTableView.contentInset;
    __weak id weakSelf = self;
    [self.artistTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreArtists];
    }];
    
    
// 添加组合查询条件
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:searchView.bounds];
    UIImage *image = [UIImage imageNamed:@"navi_bg"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    imageView.image = [image resizableImageWithCapInsets:edgeInsets];
    [searchView addSubview:imageView];
//    searchView.backgroundColor = [UIColor yytTransparentBlackColor];
    searchView.clipsToBounds = YES;
    _searchView = searchView;
    areaView = [[ArtistComSearchView alloc] initWithFrame:CGRectMake(0, 0, 1024, 60) condition:[MVSearchCondition areaCondition]];
    areaView.actionDelegate = self;
    areaView.tag = 1000;
    areaView.title = @"艺人地区";
    singerTypeView =  [[ArtistComSearchView alloc] initWithFrame:CGRectMake(0, 60, 1024, 60) condition:[MVSearchCondition singerTypeCondition]];
    singerTypeView.actionDelegate = self;
    singerTypeView.tag = 2000;
    singerTypeView.title = @"艺人类别";
    [_searchView addSubview:areaView];
    [_searchView addSubview:singerTypeView];
    [self.view addSubview:_searchView];
    [_searchView setHidden:YES];
    
    
    self.artistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    self.artistTableView.backgroundColor = [UIColor clearColor];
    [self.view sendSubviewToBack:self.artistTableView];
    
    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
    [indicatorView setTipText:@"正在加载艺人列表，请稍候。。。"];
//    [indicatorView startAnimating];
    
    [self.artistTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
}

- (void)getMoreArtists{
    NSString *size = [NSString stringWithFormat:@"%d",self.artistList.count + 12];
    [self.searchParams setObject:size forKey:@"size"];
    [artistDataController searchArtistByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
        self.artistList = artistArray;
        [self.artistTableView reloadData];
        [self cleanLoadingView];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        [self cleanLoadingView];
    }];
    
}

- (void)cleanLoadingView
{
    if (self.artistTableView.showsInfiniteScrolling) {
        [self.artistTableView.infiniteScrollingView stopAnimating];
    }
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
        inset = UIEdgeInsetsMake(60+topEdge + 120, 0, 60, 0);
    } else {
        targetFrame.size.height = 0;
        inset = UIEdgeInsetsMake(60+topEdge, 0, 60, 0);
    }
    
    toolView.frame = startFrame;
    toolView.hidden = NO;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         toolView.frame = targetFrame;
                         self.artistTableView.contentInset = inset;
                         if (self.artistList.count > 0) {
                             [self.artistTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                         }
                     }
                     completion:^(BOOL finished) {
                         toolView.frame = frame;
                         toolView.hidden = hidden;
                         self.isAnimating = NO;
                     }];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)comSearchBtnClicked:(id)sender {
    [MobClick event:@"Sort_switching" label:@"组合查询"];
    if (!self.isAnimating) {
         self.bOn = !self.bOn;
        [self animeToolView:_searchView hidden:self.bOn];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.artistList.count % 3 == 0) {
        return self.artistList.count/3+1;
    }else{
        return self.artistList.count/3+2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 274;
    }else{
        return [ArtistDetailView defaultSize].height + 10;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellID = @"ArtistOrderCell";
        ArtistOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"ArtistOrderCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell resetScrollView:self.suggestArtistList];
        return cell;
    }else{
        static NSString *cellID = @"CELLID";
        ArtistMVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArtistMVCell" owner:self options:nil] lastObject];
        }
        for (UIView *aView in cell.contentView.subviews) {
            if ([aView isKindOfClass:[MVItemView class]] || [aView isKindOfClass:[ArtistDetailView class]]) {
                [aView removeFromSuperview];
            }
        }
        int indexRow = self.artistList.count / 3;
        int surplus = self.artistList.count % 3;
        if (self.artistList.count == 0) {
            return cell;
        }
        cell.backgroundColor = [UIColor clearColor];
        if (indexRow == 0) {
            for (int i = 0; i < surplus; i++) {
                ArtistDetailView *artistDetailView = [[[NSBundle mainBundle] loadNibNamed:@"ArtistDetailView" owner:self options:nil] lastObject];
                artistDetailView.frame = CGRectMake(12 + 330*i +5 * i, 5, 300, 120);
                artistDetailView.delegate = self;
                artistDetailView.tag = 200 + i;
                [artistDetailView setContentWithArtist:[self.artistList objectAtIndex:i]];
                Artist *art = [self.artistList objectAtIndex:i];
                if ([art.sub boolValue]) {
                    artistDetailView.orderBtn.hidden = YES;
                    artistDetailView.cancelBtn.hidden = NO;
                }else{
                    artistDetailView.orderBtn.hidden = NO;
                    artistDetailView.cancelBtn.hidden = YES;
                }
                [artistDetailView.headImageView setImageWithURL:[NSURL URLWithString:art.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
                artistDetailView.headImageView.size = CGSizeMake(83, 83);
                [cell.contentView addSubview:artistDetailView];
            }
            
        }else if (indexPath.row - addComSearch-1 < indexRow && indexRow != 0){
            for (int i = 0; i < 3; i++) {

                ArtistDetailView *artistDetailView = [[[NSBundle mainBundle] loadNibNamed:@"ArtistDetailView" owner:self options:nil] lastObject];
                artistDetailView.frame = CGRectMake(12 + 330*i +5 * i,5, 300, 120);
                artistDetailView.delegate = self;
                artistDetailView.tag = 200 + (indexPath.row- addComSearch-1)*3+i;
                [artistDetailView setContentWithArtist:[self.artistList objectAtIndex:(indexPath.row- addComSearch-1)*3+i]];
                Artist *art = [self.artistList objectAtIndex:(indexPath.row- addComSearch-1)*3+i];
                if ([art.sub boolValue]) {
                    artistDetailView.orderBtn.hidden = YES;
                    artistDetailView.cancelBtn.hidden = NO;
                }else{
                    artistDetailView.orderBtn.hidden = NO;
                    artistDetailView.cancelBtn.hidden = YES;
                }
                artistDetailView.headImageView.size = CGSizeMake(83, 83);
                [artistDetailView.headImageView setImageWithURL:[NSURL URLWithString:art.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
                [cell.contentView addSubview:artistDetailView];
            }
        }else{
            for (int i = 0; i < surplus; i++) {
                ArtistDetailView *artistDetailView = [[[NSBundle mainBundle] loadNibNamed:@"ArtistDetailView" owner:self options:nil] lastObject];
                artistDetailView.frame = CGRectMake(12 + 330*i +5 * i, 5, 300, 120);
                artistDetailView.delegate = self;
                artistDetailView.tag = 200 + (indexPath.row - addComSearch-1)*3+i;
                [artistDetailView setContentWithArtist:[self.artistList objectAtIndex:(indexPath.row- addComSearch-1)*3+i]];
                Artist *art = [self.artistList objectAtIndex:(indexPath.row- addComSearch-1)*3+i];
                if ([art.sub boolValue]) {
                    artistDetailView.orderBtn.hidden = YES;
                    artistDetailView.cancelBtn.hidden = NO;
                }else{
                    artistDetailView.orderBtn.hidden = NO;
                    artistDetailView.cancelBtn.hidden = YES;
                }
                artistDetailView.headImageView.size = CGSizeMake(83, 83);
                [artistDetailView.headImageView setImageWithURL:[NSURL URLWithString:art.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
                [cell.contentView addSubview:artistDetailView];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
- (void)conditionViewDidSelectedOption:(ArtistComSearchView *)conditionView{
    [indicatorView setBackgroundColor:[UIColor yytBackgroundColor]];
//    [indicatorView startAnimating];
    [self showLoading];
    NSDictionary * dict = [conditionView.condition resultForSever];
    if (dict == NULL) {
        if (conditionView.tag == 1000) {
            [self.searchParams setObject:@"" forKey:@"area"];
        }else{
            [self.searchParams setObject:@"" forKey:@"singerType"];
        }
    }else{
        if ([dict objectForKey:@"area"] != nil) {
            [self.searchParams setObject:[dict objectForKey:@"area"] forKey:@"area"];
        }else{
            [self.searchParams setObject:[dict objectForKey:@"singerType"] forKey:@"singerType"];
        }
    }
    [self.searchParams setObject:@"12" forKey:@"size"];
    [artistDataController searchArtistByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
//        [indicatorView stopAnimating];
        [self hideLoading];
        self.artistList = artistArray;
        [self.artistTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
//        [indicatorView stopAnimating];
        [self hideLoading];
    }];
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

#pragma  mark - artistDetailView delegate

- (void)artistOrderClicked:(ArtistDetailView *)artistDetailView{
    NSLog(@"indexorder == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    Artist *artist = [self.artistList objectAtIndex:artistDetailView.tag - 200];
    [artistDataController createArtistWithArtistID:artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistDetailView.orderBtn.hidden = YES;
        artistDetailView.cancelBtn.hidden = NO;
        NSDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.artistList.count], @"size", nil];
        [artistDataController searchArtistByParams:dict success:^(MVAristDataController *dataController, NSArray *artistArray) {
            [indicatorView stopAnimating];
            self.artistList = artistArray;
            [self.artistTableView reloadData];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        if ([error.domain isEqualToString:@"您已经订阅了该艺人"]) {
            artistDetailView.orderBtn.hidden = YES;
            artistDetailView.cancelBtn.hidden = NO;
        }
        
    }];
}

- (void)artistCancelClicked:(ArtistDetailView *)artistDetailView{
    NSLog(@"indexcancel == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    Artist *artist = [self.artistList objectAtIndex:artistDetailView.tag - 200];
    [artistDataController deleteArtistWithArtistID:artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistDetailView.orderBtn.hidden = NO;
        artistDetailView.cancelBtn.hidden = YES;
        NSDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.artistList.count], @"size", nil];
        [artistDataController searchArtistByParams:dict success:^(MVAristDataController *dataController, NSArray *artistArray) {
            [indicatorView stopAnimating];
            self.artistList = artistArray;
            [self.artistTableView reloadData];
        } failure:^(MVAristDataController *dataController, NSError *error) {
            
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        if ([error.domain isEqualToString:@"您未订阅该艺人"]) {
            artistDetailView.orderBtn.hidden = NO;
            artistDetailView.cancelBtn.hidden = YES;
        }
    }];
}

- (void)artistDetailViewClicked:(ArtistDetailView *)artistDetailView{
    Artist *artist = [self.artistList objectAtIndex:artistDetailView.tag - 200];
    ArtistDetailViewController  *artistDetailVC = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetailVC animated:YES];
}

#pragma mark - ArtistOrderCell delegate
- (void)clickArtistView:(ArtistOrderView *)artistOrderView{
    NSInteger index= artistOrderView.tag;
    Artist *artist = [self.suggestArtistList objectAtIndex:index - 200];
    ArtistDetailViewController  *artistDetailVC = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetailVC animated:YES];
}

- (void)clickCancelArtist:(ArtistOrderView *)artistOrderView{
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    Artist *artist = [self.suggestArtistList objectAtIndex:artistOrderView.tag - 200];
    [artistDataController deleteArtistWithArtistID:artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistOrderView.orderBtn.hidden = NO;
        artistOrderView.cancelBtn.hidden = YES;
    } failure:^(MVAristDataController *dataController, NSError *error) {
        if ([error.domain isEqualToString:@"您已经订阅了该艺人"]) {
            artistOrderView.orderBtn.hidden = YES;
            artistOrderView.cancelBtn.hidden = NO;
        }
    }];
}

- (void)clickOrderArtist:(ArtistOrderView *)artistOrderView{
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    Artist *artist = [self.suggestArtistList objectAtIndex:artistOrderView.tag - 200];
    [artistDataController createArtistWithArtistID:artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistOrderView.orderBtn.hidden = YES;
        artistOrderView.cancelBtn.hidden = NO;
    } failure:^(MVAristDataController *dataController, NSError *error) {
        if ([error.domain isEqualToString:@"您已经订阅了该艺人"]) {
            artistOrderView.orderBtn.hidden = YES;
            artistOrderView.cancelBtn.hidden = NO;
        }
    }];
}

- (void)changeArtist{
    currentOffset += 6;
    NSString *current = [NSString stringWithFormat:@"%d",currentOffset + 6];
    self.changeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6", @"size", current, @"offset", nil];
    [artistDataController getSuggestArtistWithParams:self.changeParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
        if (artistArray.count < 6) {
            currentOffset = 0;
            [self.changeParams removeAllObjects];
            self.changeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6", @"size", nil];
            [artistDataController getSuggestArtistWithParams:self.changeParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
                self.suggestArtistList = artistArray;
                [self.artistTableView reloadData];
            } failure:^(MVAristDataController *dataController, NSError *error) {
                
            }];
            return ;
        }else{
            self.suggestArtistList = artistArray;
            [self.artistTableView reloadData];
        }
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

#pragma mark - view

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    currentOffset = 0;
    [self.changeParams removeAllObjects];
    self.changeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6", @"size", nil];
    [artistDataController getSuggestArtistWithParams:self.changeParams success:^(MVAristDataController *dataController, NSArray *artistArray) {
        self.suggestArtistList = artistArray;
        [self.artistTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

@end
