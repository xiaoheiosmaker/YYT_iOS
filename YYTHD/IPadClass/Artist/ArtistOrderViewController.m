//
//  ArtistOrderViewController.m
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistOrderViewController.h"
#import "MVAristDataController.h"
#import "Artist.h"
#import "ArtistScrollerCell.h"
#import "UserDataController.h"
#import "ArtistMVCell.h"
#import "MVItemView.h"
#import "MVItem.h"
#import "MVDetailViewController.h"
#import "ArtistDetailViewController.h"
#import "ArtistSearchOrderViewController.h"
#import "MyOrderArtist.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PullToRefreshView.h"

@interface ArtistOrderViewController (){
    YYTActivityIndicatorView *indicatorView;
}
- (void)doFresh;
@end

@implementation ArtistOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self resetTopView:YES];
        ShareApp.unReadCount = @"0";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadCount" object:nil];
        _artistList = [[NSArray alloc] init];
        _videoList = [[NSArray alloc] init];
        self.artistTableView.hidden = YES;
        mvArtistDataController = [[MVAristDataController alloc] init];
        
        [self doFresh];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    __weak id weakSelf = self;
//    [self resetTopView:YES];
    self.artistTableView.hidden = YES;
    [self.topView isShowSideButton:YES];
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    CGRect btnFrame = CGRectMake(1024 - 80, (kTopBarHeight - 45) / 2, 80, 50);
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:IMAGE(@"Artist_Add_Order") forState:UIControlStateNormal];
    [addBtn setImage:IMAGE(@"Artist_Add_Order_Sel") forState:UIControlStateHighlighted];
    addBtn.frame = btnFrame;
    [addBtn addTarget:self action:@selector(addArtist:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addBtn];
    [self.artistTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreVideos];
    }];
    if ([SystemSupport versionPriorTo7]) {
        self.artistTableView.contentInset = UIEdgeInsetsMake(62, 0, 60, 0);
    }else{
        self.artistTableView.contentInset = UIEdgeInsetsMake(62+20, 0, 60, 0);
    }
    self.artistTableView.scrollIndicatorInsets = self.artistTableView.contentInset;
    self.topView.titleImageView.image = IMAGE(@"My_Artist_Order");
    self.topView.titleImageView.frame = CGRectMake(self.topView.titleImageView.frame.origin.x, self.topView.titleImageView.frame.origin.y+10, 253/2, 40/2);
    self.topView.titleImageView.center = CGPointMake(self.topView.frame.size.width/2, self.topView.frame.size.height/2);
    [self.topView isShowTimeButton:NO];
    [self.topView isShowTextField:NO];
    [self.topView isShowSideButton:YES];
    self.topView.unReadCountLabel.hidden = YES;
    self.topView.unReadImageView.hidden = YES;
    self.artistTableView.backgroundColor = [UIColor yytBackgroundColor];
    self.artistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
    [indicatorView setTipText:@"正在加载艺人列表,请稍候"];
//    [indicatorView startAnimating];
    
    [self.artistTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
}

- (void)addArtist:(id)sender{
    ArtistSearchOrderViewController *artOrderVC = [[ArtistSearchOrderViewController alloc] initWithNibName:@"ArtistSearchOrderViewController" bundle:nil];
    [self.navigationController pushViewController:artOrderVC animated:YES];
}

- (void)getMoreVideos{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.videoList.count + 24], @"size", nil];
    [mvArtistDataController getArtistOrderMessage:params success:^(MVAristDataController *dataController, MyOrderArtist *orderArtist) {
        _videoList = [NSArray arrayWithArray:orderArtist.data];
        [self.artistTableView reloadData];
        self.artistTableView.hidden = NO;
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
#pragma mark - artistScrollerCell delegate

- (void)artistViewClicked:(NSInteger)index{
    NSLog(@"index == %d",index);
    Artist *artist = [self.artistList objectAtIndex:index - 200];
    ArtistDetailViewController * artistDetailViewController = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
    
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.videoList.count % 4 == 0) {
        return self.videoList.count/4+1;
    }else{
        return self.videoList.count/4+2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170;
    }else{
        return [MVItemView defaultSize].height+10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellID = @"cellID";
        ArtistScrollerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArtistScrollerCell" owner:self options:nil] lastObject];
        }
        [cell resetScrollView:self.artistList];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        static NSString *cellName = @"CELLID";
        ArtistMVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArtistMVCell" owner:self options:nil] lastObject];
        }
        
        for (UIView *aView in cell.contentView.subviews) {
            if ([aView isKindOfClass:[MVItemView class]]) {
                [aView removeFromSuperview];
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        int indexRow = self.videoList.count / 4;
        int surplus = self.videoList.count % 4;
        if (self.videoList.count == 0) {
            return cell;
        }
        if (indexRow == 0) {
            for (int i = 0; i < surplus; i++) {
                MVItemView *mvItemView = [[MVItemView alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + i;
                mvItemView.backgroundColor = [UIColor clearColor];
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:i]];
                [cell.contentView addSubview:mvItemView];
            }

        }else if (indexPath.row-1 < indexRow && indexRow != 0){
            for (int i = 0; i < 4; i++) {
                MVItemView *mvItemView = [[MVItemView alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row-1)*4+i;
//                mvItemView.backgroundColor = [UIColor clearColor];
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1)*4+i]];
                [cell.contentView addSubview:mvItemView];
            }
        }else{
            for (int i = 0; i < surplus; i++) {
                MVItemView *mvItemView = [[MVItemView alloc] initWithFrame:CGRectMake(5+250*i+i*5, 5, 250, 198)];
                mvItemView.delegate = self;
                mvItemView.tag = 200 + (indexPath.row-1)*4+i;
//                mvItemView.backgroundColor = [UIColor clearColor];
                [mvItemView setContentWithMVItem:[self.videoList objectAtIndex:(indexPath.row-1)*4+i]];
                [cell.contentView addSubview:mvItemView];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - MVItemView delegate

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView{
    NSLog(@"mvItemView.tag == %d",mvItemView.tag);
    MVItem *mvItem = (MVItem *)[self.videoList objectAtIndex:mvItemView.tag-200];
    MVDetailViewController *mvDetailViewController = [[MVDetailViewController alloc] initWithId:[mvItem.keyID stringValue]];
    [self.navigationController pushViewController:mvDetailViewController animated:YES];
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

- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView{
    if ([UserDataController sharedInstance].isLogin) {
        [AddMVToMLAssistantController sharedInstance].mvToAdd = mvItemView.mvItem;
    }else{
        [self doLogin];
    }
}
- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist{
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

- (void)MVItemVIewDidClickedArtist:(MVItemView *)mvItemView{
    
}

- (void)viewWillAppear:(BOOL)animated{
//    [self doFresh];
    [mvArtistDataController getArtistSubscribeMeSuccess:^(MVAristDataController *dataController, NSArray *artistArray) {
        //        [indicatorView stopAnimating];
        [self hideLoading];
        _artistList = [NSArray arrayWithArray:artistArray];
        [self checkEmpty:self.artistList];
        self.emptyViewController.holderImage = IMAGE(@"无订阅艺人");
        self.emptyViewController.holderText = NOORDERARTIST;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.artistTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        [self checkEmpty:self.artistList];
        self.emptyViewController.holderImage = IMAGE(@"网络断开");
        self.emptyViewController.holderText = NONETWORK;
        [self hideLoading];
    }];
}

- (void)doFresh
{
    [self showLoading];
    [mvArtistDataController getArtistSubscribeMeSuccess:^(MVAristDataController *dataController, NSArray *artistArray) {
//        [indicatorView stopAnimating];
        [self hideLoading];
        _artistList = [NSArray arrayWithArray:artistArray];
        [self checkEmpty:self.artistList];
        self.emptyViewController.holderImage = IMAGE(@"无订阅艺人");
        self.emptyViewController.holderText = NOORDERARTIST;
        [self.artistTableView reloadData];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        NSLog(@"mvartist - error :%@",error);
        
        [self checkEmpty:self.artistList];
        self.emptyViewController.holderImage = IMAGE(@"网络断开");
        self.emptyViewController.holderText = NONETWORK;
        [self hideLoading];
    }];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"24",@"size", nil];
    [mvArtistDataController getArtistOrderMessage:params success:^(MVAristDataController *dataController, MyOrderArtist *orderArtist) {
        [indicatorView stopAnimating];
        _videoList = [NSArray arrayWithArray:orderArtist.data];
        [self.artistTableView reloadData];
        self.artistTableView.hidden = NO;
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self doFresh];
}


@end
