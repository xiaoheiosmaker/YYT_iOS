//
//  VViewController.m
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "VViewController.h"
#import "VListDataController.h"
#import "YYTVListCell.h"
#import "MVItemView.h"
#import "VListItem.h"
#import "YYTUIButton.h"
#import "MVItem.h"
#import "YYTCalendarView.h"
#import "MVDetailViewController.h"
#import "YYTMoviePlayerViewController.h"
#import "AddMVToMLAssistantController.h"
#import "UserDataController.h"
#import "AppDelegate.h"
#import "YYTActivityIndicatorView.h"
#import "ArtistDetailViewController.h"
#import "PullToRefreshView.h"
#import <MBProgressHUD/MBProgressHUD.h>


#define SELECTINDEX 200
@interface VViewController (){
    UIView *nullBackView;
    BOOL _autoPlay;
    NSRange spRange;
}

@property (nonatomic, strong)VListDataController *vListDataController;
@property (nonatomic, strong)VListItem *vListItem;
@property BOOL isHidden;
- (BOOL)autoPlay;

@end

@implementation VViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [playViewController stopPlaying];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vListDataController = [[VListDataController alloc] init];
        playViewController = [YYTMoviePlayerViewController moviePlayerViewController];
    }
    return self;
}

- (BOOL)autoPlay
{
    return _autoPlay;
}

- (id)initWithCodeDate:(NSString *)codeDate area:(NSString *)area{
    self = [super init];
    if (self) {
        self.curDateCode = [codeDate integerValue];
        if ([area isEqualToString:@"ML"]) {
            self.currentArea = @"内地篇";
            [self showSelectBtn:self.mlBtn];
        }else if ([area isEqualToString:@"HT"]){
            self.currentArea = @"港台篇";
            [self showSelectBtn:self.gtBtn];
        }else if ([area isEqualToString:@"US"]){
            self.currentArea = @"欧美篇";
            [self showSelectBtn:self.eaBtn];
        }else if ([area isEqualToString:@"KR"]){
             self.currentArea = @"韩国篇";
            [self showSelectBtn:self.koreaBtn];
        }else if ([area isEqualToString:@"JP"]){
             self.currentArea = @"日本篇";
            [self showSelectBtn:self.jsBtn];
        }
        [self getDataByDateCode:self.curDateCode];
    }
    return self;
}

-(void)addViews{
    self.desLabel.textColor = [UIColor colorWithHEXColor:0xa9a3a6];
    self.videoDescriptionView.editable = NO;
    self.mlBtn.selected = YES;
    self.mlBtn.frame = CGRectMake(self.mlBtn.frame.origin.x, self.mlBtn.frame.origin.y - topEdge, self.mlBtn.frame.size.width, self.mlBtn.frame.size.height);
    self.gtBtn.frame = CGRectMake(self.gtBtn.frame.origin.x, self.gtBtn.frame.origin.y - topEdge, self.gtBtn.frame.size.width, self.gtBtn.frame.size.height);
    self.koreaBtn.frame = CGRectMake(self.koreaBtn.frame.origin.x, self.koreaBtn.frame.origin.y - topEdge, self.koreaBtn.frame.size.width, self.koreaBtn.frame.size.height);
    self.jsBtn.frame = CGRectMake(self.jsBtn.frame.origin.x, self.jsBtn.frame.origin.y - topEdge, self.jsBtn.frame.size.width, self.jsBtn.frame.size.height);
    self.eaBtn.frame = CGRectMake(self.eaBtn.frame.origin.x, self.eaBtn.frame.origin.y - topEdge, self.eaBtn.frame.size.width, self.eaBtn.frame.size.height);
    self.spBtn.frame = CGRectMake(self.spBtn.frame.origin.x, self.spBtn.frame.origin.y - topEdge, self.spBtn.frame.size.width, self.spBtn.frame.size.height);
    self.tabImageView.frame = CGRectMake(self.tabImageView.frame.origin.x, self.tabImageView.frame.origin.y - topEdge, self.tabImageView.frame.size.width, self.tabImageView.frame.size.height);
    
    [self.mlBtn setImage:IMAGE(@"VList_MainLand_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.gtBtn setImage:IMAGE(@"VList_GT_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.eaBtn setImage:IMAGE(@"VList_EA_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.koreaBtn setImage:IMAGE(@"VList_Korea_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.jsBtn setImage:IMAGE(@"VList_JS_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.spBtn setImage:IMAGE(@"VList_SP_Sel") forState:UIControlStateSelected | UIControlStateHighlighted];
    self.videoDescriptionView.textColor = [UIColor yytDarkGrayColor];
    if ([SystemSupport versionPriorTo7]) {
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-[MVItemView defaultSize].width-15, 0 , [MVItemView defaultSize].width + 8, self.view.bounds.size.height) style:UITableViewStylePlain];
        listTableView.contentInset = UIEdgeInsetsMake(120+5, 0, 60, 0);
        listTableView.scrollIndicatorInsets = UIEdgeInsetsMake(125, 0, 60, 0);
        self.videoDescriptionView.alpha = 1;
    }else{
        self.playView.centerY += 20;
        self.dateCodeLabel.centerY = self.calendarBtn.centerY = self.nextBtn.centerY = self.prveBtn.centerY += 20;
        self.videoDescriptionView.centerY += 20;
        self.desLabel.centerY += 22;
        listTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-[MVItemView defaultSize].width-15, 0, [MVItemView defaultSize].width + 8, self.view.bounds.size.height) style:UITableViewStylePlain];
            listTableView.contentInset = UIEdgeInsetsMake(120+20+5, 0, 60, 0);
        listTableView.scrollIndicatorInsets = UIEdgeInsetsMake(145, 0, 60, 0);
    }

    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.backgroundColor = [UIColor colorWithHEXColor:0xf0f0f0];
    [self.view addSubview:listTableView];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [listTableView setHidden:YES];
    [self.view sendSubviewToBack:listTableView];
    self.topView.titleImageView.image = IMAGE(@"Music_VList");
    self.topView.titleImageView.frame = CGRectMake(self.topView.titleImageView.frame.origin.x, self.topView.titleImageView.frame.origin.y+10, 150/2, 40/2);
    self.topView.titleImageView.center = CGPointMake(self.topView.frame.size.width/2, self.topView.frame.size.height/2);
    
    self.dateCodeLabel.textColor = [UIColor yytGreenColor];
    
    self.view.backgroundColor = [UIColor yytBackgroundColor];
}

- (void)refresh{
    [self sendWithAreaName:@"内地篇"];
    self.currentArea = @"内地篇";
    [self showSelectBtn:self.mlBtn];
    calendar.hidden = YES;
    self.calendarBtn.selected = NO;
}

- (void)sendWithAreaName:(NSString*)areaName{
//    [indicatorView startAnimating];
    [self showLoading];
    __weak VViewController *weakSelf = self;
    
    if ([self.currentArea isEqualToString:@"特别企划"]) {
        
        [_vListDataController getSpecialVideoByRange:spRange success:^(VListDataController *vListDataController, NSArray *specialList) {
            [weakSelf hideLoading];
            [indicatorView stopAnimating];
            [weakSelf.playlistArray removeAllObjects];
            weakSelf.playlistArray = [NSMutableArray arrayWithArray:specialList];
//            NSLog(@"+++++++%d",weakSelf.playlistArray.count);
            [listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [listTableView reloadData];
            [weakSelf checkEmpty:weakSelf.vListItem.videos];
            if (weakSelf.vListItem.videos.count == 0) {
                [weakSelf checkEmpty:weakSelf.vListItem.videos];
                return ;
            }
            [playViewController loadPlayList:weakSelf.playlistArray startImmediately:weakSelf.autoPlay];
            MVItem *item = [weakSelf.playlistArray objectAtIndex:0];
            weakSelf.videoDescriptionView.text = item.describ;
        } failure:^(VListDataController *vListDataController, NSError *error) {
            
        }];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:areaName,@"area", nil];
    [_vListDataController getSelectVListParams:dict success:^(VListDataController *vListController,VListItem *vItem) {
        nullBackView.hidden = YES;
        if (vItem == NULL) {
            return ;
        }
        [weakSelf hideLoading];
//        [indicatorView stopAnimating];
        weakSelf.vListItem = vItem;
        weakSelf.curDateCode = [vItem.dateCode integerValue];
        [weakSelf.playlistArray removeAllObjects];
        weakSelf.playlistArray = [NSMutableArray arrayWithArray:vItem.videos];
        [weakSelf checkEmpty:weakSelf.vListItem.videos];
        if (weakSelf.vListItem.videos.count == 0) {
            [weakSelf checkEmpty:weakSelf.vListItem.videos];
            return ;
        }
        if (vItem.program == NULL) {
            
        }else{
            [weakSelf.playlistArray insertObject:vItem.program atIndex:0];
        }
        weakSelf.dateCodeLabel.text = [NSString stringWithFormat:@"%@年第%@期  (%@-%@)",vItem.year,vItem.no,vItem.beginDateText,vItem.endDateText];
        [listTableView reloadData];
        [listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [listTableView setHidden:NO];
        _isMoviePlayStarted = NO;
        
        if ([weakSelf.vListItem.nextDateCode integerValue] == 0) {
            weakSelf.nextBtn.enabled = NO;
        }else{
            weakSelf.nextBtn.enabled = YES;
        }
        [playViewController loadPlayList:weakSelf.playlistArray startImmediately:weakSelf.autoPlay];
        MVItem *item = [weakSelf.playlistArray objectAtIndex:0];
        weakSelf.videoDescriptionView.text = item.describ;
    } failure:^(VListDataController *vListController, NSError *error) {
        [indicatorView stopAnimating];
        [weakSelf hideLoading];
        NSArray *array = [NSArray arrayWithArray:nil];
        [weakSelf checkEmpty:array];
    }];
}

- (void)showSelectBtn:(UIButton *)btn{
    if (btn == self.mlBtn) {
        self.mlBtn.selected = YES;
        self.koreaBtn.selected = NO;
        self.eaBtn.selected = NO;
        self.jsBtn.selected = NO;
        self.gtBtn.selected = NO;
        self.spBtn.selected = NO;
        self.currentArea = @"内地篇";
        [MobClick event:@"About_Vchart" label:@"V榜语种切换"];
    }else if(btn == self.gtBtn){
        self.mlBtn.selected = NO;
        self.koreaBtn.selected = NO;
        self.eaBtn.selected = NO;
        self.jsBtn.selected = NO;
        self.spBtn.selected = NO;
        self.gtBtn.selected = YES;
        self.currentArea = @"港台篇";
        [MobClick event:@"About_Vchart" label:@"V榜语种切换"];
    }else if(btn == self.eaBtn){
        self.mlBtn.selected = NO;
        self.koreaBtn.selected = NO;
        self.eaBtn.selected = YES;
        self.jsBtn.selected = NO;
        self.gtBtn.selected = NO;
        self.spBtn.selected = NO;
        self.currentArea = @"欧美篇";
        [MobClick event:@"About_Vchart" label:@"V榜语种切换"];
    }else if(btn == self.koreaBtn){
        self.mlBtn.selected = NO;
        self.koreaBtn.selected = YES;
        self.eaBtn.selected = NO;
        self.jsBtn.selected = NO;
        self.gtBtn.selected = NO;
        self.spBtn.selected = NO;
        self.currentArea = @"韩国篇";
        [MobClick event:@"About_Vchart" label:@"V榜语种切换"];
    }else if(btn == self.jsBtn){
        self.mlBtn.selected = NO;
        self.koreaBtn.selected = NO;
        self.eaBtn.selected = NO;
        self.jsBtn.selected = YES;
        self.gtBtn.selected = NO;
        self.spBtn.selected = NO;
        self.currentArea = @"日本篇";
        [MobClick event:@"About_Vchart" label:@"V榜语种切换"];
    }else if(btn == self.spBtn){
        self.mlBtn.selected = NO;
        self.koreaBtn.selected = NO;
        self.eaBtn.selected = NO;
        self.jsBtn.selected = NO;
        self.gtBtn.selected = NO;
        self.spBtn.selected = YES;
        self.currentArea = @"特别企划";
        [MobClick event:@"About_Vchart" label:@"特别企划"];
    }
    
    if (btn == self.spBtn) {
        self.isHidden = YES;
    }else{
        self.isHidden = NO;
    }
    [self setButtonHidden];
}

- (void)setButtonHidden{
    self.nextBtn.hidden = self.prveBtn.hidden = self.calendarBtn.hidden = self.dateCodeLabel.hidden = self.isHidden;
    listTableView.infiniteScrollingView.hidden = !self.isHidden;
    
    [self cleanLoadingView];
}

- (IBAction)mlBtnClicked:(id)sender {
    [playViewController stopPlaying];
    UIButton *btn = (YYTUIButton *)sender;
    [self showSelectBtn:btn];
    NSRange range = {0,20};
    spRange = range;
    [self sendWithAreaName:self.currentArea];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetTopView:YES];
    
    self.emptyViewController.holderImage = IMAGE(@"网络断开");
    self.emptyViewController.holderText = VLISTNONETWORK;
    
    // Do any additional setup after loading the view from its nib.
    topEdge = 0;
    NSRange range = {0,20};
    spRange = range;
    if ([SystemSupport versionPriorTo7]) {
        topEdge = 20;
        nullBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 62 + 60, 1024, self.view.height - 60 - 62 - 60)];
    }else{
        topEdge = 0;
        self.desBackgroundView.centerY += 20;
        nullBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 62 + 62 +  20, 1024, self.view.height- 20 - 60 - 62 - 60)];
    }
    
    UIView *playerView = playViewController.view;
    playerView.frame = CGRectMake(10, 8, self.playView.bounds.size.width-20, self.playView.bounds.size.height-18) ;
    UIImageView *playImageView = [[UIImageView alloc] initWithFrame:self.playView.bounds];
    UIImage *image = [UIImage imageNamed:@"Play_BackGround_View"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    playImageView.image = [image resizableImageWithCapInsets:edgeInsets];
    [self.playView addSubview:playImageView];
    [self.playView addSubview:playerView];
    self.playlistArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self addViews];
    //[self sendWithAreaName:@"内地篇"];
    self.currentArea = @"内地篇";
    
    UIImageView *desImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.videoDescriptionView.origin.x, self.videoDescriptionView.origin.y - 15, self.videoDescriptionView.width, self.videoDescriptionView.height + 16)];
    desImageView.image = [image resizableImageWithCapInsets:edgeInsets];
    [self.view addSubview:desImageView];
    [self.view sendSubviewToBack:desImageView];
    
    indicatorView = [[[NSBundle mainBundle] loadNibNamed:@"YYTActivityIndicatorView" owner:self options:nil] lastObject];
    indicatorView.delegate = self;
    indicatorView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
    [self.view addSubview:indicatorView];
    indicatorView.supportTip = YES;
    indicatorView.supportCancel = NO;
    [indicatorView setTipText:@"正在加载V榜列表，请稍候"];
    
//    v榜日历
    calendar =  [[[NSBundle mainBundle] loadNibNamed:@"YYTCalendarView" owner:self options:nil] lastObject];
    calendar.delegate = self;
    calendar.frame = CGRectMake(180, kTopBarHeight + 46 - topEdge, 700, 458);
    [self.view addSubview:calendar];
    calendar.hidden = YES;
    
    nullBackView.backgroundColor = [UIColor yytBackgroundColor];
    [self.view addSubview:nullBackView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidStarted:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:playViewController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:playViewController.moviePlayer];
    
    __weak id weakSself = self;
    [listTableView addInfiniteScrollingWithActionHandler:^{
        [weakSself getMoreSpecialList];
    }];
    [listTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    _autoPlay = YES;
    self.isHidden = NO;
    [self sendWithAreaName:@"内地篇"];
    self.currentArea = @"内地篇";
    [self showSelectBtn:self.mlBtn];
    [self setButtonHidden];
    
}

- (void)getMoreSpecialList{
    if (self.playlistArray.count < spRange.length) {
        listTableView.infiniteScrollingView.hidden = YES;
        return;
    }else{
        listTableView.infiniteScrollingView.hidden = NO;
    }
    if (!self.isHidden) {
        return;
    }
    NSRange range = {0,self.playlistArray.count + 20};
    spRange = range;
    __weak VViewController *weakSelf = self;
    [_vListDataController getSpecialVideoByRange:spRange success:^(VListDataController *vListDataController, NSArray *specialList) {
        [weakSelf hideLoading];
        [indicatorView stopAnimating];
        NSLog(@"---------%d",specialList.count);
        [weakSelf.playlistArray removeAllObjects];
        weakSelf.playlistArray = [NSMutableArray arrayWithArray:specialList];
        [listTableView reloadData];
        [weakSelf checkEmpty:weakSelf.vListItem.videos];
        if (weakSelf.vListItem.videos.count == 0) {
            [weakSelf checkEmpty:weakSelf.vListItem.videos];
            return ;
        }
        [weakSelf cleanLoadingView];
    } failure:^(VListDataController *vListDataController, NSError *error) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _autoPlay = YES;
//    [self sendWithAreaName:@"内地篇"];
//    self.currentArea = @"内地篇";
//    [self showSelectBtn:self.mlBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [playViewController stopPlaying];
    _isMoviePlayStarted = NO;
    calendar.hidden = YES;
    self.calendarBtn.selected = NO;
    _autoPlay = NO;
}

//日历点击
- (IBAction)calendarClicked:(id)sender {
//    [playViewController stopPlaying];
    [MobClick event:@"About_Vchart" label:@"日历查询（V榜期数）"];
    if (self.calendarBtn.selected) {
        calendar.hidden = YES;
        self.calendarBtn.selected = NO;
    }else{
        self.calendarBtn.selected = YES;
        VListDataController *vc = [[VListDataController alloc] init];
        [vc getAllVListDateWithArea:self.currentArea success:^(VListDataController *vListController,NSMutableArray *array) {
            [calendar setContentWithMVItems:array currentDateCode:self.curDateCode];
            
        } failure:^(VListDataController *vListController, NSError *error) {
        }];
        calendar.hidden = NO;
}
    
}
- (IBAction)prevDateBtnClicked:(id)sender {
    [MobClick event:@"About_Vchart" label:@"上一期（V榜期数）"];
    [playViewController stopPlaying];
    currentPlayIndex = 0;
    _isMoviePlayStarted = NO;
    NSString *dateCodeStr = self.vListItem.prevDateCode;
    self.curDateCode = [self.vListItem.prevDateCode integerValue];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.currentArea, @"area", dateCodeStr, @"datecode", nil];
    [self getgetSelectVListParams:params];
}

- (void)cleanLoadingView
{
    if (listTableView.showsInfiniteScrolling) {
        [listTableView.infiniteScrollingView stopAnimating];
    }
}

- (void)getgetSelectVListParams:(NSDictionary *)params{
    VListDataController *vc = [[VListDataController alloc] init];
    [self showLoading];
    [vc getSelectVListParams:params success:^(VListDataController *vListController, VListItem *vItem) {
        [self hideLoading];
        self.vListItem = vItem;
        [self.playlistArray removeAllObjects];
        if (vItem.videos == NULL) {
            return ;
        }
        if ([self.vListItem.nextDateCode integerValue] == 0) {
            self.nextBtn.enabled = NO;
        }else{
            self.nextBtn.enabled = YES;
        }
        self.playlistArray = [NSMutableArray arrayWithArray:vItem.videos];
        if (vItem.program == NULL) {
            
        }else{
            [self.playlistArray insertObject:vItem.program atIndex:0];
        }
        self.dateCodeLabel.text = [NSString stringWithFormat:@"%@年第%@期  (%@-%@)",vItem.year,vItem.no,vItem.beginDateText,vItem.endDateText];
        [listTableView reloadData];
        [listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        _isMoviePlayStarted = NO;
        MVItem *item = [self.playlistArray objectAtIndex:0];
        self.videoDescriptionView.text = item.describ;
        [playViewController loadPlayList:self.playlistArray startImmediately:self.autoPlay];
        [calendar show:YES];
        [self checkEmpty:self.vListItem.videos];
    } failure:^(VListDataController *vListController, NSError *error) {
        [self hideLoading];
//        [AlertWithTip flashFailedMessage:error.domain];
        NSArray *array = [NSArray arrayWithArray:nil];
        [self checkEmpty:array];
    }];
}

- (IBAction)nextDateBtnClicked:(id)sender {
    [MobClick event:@"About_Vchart" label:@"下一期（V榜期数）"];
    [playViewController stopPlaying];
    currentPlayIndex = 0;
    _isMoviePlayStarted = NO;
    self.curDateCode = [self.vListItem.nextDateCode integerValue];
    NSString *dateCodeStr = self.vListItem.nextDateCode;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.currentArea, @"area", dateCodeStr, @"datecode", nil];
    [self getgetSelectVListParams:params];
}

- (void)getDataByDateCode:(NSInteger)dateCode{
    [playViewController stopPlaying];
    self.calendarBtn.selected = NO;
    NSString *dateCodeStr = [NSString stringWithFormat:@"%d",dateCode];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.currentArea, @"area", dateCodeStr, @"datecode", nil];
    [self getgetSelectVListParams:params];
}

#pragma mark - Calendar delegate
- (void)calendarDate:(NSInteger)dateCode{
    [self getDataByDateCode:dateCode];
}

- (void)calendarClose{
    self.calendarBtn.selected = NO;
}

#pragma mark - tebleView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    if (self.vListItem.program == NULL) {
//        return self.vListItem.videos.count;
//    }
//    return self.vListItem.videos.count+1;
    return self.playlistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 208;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellID = @"cellID";
    YYTVListCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[YYTVListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.mvItemView.tag = SELECTINDEX + indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *rankStr;
    if (self.vListItem.program != NULL) {
        if (indexPath.row < 10) {
            rankStr = [NSString stringWithFormat:@"0%d",indexPath.row];
        }else{
            rankStr = [NSString stringWithFormat:@"%d",indexPath.row];
        }
    }else{
        if (indexPath.row < 10) {
            rankStr = [NSString stringWithFormat:@"0%d",indexPath.row+1];
        }else{
            rankStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
        }
        if (indexPath.row + 1 == 10) {
            rankStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
        }
    }

    if (self.vListItem.program != NULL) {
        MVItem *programItem = self.vListItem.program;
        [self.vListItem.videos insertObject:programItem atIndex:0];
        switch (indexPath.row) {
            case 0:
                cell.mvItemView.rankingLabel.hidden = YES;
                cell.mvItemView.imageView.hidden = YES;
                break;
                
            case 1:
                cell.mvItemView.imageView.image = IMAGE(@"VListFirst");
                break;
            case 2:
                cell.mvItemView.imageView.image = IMAGE(@"VListSecond");
                break;
            case 3:
                cell.mvItemView.imageView.image = IMAGE(@"VListThird");
                break;
            default:
                cell.mvItemView.imageView.image = IMAGE(@"VListOther");
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                cell.mvItemView.imageView.image = IMAGE(@"VListFirst");
                break;
            case 1:
                cell.mvItemView.imageView.image = IMAGE(@"VListSecond");
                break;
            case 2:
                cell.mvItemView.imageView.image = IMAGE(@"VListThird");
                break;
                
            default:
                cell.mvItemView.imageView.image = IMAGE(@"VListOther");
                break;
        }
    }
    cell.mvItemView.rankingLabel.text = rankStr;
    if (currentPlayIndex == indexPath.row) {
        cell.mvItemView.playingView.hidden = NO;
    }else{
        cell.mvItemView.playingView.hidden = YES;
    }
    MVItem *mvItem = [self.playlistArray objectAtIndex:indexPath.row];
    cell.mvItemView.delegate = self;
    cell.mvItemView.imageView.hidden = self.isHidden;
    [cell.mvItemView setContentWithMVItem:mvItem];
    return cell;

}

#pragma mark - MVItemView Delegate

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView
{
    [playViewController stopPlaying];
    _isMoviePlayStarted = YES;
    MVItem *mvItem = mvItemView.mvItem;
    self.videoDescriptionView.text = mvItem.describ;
    mvItemView.playingView.hidden = NO;
    [playViewController playMVItemAtIndex:mvItemView.tag-200];
    [listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mvItemView.tag-200 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView{
    if ([UserDataController sharedInstance].isLogin) {
        [AddMVToMLAssistantController sharedInstance].mvToAdd = mvItemView.mvItem;
    }else{
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
    
}

- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist{
    ArtistDetailViewController *artistDetail = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil artistID:artist.keyID];
    [self.navigationController pushViewController:artistDetail animated:YES];
}

#pragma mark - YYTPlayer Delegate

- (void)videoDidStarted:(id)sender
{
    NSInteger index = [playViewController currentIndex];
    MVItem *mvItem = [self.playlistArray objectAtIndex:index];
    self.videoDescriptionView.text = mvItem.describ;
    [listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self setShow:index];
}

- (void)videoDidFinished:(id)sender
{
    NSInteger index = [playViewController currentIndex];
    [self setHidden:index];
}

- (void)setShow:(NSInteger)index{
    if (isFirstClick) {
        currentPlayIndex = index;
    }else{
        [self setHidden:currentPlayIndex];
        currentPlayIndex = index;
    }
    if (index >= 0 && index < self.playlistArray.count) {
        YYTVListCell *cell = (YYTVListCell*)[listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.mvItemView.playingView.hidden = NO;
    }

}

- (void)setHidden:(NSInteger)index{
    if (index >= 0 && index < self.playlistArray.count) {
        YYTVListCell *cell = (YYTVListCell*)[listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.mvItemView.playingView.hidden = YES;
    }
    
}

- (void)triggerLoading:(EmptyViewController *)viewController
{
    [self sendWithAreaName:self.currentArea];
}


@end
