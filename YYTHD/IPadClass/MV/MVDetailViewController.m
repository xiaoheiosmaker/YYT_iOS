//
//  MVDetailViewController.m
//  YYTHD
//
//  Created by ssj on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVDetailViewController.h"
#import "MVDataController.h"
#import "MVItem.h"
#import "YYTVListCell.h"
#import "MVDiscussComment.h"
#import "MVDiscussItem.h"
#import "AlertWithComment.h"
#import "MVDiscussCell.h"
#import "UserDataController.h"
#import "YYTMoviePlayerViewController.h"
#import "DownloadManager.h"
#import "AddMVToMLAssistantController.h"
#import "MVDataController.h"
#import "YYTActivityIndicatorView.h"
#import "ShareAssistantController.h"
#import "ArtistDetailViewController.h"
#import "PopoverView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PullToRefreshView.h"
#import "OPSelectView.h"
#import "PopoverView.h"
#import "RootViewController.h"
#import "OperationResult.h"

@interface MVDetailViewController ()<PopoverViewDelegate>
{
//    YYTPlayerViewController *_playerViewController;
    YYTActivityIndicatorView *indicatorView;
    int topEdge;
    UIView *nullBackView;
}
@property (strong, nonatomic) UIView *userGuideView;
@property (assign, nonatomic) BOOL isPullUp;
@property (assign, nonatomic) BOOL isReply;
@property (strong, nonatomic) YYTMoviePlayerViewController *playerViewController;

@property (weak, nonatomic) PopoverView *downloadPopoverView;
@property (weak, nonatomic) PopoverView *selectPopoverView;

@end


@implementation MVDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithId:(NSString *)viewId{
    self = [super init];
    if (self) {
        // Custom initialization
        self.discussCommentArray = [[NSMutableArray alloc] initWithCapacity:0];
        mvChannelData = [[MVDataController alloc] init];
        
        YYTMoviePlayerViewController *playerViewConntroller = [[YYTMoviePlayerViewController alloc] initWithNibName:nil bundle:nil];
        self.playerViewController = playerViewConntroller;
        self.viewId = viewId;
    }
    return self;
}

- (id)initWithId:(NSString *)viewId playList:(NSArray *)playList{
    self = [self initWithId:viewId];
    self.playList = playList;
    [_playerViewController loadPlayList:playList startImmediately:NO];
    return self;
}

- (void)cleanLoadingView
{
    if (self.discussTableView.showsPullToRefresh) {
        [self.discussTableView.pullToRefreshView stopAnimating];
    }
    if (self.discussTableView.showsInfiniteScrolling) {
        [self.discussTableView.infiniteScrollingView stopAnimating];
    }
}

- (void)getDiscussComment {
    NSString *size = [NSString stringWithFormat:@"%d",MOREOFFSET];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.viewId,@"videoId",@"0",@"offset",size,@"size", nil];
    __weak MVDetailViewController * weakSelf = self;
    [mvChannelData getMVDiscussWithParams:params Success:^(MVDataController *dataController, MVDiscussItem *mvDiscuss) {
        weakSelf.mvDiscussItem = mvDiscuss;
        [weakSelf.discussCommentArray removeAllObjects];
        if (mvDiscuss.comments.count == 0) {
            weakSelf.discussCommentNull.hidden = NO;
            weakSelf.discussNullImage.hidden = NO;
        }else{
            weakSelf.discussCommentNull.hidden = YES;
            weakSelf.discussNullImage.hidden = YES;
        }
        [weakSelf.discussCommentArray addObjectsFromArray:mvDiscuss.comments];
        [weakSelf.discussTableView reloadData];
        [weakSelf cleanLoadingView];
    } failure:^(MVDataController *dataController, NSError *error) {
        NSLog(@"mvdiscuss - error:%@",error);
        [weakSelf cleanLoadingView];
    }];
}

- (void)getMoreDiscussComment {
    __weak MVDetailViewController * weakSelf = self;
    NSString *size = [NSString stringWithFormat:@"%d",MOREOFFSET+(int)self.discussCommentArray.count];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.viewId,@"videoId",@"0",@"offset",size,@"size", nil];
    [mvChannelData getMVDiscussWithParams:params Success:^(MVDataController *dataController, MVDiscussItem *mvDiscuss) {
        weakSelf.mvDiscussItem = mvDiscuss;
        [weakSelf.discussCommentArray removeAllObjects];
        [weakSelf.discussCommentArray addObjectsFromArray:mvDiscuss.comments];
        
        [weakSelf.discussTableView reloadData];
        [weakSelf cleanLoadingView];
    } failure:^(MVDataController *dataController, NSError *error) {
        [weakSelf cleanLoadingView];
        NSLog(@"mvdiscuss - error:%@",error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    topEdge = 0;
    self.topView.hidden = YES;
    self.isReply = NO;
    [self.topView isShowTextField:NO];
    if ([SystemSupport versionPriorTo7]) {
        topEdge = 0;
        self.descriptionLabel.alpha = 1;
    }
    else{
        topEdge = 20;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        [self.view addSubview:view];
        self.backBtn.centerY = self.navBackGround.centerY = self.titleImageView.centerY += (topEdge+2);
    }
    self.isPullUp = YES;
    
    self.emptyViewController.holderImage = IMAGE(@"网络断开");
    self.emptyViewController.holderText = NONETWORK;

    __weak id weakSself = self;
    [self.discussTableView addPullToRefreshWithActionHandler:^{
        [weakSself getDiscussComment];
    }];
    [self.discussTableView addInfiniteScrollingWithActionHandler:^{
        [weakSself getMoreDiscussComment];
    }];
    [self.discussTableView.pullToRefreshView setCustomView:[self setCustomViewForState:SVPullToRefreshStateStopped] forState:(SVPullToRefreshStateStopped)];
    [self.discussTableView.pullToRefreshView setCustomView:[self setCustomViewForState:SVPullToRefreshStateTriggered] forState:(SVPullToRefreshStateTriggered)];
    [self.discussTableView.pullToRefreshView setCustomView:[self setCustomViewForState:SVPullToRefreshStateLoading] forState:(SVPullToRefreshStateLoading)];

    UIImageView *playImageView = [[UIImageView alloc] initWithFrame:self.playView.bounds];
    UIImage *image = [UIImage imageNamed:@"Play_BackGround_View"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    playImageView.image = [image resizableImageWithCapInsets:edgeInsets];
    [self.playView addSubview:playImageView];
    self.discussCommentNull.textColor = [UIColor yytDarkGrayColor];
    
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    self.discussTableView.backgroundColor = [UIColor clearColor];
    self.discussTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.relateedTableView.backgroundColor = [UIColor clearColor];
    self.relateedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.relateedTableView.contentInset = UIEdgeInsetsMake(50+topEdge, 0, 104, 0);
    self.relateedTableView.scrollIndicatorInsets = self.relateedTableView.contentInset;
    
    image = [UIImage imageNamed:@"discuss_midImage"];
    edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.discussViewBackground.image = [image resizableImageWithCapInsets:edgeInsets];
    self.discussViewBackground.height = self.view.bounds.size.height - topEdge - 62 - 60 - 50;
    self.discussTableView.hidden = YES;
    self.discussViewBackground.hidden = YES;

    if (![SystemSupport versionPriorTo7]) {
        self.playView.centerY += topEdge;
        self.playCountIcon.centerY += topEdge;
        self.descriptionCountLabel.centerY += topEdge;
        self.viewNameLabel.centerY += topEdge;
        self.artistView.centerY += topEdge - 10;
        self.discussCountLabel.centerY += topEdge;
        self.discussCountIcon.centerY += topEdge;
        self.desLabel.centerY += topEdge ;
        self.shareBtn.centerY = self.collectBtn.centerY = self.addToML.centerY = self.downloadBtn.centerY += topEdge;
        self.descBackgroundView.centerY += topEdge;
        self.descriptionLabel.centerY += topEdge ;
        self.discussBtn.centerY += topEdge;
        self.pullUpBtn.centerY += topEdge;
        self.discussBackground.centerY += topEdge;
        self.discussView.centerY += topEdge;
    }
    
    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
    indicatorView.backgroundColor = [UIColor yytBackgroundColor];
    [indicatorView setTipText:@"正在加载MV详情,请稍候"];
//    [indicatorView startAnimating];
    nullBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 62+ topEdge, 1024, self.view.height- topEdge - 60 - 62)];
    nullBackView.backgroundColor = [UIColor yytBackgroundColor];
    [self.view addSubview:nullBackView];
    
    [self refreshWithId:self.viewId];
    
    BOOL isHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNewUserGuide"];
    UIView *userView = [[UIView alloc] initWithFrame:self.view.frame];
    userView.backgroundColor = [UIColor clearColor];
    self.userGuideView = userView;
    [self.view addSubview:_userGuideView];
    UIImageView *newUserImageView = [[UIImageView alloc] initWithFrame:userView.frame];
    newUserImageView.backgroundColor = [UIColor clearColor];
    newUserImageView.image = [UIImage imageNamed:@"NewUserGuide"];
    [_userGuideView addSubview:newUserImageView];
    _userGuideView.hidden = isHidden;
    UITapGestureRecognizer *handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_userGuideView addGestureRecognizer:handleTap];
}

- (void)handleTap{
    self.userGuideView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNewUserGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (UIView *)setCustomViewForState:(SVPullToRefreshState)state {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 30, 30)];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 25, 25)];
    backImageView.image = [UIImage imageNamed:@"MVDetail_PullRefresh_Back"];
    UIImageView *pullRefresh = [[UIImageView alloc] initWithFrame:CGRectMake(-3, 1, 15, 8)];
    pullRefresh.image = [UIImage imageNamed:@"MVDetail_PullRefresh"];
    [backImageView addSubview:pullRefresh];
    pullRefresh.center = backImageView.center;
    pullRefresh.centerX -= 1;
    [view addSubview:backImageView];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(3, 5, 5, 5);
    indicator.center = backImageView.center;

    indicator.centerX -= 1;
    indicator.centerY -= 1;
    [backImageView addSubview:indicator];
    [indicator startAnimating];
    
    if (state == SVInfiniteScrollingStateStopped) {
        [indicator stopAnimating];
        indicator.hidden = YES;
        pullRefresh.hidden = NO;
        return view;
    }else if (state == SVInfiniteScrollingStateTriggered){
        [indicator stopAnimating];
        indicator.hidden = YES;
        pullRefresh.hidden = NO;
        pullRefresh.transform = CGAffineTransformMakeRotation(M_PI);
        pullRefresh.centerY -= 3;
        return view;
    }else{
        indicator.hidden = NO;
        pullRefresh.hidden = YES;
        [indicator startAnimating];
        return view;
    }
    
}

- (CGFloat)getReletedTabelViewHeight{
    CGFloat height = 0;
    if (self.discussCommentArray.count <= 0) {
        return 500;
    }
    for (MVDiscussComment *mvComment in self.discussCommentArray) {
         MVDiscussCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MVDiscussCell" owner:self options:nil] lastObject];
        [cell setContentWithComment:mvComment];
        height += [cell getCellHeight];
    }
    if (height >= 768 - topEdge - 62 - 60) {
        return height >= 768 - topEdge - 62 - 60;
    }
    
    return height;
}

- (void)setupArtistView:(NSArray *)artists
{
    //clear prev btns
    [[self.artistView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //setup btns
    CGFloat centerX = 0;
    CGFloat centerY = CGRectGetMidY(self.artistView.bounds);
    
    NSInteger i = 0;
    for (Artist *art in artists) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:art.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yytGreenColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        
        CGPoint point = btn.center;
        point.y = centerY;
        point.x += centerX;
        btn.center = point;
        
        btn.tag = i++;
        [btn addTarget:self action:@selector(artistBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.artistView addSubview:btn];
        
        centerX = CGRectGetMaxX(btn.frame)+3;
    }
    
}

- (void)artistBtnClicked:(id)sender
{
    NSInteger index = [sender tag];
    Artist *art = [self.mvItem.artists objectAtIndex:index];
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:art.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

- (void)refreshWithId:(NSString *)keyId{
    self.relateedTableView.hidden = YES;
    self.viewId = keyId;
    
//    __weak YYTActivityIndicatorView *indiView =  indicatorView;
    __weak MVDetailViewController * weakSelf = self;
    [self showLoading];
    [mvChannelData getMVDetailWithID:weakSelf.viewId Success:^(MVDataController *dataController, MVItem *mvItem) {
        [self hideLoading];
//        [indiView stopAnimating];
        weakSelf.mvItem = mvItem;
        nullBackView.hidden = YES;
        [weakSelf.relateedTableView reloadData];
        weakSelf.viewNameLabel.text = weakSelf.mvItem.title;
        weakSelf.viewNameLabel.textColor = [UIColor yytDarkGrayColor];
        
//        _isMoviePlayStarted = NO;
        NSMutableArray * playList = [[NSMutableArray alloc]initWithObjects:weakSelf.mvItem, nil];
        [weakSelf.playerViewController loadPlayList:playList startImmediately:YES];
        [weakSelf checkEmpty:playList];
        UIView *playerView = weakSelf.playerViewController.view;
        playerView.frame = CGRectMake(10, 8, weakSelf.playView.bounds.size.width-20, weakSelf.playView.bounds.size.height-18) ;
        [weakSelf.playView addSubview:playerView];
        
        weakSelf.descriptionLabel.textColor = [UIColor colorWithHEXColor:0x555555];
        weakSelf.thumbnailPicView.frame = weakSelf.playView.frame;
        weakSelf.thumbnailPicView.hidden = YES;
        NSURL *coverURL = [weakSelf.mvItem coverImageURL];
        [weakSelf.thumbnailPicView setImageWithURL:coverURL placeholderImage:nil];
        weakSelf.descriptionLabel.editable = NO;
        weakSelf.descriptionLabel.text = weakSelf.mvItem.describ;
        weakSelf.desLabel.textColor = [UIColor yytGrayColor];
        weakSelf.discussCountIcon.image = IMAGE(@"miniCommentIcon");
        weakSelf.playCountIcon.image = IMAGE(@"miniPlayIcon");
        weakSelf.descriptionCountLabel.text = [NSString stringWithFormat:@"%@次播放",[weakSelf.mvItem.totalViews stringValue]];
        weakSelf.discussCountLabel.text = [NSString stringWithFormat:@"%@个评论",[weakSelf.mvItem.totalComments stringValue]];
        weakSelf.relateedTableView.hidden = NO;
        
        [weakSelf setupArtistView:weakSelf.mvItem.artists];
        
    } failure:^(MVDataController *dataController, NSError *error) {
        NSLog(@"mvdetail - error:%@",error);
        [self hideLoading];
        [weakSelf checkEmpty:weakSelf.mvItem];
    }];
    [self getDiscussComment];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_playerViewController stopPlaying];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - discuss 
- (void)showDiscussAlert{
    if ([UserDataController sharedInstance].isLogin) {
        self.currDisCuss = nil;
        AlertWithComment *alert = [[AlertWithComment alloc] initWithCommentText:nil];
        alert.delegate = self;
        [alert alertShow];
    }

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

- (IBAction)discussClick:(id)sender {
    [MobClick event:@"Mv_Comment" label:@"评论MV"];
    if ([UserDataController sharedInstance].isLogin){
        [self showDiscussAlert];
    }else{
        [self doLogin];
    }
}

- (IBAction)pullUpClick:(id)sender {
    
    [self.discussView removeFromSuperview];
    
    CATransition *transtion = [CATransition animation];
    transtion.duration = 1;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:kCATransitionMoveIn];
    [transtion setSubtype:kCATransitionFromTop];
    [transtion setDelegate:self];
    [self.discussView.layer addAnimation:transtion forKey:@"transtionKey"];
    self.discussBackground.hidden = YES;
    self.pullUpBtn.hidden = YES;
    self.discussBtn.hidden = YES;
    self.discussView.frame = CGRectMake(self.relateedTableView.frame.origin.x, self.relateedTableView.frame.origin.y + 60 + topEdge - 5, self.relateedTableView.frame.size.width, self.relateedTableView.frame.size.height-topEdge-60-62);
    [self.view addSubview:self.discussView];
    
}
- (IBAction)pullDownClick:(id)sender {
    
    if (self.isPullUp) {
        [MobClick event:@"Mv_Comment" label:@"展开MV评论"];
        self.discussTableView.hidden = NO;
        self.discussViewBackground.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            self.discussView.frame = CGRectMake(self.relateedTableView.frame.origin.x, self.relateedTableView.frame.origin.y + 60 + topEdge - 5, self.relateedTableView.frame.size.width, self.relateedTableView.frame.size.height-topEdge-60-62);
            [self.pullDownBtn setImage:IMAGE(@"MV_Detail_Pull_Down") forState:UIControlStateNormal];
            [self.pullDownBtn setImage:IMAGE(@"MV_Detail_Pull_Down_Sel") forState:UIControlStateHighlighted];
        } completion:^(BOOL finished) {
            
        }];
        
        self.isPullUp = NO;
    }else{
        
        [UIView animateWithDuration:0.35 animations:^{
             self.discussView.frame = CGRectMake(self.relateedTableView.frame.origin.x, self.view.bounds.size.height - 60-53, self.relateedTableView.frame.size.width, self.relateedTableView.frame.size.height-topEdge-60-62 - 60);
            [self.pullDownBtn setImage:IMAGE(@"MV_Detail_Pull_Up") forState:UIControlStateNormal];
            [self.pullDownBtn setImage:IMAGE(@"MV_Detail_Pull_Up_Sel") forState:UIControlStateHighlighted];
        } completion:^(BOOL finished) {
            self.discussTableView.hidden = YES;
            self.discussViewBackground.hidden = YES;
        }];
        self.isPullUp = YES;
    }

}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.discussTableView) {
        MVDiscussCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MVDiscussCell" owner:self options:nil] lastObject];
        MVDiscussComment *mvComment = [self.discussCommentArray objectAtIndex:indexPath.row];
        [cell setContentWithComment:mvComment];
        return [cell getCellHeight];
    }else{
        if (indexPath.row == 0) {
            return [MVItemView defaultSize].height+50;
        }else{
            return [MVItemView defaultSize].height+10;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"self.mvItem.relatedVideos.count === %d",self.mvItem.relatedVideos.count);
    if (tableView == self.discussTableView) {
        return self.mvDiscussItem.comments.count;
    }
    return self.mvItem.relatedVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.relateedTableView) {
        static NSString *cellID = @"cellID";
        YYTVListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[YYTVListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 150, 30)];
            label.text = @"相关MV";
            label.textColor = [UIColor yytGrayColor];
            label.font = [UIFont systemFontOfSize:15];
            [cell addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            cell.mvItemView.centerY += 38;
        }
        
        MVItem *mvItem = [self.mvItem.relatedVideos objectAtIndex:indexPath.row];
        cell.mvItemView.delegate = self;
        [cell.mvItemView setContentWithMVItem:mvItem];
        return cell;
    } else {
        static NSString *cellID = @"CELLID";
        MVDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MVDiscussCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        MVDiscussComment *mvComment = [self.discussCommentArray objectAtIndex:indexPath.row];
        [cell setContentWithComment:mvComment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - MVItemView Delegate

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView{
    
    [self.playerViewController stopPlaying];
    indicatorView.backgroundColor = [UIColor yytBackgroundColor];
    MVItem *item = mvItemView.mvItem;
    [self refreshWithId:[item.keyID stringValue]];
}

- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView
{
    MVItem *item = [self.mvItem.relatedVideos objectAtIndex:mvItemView.tag];
    [[AddMVToMLAssistantController sharedInstance] setMvToAdd:item];
}

- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist{
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}


#pragma mark - MVComment  MVShare delegte
- (void)publishButtonClicked:(AlertWithComment *)alert comment:(NSString *)comment
{
    __weak MVDetailViewController * weakSelf = self;
    NSString *value = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value isEqualToString:@""] || [comment isEqualToString:@"说点什么。。。。。。。"]) {
        [AlertWithTip flashFailedMessage:@"评论内容不能为空!" isKeyboard:NO];
        return;
    }
    if ([value isEqualToString:@""] || ([comment rangeOfString:@"回复:"].location != NSNotFound)) {
        [AlertWithTip flashFailedMessage:@"回复内容不能为空!" isKeyboard:NO];
        return;
    }
    NSDictionary *params;
    if (self.currDisCuss) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.viewId, @"videoId", self.currDisCuss.commentId, @"repliedId", comment, @"content", nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.viewId, @"videoId" ,comment, @"content", nil];
    }
    alert.hidden = YES;
    [alert.commentTextView resignFirstResponder];
    [indicatorView setTipText:@"正在发表评论,请稍候"];
//    [indicatorView startAnimating];
    [self showLoading];
    __weak YYTActivityIndicatorView *indiView =  indicatorView;
    [mvChannelData postMVCommentWithParams:params success:^(MVDataController *dataControllerl, NSDictionary * responseDict) {
        [indiView stopAnimating];
        [self hideLoading];
        if ([[responseDict objectForKey:@"isSuccess"] boolValue]) {
             NSLog(@"PUBLISH SUCCESS!!!!!!!!!!!");
            [alert alertDisMis];
            [weakSelf getDiscussComment];
            if (self.isReply) {
                [AlertWithTip flashSuccessMessage:@"回复成功"];
                self.isReply = NO;
            }else{
                [AlertWithTip flashSuccessMessage:@"评论成功"];
            }
            
            if (weakSelf.discussCommentArray.count>0) {
                [weakSelf.discussTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }

        }else{
            NSLog(@"PUBLISH FAILURE!!!!!!!!");
            NSLog(@"%@",[responseDict objectForKey:@"display_message"]);
            if ([[responseDict objectForKey:@"display_message"] rangeOfString:@"用户未通过邮箱验证"].location!=NSNotFound){
                [alert alertDisMis];
                YYTAlert *sendMailView = [[[NSBundle mainBundle] loadNibNamed:@"YYTAlert" owner:weakSelf options:nil] lastObject];
                sendMailView.delegate = weakSelf;
                [sendMailView viewShow];
            }else{
                alert.hidden = NO;
                [alert.commentTextView becomeFirstResponder];
                [AlertWithTip flashFailedMessage:[responseDict objectForKey:@"display_message"] isKeyboard:NO];
            }
        }
    } failure:^(MVDataController *dataController, NSError *error) {
        NSLog(@"MVComment error :%@",error);
        [self hideLoading];
        [indicatorView stopAnimating];
        alert.hidden = NO;
        [alert.commentTextView becomeFirstResponder];
        [AlertWithTip flashFailedMessage:@"评论失败" isKeyboard:NO];
        
        if (error.code == 20006) {
            [self doLogin];
            return ;
        }
    }];
    
}

- (void)closeAlert:(NSTimer*)timer {
    [(UIAlertView*) timer.userInfo  dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - YYTAlertDelegate
- (void)sendMail:(YYTAlert *)yytAlertView{
    UserDataController *userDataController = [UserDataController sharedInstance];
    [userDataController sendVerficationToEmail:yytAlertView.contentLabel.text withCompletion:^(OperationResult *result, NSError *err) {
        if (err) {
            [AlertWithTip flashFailedMessage:[err localizedDescription]];
            return;
        }
        
        if (result.success) {
            [AlertWithTip flashSuccessMessage:result.message];
        }
        else {
            [AlertWithTip flashFailedMessage:result.message];
        }
    }];
}

#pragma mark - mvDiscussCellDelegate
- (void)didReplyBtn:(MVDiscussCell *)cell{
    if ([UserDataController sharedInstance].isLogin) {
        [MobClick event:@"Mv_Comment" label:@"回复评论"];
        MVDiscussComment *mvComment = cell.mvDiscussComment;
        self.currDisCuss = mvComment;
        if ([UserDataController sharedInstance].isLogin) {
            AlertWithComment *alert = [[AlertWithComment alloc] initWithCommentText:nil];
            alert.delegate = self;
            [alert showPlaceholder:[NSString stringWithFormat:@"回复: %@",mvComment.userName]];
            self.isReply = YES;
            [alert alertShow];
        }
        
    }else{
        [self doLogin];
    }
}

#pragma mark - share add download collect
- (IBAction)collectBtnClicked:(id)sender
{
    if (self.mvItem == nil) {
        return;
    }
    if (![UserDataController sharedInstance].isLogin) {
        [MobClick event:@"Login_Event" label:@"MV详情-收藏"];
        [self doLogin];
        return;
    }
    [MobClick event:@"Collect_Mv" label:@"MV详情页"];
   
    [sender setEnabled:NO];
    [[MVDataController sharedDataController] addCollection:self.mvItem withCompletionHandler:^(NSString *message, NSError *error) {
        [sender setEnabled:YES];
        if (error) {
            if (message == nil) {
                message = [error yytErrorMessage];
            }
            [AlertWithTip flashFailedMessage:message];
        } else {
            [AlertWithTip flashSuccessMessage:@"收藏成功"];
        }
    }];
}

- (NSArray *)downloadPopoverViews
{
    MVItem *item = self.mvItem;
    if (item == nil) {
        return nil;
    }
    
    CGFloat btnWidth = 309;
    CGFloat btnHeight = 46;
    CGFloat space_x = 10;
    CGFloat space_y = 10;
    
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:3];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, btnWidth, 30)];
    label.text = @"请选择清晰度：";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    [views addObject:view];
    
    if ([item movieURLForQuality:YYTMovieQualityDefault]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, btnHeight+space_y*2)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(downloadQualityBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"标清" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(space_x, 0, btnWidth, btnHeight)];
        btn.tag = YYTMovieQualityDefault;
        [view addSubview:btn];
        
        [views addObject:view];
    }
    
    if ([item movieURLForQuality:YYTMovieQualityHD]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth+space_x*2, btnHeight+space_y*2)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"quality_btn_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(downloadQualityBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"高清" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(space_x, 0, btnWidth, btnHeight)];
        btn.tag = YYTMovieQualityHD;
        [view addSubview:btn];
        
        [views addObject:view];
    }
    
    return views;
}

- (IBAction)downloadBtnClicked:(id)sender
{
    if (self.downloadPopoverView) {
        return;
    }
    
    CGFloat x = CGRectGetMidX([sender frame]);
    CGFloat y = CGRectGetMinY([sender frame]);
    CGPoint point = [self.view convertPoint:CGPointMake(x, y) fromView:[sender superview]];
    NSArray *views = [self downloadPopoverViews];
    self.downloadPopoverView = [PopoverView showPopoverAtPoint:point inView:self.view withViewArray:views delegate:self];
}

- (void)downloadQualityBtnDidSelected:(UIButton *)sender
{
    [self.downloadPopoverView dismiss:YES];
    [MobClick event:@"Down_Mv" label:@"MV详情页"];
    MVItem *item = self.mvItem;
    if (item != nil) {
        [[DownloadManager sharedDownloadManager] downloadMVItem:item quality:[sender tag]];
    }
}

- (IBAction)shareBtnClicked:(id)sender
{
    if (self.mvItem == nil || self.selectPopoverView) {
        return;
    }

    [MobClick event:@"Share_Mv" label:@"MV详情页点击分享"];
    
    OPSelectView *select = [[OPSelectView alloc] initWithFrame:CGRectMake(0, 0, 329, 330)];
    select.controller = self;
    UIButton *button = sender;
    CGFloat x = CGRectGetMidX(button.frame);
    CGFloat y = CGRectGetMinY(button.frame);
    CGPoint point = [self.view convertPoint:CGPointMake(x, y) fromView:button.superview];
    PopoverView *popoverView = [PopoverView showPopoverAtPoint:point inView:self.view withContentView:select delegate:self];
    self.selectPopoverView = popoverView;
    return;
}

- (void)share:(id)sender to:(NSNumber *)opType
{
    [self.selectPopoverView dismiss:YES];
    [[ShareAssistantController sharedInstance] shareMVItem:self.mvItem toOpenPlatform:[opType intValue] inViewController:self completion:^(BOOL success, NSError *err) {
        if (!success)
        {
            
            [AlertWithTip flashFailedMessage:[err yytErrorMessage]];
            
        }
    }];
}

//加入悦单
- (IBAction)addToMLBtnClicked:(id)sender
{
    if (self.mvItem == nil) {
        return;
    }
    [self.playerViewController stopPlaying];
    [MobClick event:@"Add_list" label:@"MV详情-添加悦单"];
    [MobClick event:@"Login_Event" label:@"MV详情-添加悦单"];
    MVItem *item = self.mvItem;
    [[AddMVToMLAssistantController sharedInstance] setMvToAdd:item];
}

- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)triggerLoading:(EmptyViewController *)viewController{
    [self refreshWithId:self.viewId];
}


@end
