//
//  SearchViewController.m
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "SearchViewController.h"
#import "ArtistMVCell.h"
#import "MVDetailViewController.h"
#import "MVItem.h"
#import "MVSearchCondition.h"
#import "SearchHistory.h"
#import "UserDataController.h"
#import "ArtistDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PullToRefreshView.h"
#import "MVItemViewForSearch.h"
@interface SearchViewController (){
    YYTActivityIndicatorView *indicatorView;
}
@property (assign,nonatomic)BOOL isAnimating;
@property (assign,nonatomic)BOOL isNoNet;
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyWord:(NSString *)keyWord
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.keyword = keyWord;
        self.videoList = [[NSArray alloc] init];
        self.searchParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        searchDataController = [[SearchDataController alloc] init];
        artistDataController = [[MVAristDataController alloc] init];
        searchHistoryDataController = [[SearchHistoryDataController alloc] init];
        [self searchByKeyword];
    }
    return self;
}

- (void)searchByKeyword{
    [self.searchParams setObject:self.keyword forKey:@"keyword"];
    [self.searchParams setObject:@"12" forKey:@"size"];
//    [indicatorView startAnimating];
    [self showLoading];
    NSString *videoType = [self.searchParams objectForKey:@"videoType"];
    [searchDataController searchVideoByParam:self.searchParams success:^(SearchDataController *dataController, NSArray *videoArray) {
        [self checkEmpty:videoArray];
        self.isNoNet = NO;
//        [indicatorView stopAnimating];
        [self hideLoading];
        self.videoList = videoArray;
        [self.dataTableView reloadData];
    } failure:^(SearchDataController *dataController, NSError *error) {
        [indicatorView stopAnimating];
        [self hideLoading];
        self.isNoNet = YES;
        [self checkEmpty:self.videoList];
    }];
    [self.searchParams removeObjectForKey:@"videoType"];
    [searchDataController searchArtistByParam:self.searchParams success:^(SearchDataController *dataController, NSArray *artistArray) {
        [indicatorView stopAnimating];
        if (artistArray.count > 0) {
            self.artist = [artistArray objectAtIndex:0];
        }else{
            self.artist = NULL;
        }
        [self.dataTableView reloadData];
    } failure:^(SearchDataController *dataController, NSError *error) {
        [indicatorView stopAnimating];
//        [self checkEmpty:self.videoList];
    }];
    if (videoType != nil) {
        [self.searchParams setObject:videoType forKey:@"videoType"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bOn = YES;
    self.isNoNet = NO;
    self.isAnimating = NO;
    self.cleanTextBtn.hidden = YES;
    self.searchByHotBtn.selected = YES;
    self.view.backgroundColor = [UIColor yytBackgroundColor];

    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
//    [indicatorView setTipText:@"正在加载搜索结果,请稍候"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        [self.view addSubview:view];
        topHight = 20;
        self.dataTableView.contentInset = UIEdgeInsetsMake(56, 0, 60, 0);
    }else{
        self.dataTableView.contentInset = UIEdgeInsetsMake(56+topHight, 0, 60, 0);
        topHight = 0;
    }
    self.dataTableView.scrollIndicatorInsets =  self.dataTableView.contentInset;
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topHight + 62, self.view.width, self.view.height)];
    view.backgroundColor = [UIColor clearColor];
    self.textBackgroungView = view;
    self.textBackgroungView.hidden = YES;
    [self.view addSubview:self.textBackgroungView];
    // Do any additional setup after loading the view from its nib.
    __weak id weakSelf = self;
    [self.dataTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreVideos];
    }];
    self.backView.centerY = self.backBtn.centerY = self.searchByHotBtn.centerY = self.searchByNewBtn.centerY = self.comSearch.centerY = self.searchBackVIew.centerY = self.searchIcon.centerY = self.searchTextFiled.centerY = self.cleanTextBtn.centerY = self.backView.centerY+topHight;
    
    [self.searchTextFiled addTarget:self action:@selector(searchInputFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.searchTextFiled addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    NSLog(@"keyword = %@",self.keyword);
    NSString *newPlaceHolder = self.keyword;
    if (self.keyword.length > 7) {
        NSRange range = {0,7};
        newPlaceHolder = [self.keyword substringWithRange:range];
        newPlaceHolder = [NSString stringWithFormat:@"%@...",newPlaceHolder];
    }
    self.searchTextFiled.placeholder = newPlaceHolder;
//    self.searchByNewBtn.selected = YES;
    [self.searchByNewBtn setImage:IMAGE(@"sortByNew_s") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.searchByHotBtn setImage:IMAGE(@"sortByHot_s") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.comSearch setImage:IMAGE(@"Artist_Combination_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    
    self.preSearchViewController = [[PreSearchViewController alloc] initWithNibName:@"PreSearchViewController" bundle:nil];
    self.preSearchViewController.delegate = self;
    [self.view addSubview:self.preSearchViewController.backImageView];
    self.preSearchViewController.backImageView.frame = CGRectMake(413, topHight+28, 192, 220+33);
    self.preSearchViewController.backImageView.hidden = YES;
    [self.view addSubview:self.preSearchViewController.searchTableView];
    self.preSearchViewController.searchTableView.frame = CGRectMake(415, topHight + 60 - 5, 188, 218);
    [self addSearchComView];
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加空白时的页面显示
    self.emptyViewController = [[EmptyViewController alloc] initWithNibName:@"EmptyViewController" bundle:nil];
    self.emptyViewController.delegate = self;
    [self.emptyViewController view];//调用viewDidLoad进行初始化
    [self.view addSubview:self.emptyViewController.view];
    self.emptyViewController.view.hidden = YES;//先隐藏
    
    //设置emptyViewController的视图位置
    CGRect rect = self.emptyViewController.view.frame;
    rect.origin.y = self.backView.frame.origin.y + self.backView.frame.size.height;
    self.emptyViewController.view.frame = rect;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissTableView) name:UIKeyboardWillHideNotification object:nil];
    
     [self.dataTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
}

- (void)dismissTableView{
    self.preSearchViewController.backImageView.hidden = YES;
    self.preSearchViewController.searchTableView.hidden = YES;
    self.textBackgroungView.hidden = YES;
    self.cleanTextBtn.hidden = YES;
    [self.searchTextFiled resignFirstResponder];
}

- (void)addSearchComView{
    // 添加组合查询条件
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, topHight + 59, CGRectGetWidth(self.view.frame), 180)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:searchView.bounds];
    UIImage *image = [UIImage imageNamed:@"navi_bg"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    imageView.image = [image resizableImageWithCapInsets:edgeInsets];
    [searchView addSubview:imageView];
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
    videoTypeView =  [[ArtistComSearchView alloc] initWithFrame:CGRectMake(0, 120, 1024, 60) condition:[MVSearchCondition videoTypeCondition]];
    videoTypeView.actionDelegate = self;
    videoTypeView.tag = 3000;
    videoTypeView.title = @"视频类别";
    [_searchView addSubview: areaView];
    [_searchView addSubview:singerTypeView];
    [_searchView addSubview:videoTypeView];
    [self.view addSubview:_searchView];
    [self.view sendSubviewToBack:_searchView];
    [_searchView setHidden:YES];
    [self.view sendSubviewToBack:self.dataTableView];
}

- (void)getMoreVideos{
    NSString *size= [NSString stringWithFormat:@"%d",self.videoList.count + 12];
    [self.searchParams setObject:size forKey:@"size"];
    
    [searchDataController searchVideoByParam:self.searchParams success:^(SearchDataController *dataController, NSArray *videoArray) {
        self.videoList = videoArray;
        [self.dataTableView reloadData];
        [self cleanLoadingView];
    } failure:^(SearchDataController *dataController, NSError *error) {
        
    }];
        
}

- (void)cleanLoadingView
{
    if (self.dataTableView.showsInfiniteScrolling) {
        [self.dataTableView.infiniteScrollingView stopAnimating];
    }
}
- (IBAction)cleanTextBtnClicked:(id)sender {
    self.searchTextFiled.text = @"";
    self.cleanTextBtn.hidden = YES;
    if (self.searchTextFiled.text.length == 0) {
        self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
        for (NSString *str in self.preSearchViewController.dataArray) {
            NSLog(@"%@",str);
        }
        [self.preSearchViewController.searchTableView reloadData];
        return;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField 

- (void)setSearchBackgroundImage:(NSString *)image{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [transtion setType:kCATransitionFade];
    [transtion setSubtype:kCATransitionFromTop];
    [self.searchBackVIew  setImage:[UIImage imageNamed:image]];
    [self.searchBackVIew.layer addAnimation:transtion forKey:@"animationKey"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [MobClick endEvent:@"TopBar_Select" label:@"搜索栏"];
    
    self.searchTextFiled.placeholder = @"你要找什么?";
    [self.view bringSubviewToFront:self.textBackgroungView];
    [self.view bringSubviewToFront:self.searchTextFiled];
    [self.view bringSubviewToFront:self.preSearchViewController.backImageView];
    [self.view bringSubviewToFront:self.preSearchViewController.searchTableView];
    
    [self setSearchBackgroundImage:@"Search_Sel_Background"];
    if(self.searchTextFiled.text.length == 0){
        self.searchSuggestList = [searchHistoryDataController getHistoryArray];
        self.preSearchViewController.dataArray = self.searchSuggestList;
        [MobClick endEvent:@"TopBar_Select" label:@"播放历史"];
        [self.preSearchViewController.searchTableView reloadData];
    }
    self.preSearchViewController.backImageView.hidden = NO;
    self.preSearchViewController.searchTableView.hidden = NO;
    self.textBackgroungView.hidden = NO;
    if (self.searchTextFiled.text.length > 0) {
        self.cleanTextBtn.hidden = NO;
    }else{
        self.cleanTextBtn.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.searchBackVIew.image = IMAGE(@"Search_Back_White");
    [self.searchTextFiled resignFirstResponder];
}

- (void)searchInputFinished:(id)sender{
    [searchHistoryDataController addToHistory:self.searchTextFiled.text];
    NSString *value = [self.searchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    NSLog(@"value====%@",value);
    if ([value isEqualToString:@""]) {
        [AlertWithTip flashFailedMessage:@"搜索内容不能为空!"];
        return;
    }
    [self.searchTextFiled resignFirstResponder];
    self.preSearchViewController.backImageView.hidden = YES;
    [self.preSearchViewController.searchTableView setHidden:YES];
    self.keyword = value;
//    self.searchTextFiled.text = value;
    [self searchByKeyword];
}

- (void)editingChanged:(id)sender{
    self.cleanTextBtn.hidden = NO;
    self.preSearchViewController.backImageView.hidden = NO;
    [self.preSearchViewController.searchTableView setHidden:NO];
    UITextField *searchInput = (UITextField *)sender;
    UITextRange *selectedRange = [searchInput markedTextRange];
    if(selectedRange.start == nil  && selectedRange.end == nil)
    {
        self.isHistory = NO;
        if (searchInput.text.length == 0) {
            self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
            for (NSString *str in self.preSearchViewController.dataArray) {
                NSLog(@"%@",str);
            }
            self.cleanTextBtn.hidden = YES;
            [self.preSearchViewController.searchTableView reloadData];
            return;
        }
        [searchDataController searchSuggestByKeyWord:searchInput.text success:^(SearchDataController *dataController, NSArray *suggestArray) {
            self.searchSuggestList = suggestArray;
            self.preSearchViewController.dataArray = suggestArray;
            self.preSearchViewController.backImageView.hidden = NO;
            self.preSearchViewController.searchTableView.hidden = NO;
            [self.preSearchViewController.searchTableView reloadData];
        } failure:^(SearchDataController *dataController, NSError *error) {
            
        }];
    }
    if(searchInput.text.length == 0){
        self.searchSuggestList = [searchHistoryDataController getHistoryArray];
        [self.preSearchViewController.searchTableView reloadData];
    }
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    [self checkEmpty:self.videoList];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.videoList.count + 1;
    if (self.artist!=NULL) {
        if (self.videoList.count % 4 == 0) {
            return self.videoList.count/4+1;
        }else{
            return self.videoList.count/4+2;
        }
    }else{
        if (self.videoList.count % 4 == 0) {
            return self.videoList.count/4;
        }else{
            return self.videoList.count/4+1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.artist!=NULL) {
        if (indexPath.row == 0) {
            return [ArtistDetailView defaultSize].height + 10;
        }else{
            return [MVItemView defaultSize].height +10;
        }
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
    if (self.artist != NULL) {
        if (indexPath.row == 0) {
            ArtistDetailView *artistDetail = [[[NSBundle mainBundle] loadNibNamed:@"ArtistDetailView" owner:self options:nil] lastObject];
            artistDetail.frame = CGRectMake(5, 8, 330, 120);
            artistDetail.delegate = self;
            artistDetail.tag = 200;
            UIImage *image = [UIImage imageNamed:@"ArtistOrder_BackGroundView"];
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            cell.backgroundView.image = [image resizableImageWithCapInsets:edgeInsets];
            [artistDetail setContentWithArtist:self.artist];
            artistDetail.backgroundImageView.hidden = YES;
            if ([self.artist.sub boolValue]) {
                artistDetail.orderBtn.hidden = YES;
                artistDetail.cancelBtn.hidden = NO;
            }else{
                artistDetail.orderBtn.hidden = NO;
                artistDetail.cancelBtn.hidden = YES;
            }
            [cell.contentView addSubview:artistDetail];
        }else{
            int indexRow = self.videoList.count / 4;
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
                
            }else if (indexPath.row - addComSearch-1 < indexRow && indexRow != 0){
                for (int i = 0; i < 4; i++) {
                    MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                    mvItemView.delegate = self;
                    mvItemView.tag = 200 + (indexPath.row- addComSearch-1)*4+i;
                    [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1- addComSearch)*4+i]];
                    [cell.contentView addSubview:mvItemView];
                }
            }else{
                for (int i = 0; i < surplus; i++) {
                    MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                    mvItemView.delegate = self;
                    mvItemView.tag = 200 + (indexPath.row- addComSearch-1)*4+i;
                    [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1- addComSearch)*4+i]];
                    [cell.contentView addSubview:mvItemView];
                }
            }
            
        }
    }else{
        int indexRow = self.videoList.count / 4;
        int surplus = self.videoList.count % 4;
        if (self.videoList.count == 0) {
            return cell;
        }
        if (indexPath.row < indexRow && indexRow != 0){
            for (int i = 0; i < 4; i++) {
                MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row- addComSearch)*4+i;
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row- addComSearch)*4+i]];
                [cell.contentView addSubview:mvItemView];
            }
        }else{
            for (int i = 0; i < surplus; i++) {
                MVItemViewForSearch *mvItemView = [[MVItemViewForSearch alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row- addComSearch)*4+i;
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row- addComSearch)*4+i]];
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
    NSLog(@"indexorder == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    [artistDataController createArtistWithArtistID:self.artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistDetailView.orderBtn.hidden = YES;
        artistDetailView.cancelBtn.hidden = NO;
        [searchDataController searchArtistByParam:self.searchParams success:^(SearchDataController *dataController, NSArray *artistArray) {
            [indicatorView stopAnimating];
            if (artistArray.count > 0) {
                self.artist = [artistArray objectAtIndex:0];
            }else{
                self.artist = NULL;
            }
            [self.dataTableView reloadData];
        } failure:^(SearchDataController *dataController, NSError *error) {
            [indicatorView stopAnimating];
            //        [self checkEmpty:self.videoList];
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

- (void)artistDetailViewClicked:(ArtistDetailView *)artistDetailView{
    ArtistDetailViewController *artistDetailVC = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:self.artist.keyID];
    [self.navigationController pushViewController:artistDetailVC animated:YES];
}

- (void)artistCancelClicked:(ArtistDetailView *)artistDetailView{
    NSLog(@"indexcancel == %d",artistDetailView.tag);
    if (![UserDataController sharedInstance].isLogin) {
        [self doLogin];
        return;
    }
    [artistDataController deleteArtistWithArtistID:self.artist.keyID success:^(MVAristDataController *dataController, NSDictionary *responseDict) {
        artistDetailView.orderBtn.hidden = NO;
        artistDetailView.cancelBtn.hidden = YES;
        [searchDataController searchArtistByParam:self.searchParams success:^(SearchDataController *dataController, NSArray *artistArray) {
            [indicatorView stopAnimating];
            if (artistArray.count > 0) {
                self.artist = [artistArray objectAtIndex:0];
            }else{
                self.artist = NULL;
            }
            [self.dataTableView reloadData];
        } failure:^(SearchDataController *dataController, NSError *error) {
            [indicatorView stopAnimating];
            //        [self checkEmpty:self.videoList];
        }];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}
#pragma preSearchViewConrtoller delegate

- (void)searchText:(NSString *)searchText{
    self.searchBackVIew.image = IMAGE(@"Search_Back_White");
    [searchHistoryDataController addToHistory:searchText];
//    if (!self.comSearch.selected) {
//        [self addSearchComView];
//    }
    [self.searchTextFiled resignFirstResponder];
    self.preSearchViewController.backImageView.hidden = YES;
    [self.preSearchViewController.searchTableView setHidden:YES];
    self.keyword = searchText;
    self.searchTextFiled.text = searchText;
    [self searchByKeyword];
}


#pragma  mark - navBtn

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchBtnClicked:(id)sender {
    [self dismissTableView];
    [MobClick event:@"Sort_switching" label:@"组合查询"];
    if (!self.isAnimating) {
        self.bOn = !self.bOn;
        [self animeToolView:_searchView hidden:self.bOn];
    }
}
- (IBAction)newSortBtnClicked:(id)sender {
    [self dismissTableView];
    [MobClick event:@"Sort_switching" label:@"最新发布"];
    
    [self showLoading];
    self.searchByNewBtn.selected = YES;
    self.searchByHotBtn.selected = NO;
    [self.searchParams setObject:@"VideoPubDate" forKey:@"order"];
    [artistDataController searchByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *videoArray) {
        [self hideLoading];
        self.videoList = videoArray;
        [self.dataTableView reloadData];
        [self cleanLoadingView];
        if (videoArray.count>0) {
            [self.dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
       [self hideLoading];
    }];
}
- (IBAction)hotSortBtnClicked:(id)sender {
    [self dismissTableView];
    
    [MobClick event:@"Sort_switching" label:@"最热播放"];
    [self showLoading];
    self.searchByNewBtn.selected = NO;
    self.searchByHotBtn.selected = YES;
    [self.searchParams setObject:@"TotalViews" forKey:@"order"];
    [artistDataController searchByParams:self.searchParams success:^(MVAristDataController *dataController, NSArray *videoArray) {
        [self hideLoading];
        self.videoList = videoArray;
        [self.dataTableView reloadData];
        [self cleanLoadingView];
        if (videoArray.count>0) {
             [self.dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
       
        
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];

}

- (void)conditionViewDidSelectedOption:(ArtistComSearchView *)conditionView{
    [indicatorView setTipText:@"正在加载搜索结果,请稍候"];
//    [indicatorView startAnimating];
    NSDictionary * dict = [conditionView.condition resultForSever];
    if (dict == NULL) {
        if (conditionView.tag == 1000) {
            [self.searchParams setObject:@"" forKey:@"area"];
        }else if (conditionView.tag == 2000){
            [self.searchParams setObject:@"" forKey:@"singerType"];
        }else{
            [self.searchParams setObject:@"" forKey:@"videoType"];
        }
    }else{
        if ([dict objectForKey:@"area"] != nil) {
            [self.searchParams setObject:[dict objectForKey:@"area"] forKey:@"area"];
        }else if ([dict objectForKey:@"singerType"] != nil){
            [self.searchParams setObject:[dict objectForKey:@"singerType"] forKey:@"singerType"];
        }else{
            [self.searchParams setObject:[dict objectForKey:@"videoType"] forKey:@"videoType"];
        }
    }
    [self.searchParams setObject:@"12" forKey:@"size"];
    [self.searchParams setObject:self.keyword forKey:@"keyword"];
    [self searchByKeyword];
}

- (void)animeToolView:(UIView *)toolView hidden:(BOOL)hidden
{
    self.isAnimating = YES;
    CGRect frame = toolView.frame;
    CGRect startFrame = frame;
    CGRect targetFrame = frame;
    [self.view bringSubviewToFront:toolView];
    UIEdgeInsets inset;
    if (!hidden) {
        startFrame.size.height = 0;
        inset = UIEdgeInsetsMake(60+topHight + 180, 0, 60, 0);
    } else {
        targetFrame.size.height = 0;
        inset = UIEdgeInsetsMake(60+topHight, 0, 60, 0);
    }
    
    toolView.frame = startFrame;
    toolView.hidden = NO;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         toolView.frame = targetFrame;
                         self.dataTableView.contentInset = inset;
                          self.dataTableView.scrollIndicatorInsets =  self.dataTableView.contentInset;
                         if (self.videoList.count>0) {
                             [self.dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                         }
                     }
                     completion:^(BOOL finished) {
                         toolView.frame = frame;
                         toolView.hidden = hidden;
                         self.isAnimating = NO;
                     }];
}

- (void)comSearchArtist{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setSearchBackgroundImage:@"Search_Back_White"];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isKindOfClass:[UITextField class]] || touch.view == self.textBackgroungView ) {
        self.preSearchViewController.backImageView.hidden = YES;
        self.preSearchViewController.searchTableView.hidden = YES;
        [self.searchTextFiled resignFirstResponder];
        self.textBackgroungView.hidden = YES;
    }
    if (touch.view == self.cleanTextBtn) {
        self.searchTextFiled.text = @"";
        self.cleanTextBtn.hidden = YES;
        if (self.searchTextFiled.text.length == 0) {
            self.preSearchViewController.dataArray = [searchHistoryDataController getHistoryArray];
            [self.preSearchViewController.searchTableView reloadData];
            return;
        }
    }
    self.preSearchViewController.backImageView.hidden = YES;
    self.preSearchViewController.searchTableView.hidden = YES;
}

- (void)checkEmpty:(id)data
{
    if(data == nil || [data isKindOfClass:[NSArray class]])
    {
        if([data count] == 0 && self.isNoNet == NO)
        {
            self.emptyViewController.hidden = NO;
            [self.emptyViewController bringToFront];
            [self.emptyViewController doneLoading];
            self.emptyViewController.holderImage = IMAGE(@"搜索失败");//子类确定
            self.emptyViewController.holderText = NOSEAECHRESULT(self.keyword);
            if (!_searchView.hidden) {
                [self.view bringSubviewToFront:_searchView];
            }
        }else if([data count] == 0 && self.isNoNet == YES){
            self.emptyViewController.hidden = NO;
            [self.emptyViewController bringToFront];
            [self.emptyViewController doneLoading];
            self.emptyViewController.holderImage = IMAGE(@"网络断开");
            self.emptyViewController.holderText = NONETWORK;
        }else
        {
            self.emptyViewController.hidden = YES;
            [self.emptyViewController doneLoading];
        }
    }
    
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self searchByKeyword];
}

@end
