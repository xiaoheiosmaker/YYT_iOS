//
//  NoticeViewController.m
//  YYTHD
//
//  Created by ssj on 14-3-7.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeDataController.h"
#import "NoticeItem.h"
#import "NoticeCell.h"
#import "NoticeDiscussCell.h"
#import "MVDiscussItem.h"
#import "AlertWithComment.h"
#import "MVDiscussComment.h"
#import "YYTActivityIndicatorView.h"
#import "MVDataController.h"
#import "PullToRefreshView.h"
@interface NoticeViewController (){
    YYTActivityIndicatorView *indicatorView;
    MVDataController *mvChannelData;
    NSRange announceRange;
    NSRange systemRange;
    NSRange discussRange;
}
@property (nonatomic, strong) NSMutableArray *announceList;
@property (nonatomic, strong) NSMutableArray *discussList;
@property (nonatomic, strong) NSMutableArray *systemList;
@end
@implementation NoticeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor yytBackgroundColor];
    
    mvChannelData = [[MVDataController alloc] init];
    self.noDiscuss.hidden = YES;
    self.noAnnounce.hidden = YES;
    self.noDiscuss.hidden = YES;
    self.nullDiscuss.hidden = YES;
    self.nullAnnounce.hidden = YES;
    self.nullSystem.hidden = YES;
    self.announceList = [[NSMutableArray alloc] initWithCapacity:0];
    self.discussList = [[NSMutableArray alloc] initWithCapacity:0];
    self.systemList = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    UIImage *image = [UIImage imageNamed:@"notice_line_zhu"];
    self.anncouceLine.image = [image resizableImageWithCapInsets:edgeInsets];
    self.anncouceLine.backgroundColor = [UIColor redColor];
    self.systemLine.image = [image resizableImageWithCapInsets:edgeInsets];
    self.discussLine.image = [image resizableImageWithCapInsets:edgeInsets];
    self.topView.titleImageView.image = [UIImage imageNamed:@"notice_title"];
    self.topView.titleImageView.frame = CGRectMake(self.topView.titleImageView.frame.origin.x, self.topView.titleImageView.frame.origin.y+5, 93, 33);
    UIImage *backImage = [UIImage imageNamed:@"notice_background"];
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.announceBackground.image = [backImage resizableImageWithCapInsets:edgeInset];
    self.systemBackground.image = [backImage resizableImageWithCapInsets:edgeInset];
    self.discussBackground.image = [backImage resizableImageWithCapInsets:edgeInset];
    
    __weak id weakSself = self;
    [self.announceTableView addInfiniteScrollingWithActionHandler:^{
        [weakSself getMoreAnnounceList];
    }];
    [self.announceTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewWaiteForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
    [self.systemTableView addInfiniteScrollingWithActionHandler:^{
        [weakSself getMoreSystemList];
    }];
    [self.systemTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewWaiteForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
    [self.discussTableView addInfiniteScrollingWithActionHandler:^{
        [weakSself getMoreDiscussList];
    }];
    [self.discussTableView.infiniteScrollingView setCustomView:[PullToRefreshView setCustomViewWaiteForState:SVPullToRefreshStateLoading] forState:SVPullToRefreshStateLoading];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.announceView.centerY = self.systemView.centerY = self.discussView.centerY -= 20;
    }
    
    
    
    [self readData];
}

- (void)cleanLoadingViewWithTableView:(UITableView *)tableView
{
    if (tableView.showsInfiniteScrolling) {
        [tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)setNoDataHidden{
    if (self.announceList.count == 0) {
        self.noAnnounce.hidden = self.nullAnnounce.hidden = NO;
        self.announceTableView.hidden = YES;
    }else{
        self.announceTableView.hidden = NO;
        self.noAnnounce.hidden = self.nullAnnounce.hidden = YES;
    }
    if (self.systemList.count == 0) {
        self.systemTableView.hidden = YES;
        self.noSystem.hidden = self.nullSystem.hidden = NO;
    }else{
        self.systemTableView.hidden = NO;
        self.noSystem.hidden = self.nullSystem.hidden = YES;
    }
    if (self.discussList.count == 0) {
        self.discussTableView.hidden = YES;
        self.noDiscuss.hidden = self.nullDiscuss.hidden = NO;
    }else{
        self.discussTableView.hidden = NO;
        self.noDiscuss.hidden = self.nullDiscuss.hidden = YES;
    }
    
}

- (void)getMoreDiscussList{
    NSRange range = {0,self.discussList.count + 20};
    __weak NoticeViewController *weakSelf = self;
    if (self.discussList.count < discussRange.length) {
        self.discussTableView.infiniteScrollingView.hidden = YES;
        return;
    }else{
        self.discussTableView.infiniteScrollingView.hidden = NO;
    }
    if (self.discussTableView.infiniteScrollingView.hidden) {
        return;
    }
    discussRange = range;
    [[NoticeDataController sharedInstance] getNoticeCommentListByRange:range success:^(NoticeDataController *dataController, MVDiscussItem *discussItem) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.discussTableView];
        [weakSelf.discussList removeAllObjects];
        [weakSelf.discussList addObjectsFromArray:discussItem.comments];
        [weakSelf.discussTableView reloadData];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.discussTableView];
    }];
}

- (void)getMoreSystemList{
    __weak NoticeViewController *weakSelf = self;
    NSRange range = {0,self.systemList.count + 20};
    if (self.systemList.count < systemRange.length) {
        self.systemTableView.infiniteScrollingView.hidden = YES;
        return;
    }else{
        self.systemTableView.infiniteScrollingView.hidden = NO;
    }
    if (self.systemTableView.infiniteScrollingView.hidden) {
        return;
    }
    systemRange = range;
    [[NoticeDataController sharedInstance] getNoticeSystemListByRange:range success:^(NoticeDataController *dataController, NSArray *systemList) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.systemTableView];
        [weakSelf.systemList removeAllObjects];
        [weakSelf.systemList addObjectsFromArray:systemList];
        [weakSelf.systemTableView reloadData];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.systemTableView];
    }];
}

- (void)getMoreAnnounceList{
    NSRange range = {0,self.announceList.count + 20};
    __weak NoticeViewController *weakSelf = self;
    if (self.announceList.count < announceRange.length) {
        self.announceTableView.infiniteScrollingView.hidden = YES;
        return;
    }else{
        self.announceTableView.infiniteScrollingView.hidden = NO;
    }
    if (self.announceTableView.infiniteScrollingView.hidden) {
        return;
    }
    announceRange = range;
    [[NoticeDataController sharedInstance] getNoticeAnnouncementListByRange:range success:^(NoticeDataController *dataController, NSArray *announcementList) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.announceTableView];
        [weakSelf.announceList removeAllObjects];
        [weakSelf.announceList addObjectsFromArray:announcementList];
        [weakSelf.announceTableView reloadData];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        [weakSelf cleanLoadingViewWithTableView:weakSelf.announceTableView];
        
    }];
}

- (void)showUnReadImage{
    if ([NoticeDataController sharedInstance].countArray.count > 0 && [[[NoticeDataController sharedInstance].countArray objectAtIndex:2] integerValue]>0){
        self.announcePopImage.hidden = NO;
        self.announceLable.hidden = NO;
        self.announceLable.text = [NSString stringWithFormat:@"%@",[[NoticeDataController sharedInstance].countArray objectAtIndex:2]];
    }else{
        self.announcePopImage.hidden = YES;
        self.announceLable.hidden = YES;
    }
    
    if ([NoticeDataController sharedInstance].countArray.count > 0 && [[[NoticeDataController sharedInstance].countArray objectAtIndex:1] integerValue]>0){
        self.systemPopImage.hidden = NO;
        self.systemLabel.hidden = NO;
        self.systemLabel.text = [NSString stringWithFormat:@"%@",[[NoticeDataController sharedInstance].countArray objectAtIndex:1]];
    }else{
        self.systemPopImage.hidden = YES;
        self.systemLabel.hidden = YES;
    }
    
    if ([NoticeDataController sharedInstance].countArray.count > 0 && [[[NoticeDataController sharedInstance].countArray objectAtIndex:0] integerValue]>0){
        self.discussLabel.hidden = NO;
        self.discussPopImage.hidden = NO;
        self.discussLabel.text = [NSString stringWithFormat:@"%@",[[NoticeDataController sharedInstance].countArray objectAtIndex:0]];
    }else{
        self.discussPopImage.hidden = YES;
        self.discussLabel.hidden = YES;
    }
}

- (void)readData{
    NSRange range = {0,20};
    announceRange = systemRange = discussRange = range;
    __weak NoticeViewController *weakSelf = self;
    [[NoticeDataController sharedInstance] getNoticeAnnouncementListByRange:range success:^(NoticeDataController *dataController, NSArray *announcementList) {
        [weakSelf.announceList removeAllObjects];
        [weakSelf.announceList addObjectsFromArray:announcementList];
        [weakSelf.announceTableView reloadData];
        [weakSelf setNoDataHidden];
    } failure:^(NoticeDataController *dataController, NSError *error) {
         [self setNoDataHidden];
    }];
    [[NoticeDataController sharedInstance] getNoticeCommentListByRange:range success:^(NoticeDataController *dataController, MVDiscussItem *discussItem) {
        [weakSelf.discussList removeAllObjects];
        [weakSelf.discussList addObjectsFromArray:discussItem.comments];
        [weakSelf.discussTableView reloadData];
        [weakSelf setNoDataHidden];
    } failure:^(NoticeDataController *dataController, NSError *error) {
         [self setNoDataHidden];
    }];
    [[NoticeDataController sharedInstance] getNoticeSystemListByRange:range success:^(NoticeDataController *dataController, NSArray *systemList) {
        [weakSelf.systemList removeAllObjects];
        [weakSelf.systemList addObjectsFromArray:systemList];
        [weakSelf.systemTableView reloadData];
        [weakSelf setNoDataHidden];
    } failure:^(NoticeDataController *dataController, NSError *error) {
         [self setNoDataHidden];
    }];
   
}

#pragma mark - tableViewDlegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.announceTableView) {
        if (self.announceList.count <= 0) {
            return 500;
        }
        NoticeCell *noticeCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] lastObject];
        [noticeCell setContentWithComment:[self.announceList objectAtIndex:indexPath.row]];
        return [noticeCell getCellHeight];
        
    }else if (tableView == self.systemTableView){
        if (self.systemList.count <= 0) {
            return 500;
        }
        NoticeCell *noticeCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] lastObject];
        [noticeCell setContentWithComment:[self.systemList objectAtIndex:indexPath.row]];
        return [noticeCell getCellHeight];
    }else{
        if (self.discussList.count <= 0) {
            return 500;
        }
        NoticeDiscussCell *noticeCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeDiscussCell" owner:self options:nil] lastObject];
        [noticeCell setContentWithComment:[self.discussList objectAtIndex:indexPath.row]];
        return [noticeCell getCellHeight];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.announceTableView) {
        if ( self.announceList.count > 0) {
            self.announceTableView.hidden = NO;
            return self.announceList.count;
        }
        self.announceTableView.hidden = YES;
        return 5;
    }else if (tableView == self.systemTableView){
        if (self.systemList.count > 0) {
            self.systemTableView.hidden = NO;
            return self.systemList.count;
        }
        self.systemTableView.hidden = YES;
        return 5;
    }else if (tableView == self.discussTableView){
        if (self.discussList.count > 0) {
            self.discussTableView.hidden = NO;
            return self.discussList.count;
        }
        self.discussTableView.hidden = YES;
        return 5;
    }
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *noticeCellID = @"noticeCellID";
    static NSString *discussCellID = @"discussCellID";
    
    if (tableView == self.announceTableView) {
        NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] lastObject];
        }
        if (self.announceList.count > 0) {
            [cell setContentWithComment:[self.announceList objectAtIndex:indexPath.row]];
        }
        return cell;
    }else if (tableView == self.systemTableView){
        NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] lastObject];
        }
        if (self.systemList.count > 0) {
            [cell setContentWithComment:[self.systemList objectAtIndex:indexPath.row]];
        }
        
        return cell;
    }else if(tableView == self.discussTableView){
        NoticeDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:discussCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeDiscussCell" owner:self options:nil] lastObject];
        }
//        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
//        }
        cell.delegate = self;
        if (self.discussList.count > 0) {
            MVDiscussComment *mvComment = [self.discussList objectAtIndex:indexPath.row];
            [cell setContentWithComment:mvComment];
        }
        
        return cell;
    }
    return nil;
}
#pragma mark - noticeDiscussDelegate
- (void)didReplyBtn:(NoticeDiscussCell *)cell{
    [MobClick event:@"Mv_Comment" label:@"回复评论"];
    MVDiscussComment *mvComment = cell.discussComment;
    self.currDiscuss = cell.discussComment;
    AlertWithComment *alert = [[AlertWithComment alloc] initWithCommentText:nil];
    alert.delegate = self;
    [alert showPlaceholder:[NSString stringWithFormat:@"回复: %@",mvComment.userName]];
    [alert alertShow];
}
#pragma mark - MVComment  MVShare delegte
- (void)publishButtonClicked:(AlertWithComment *)alert comment:(NSString *)comment
{
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
    if (self.currDiscuss) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.currDiscuss.videoId, @"videoId", self.currDiscuss.commentId, @"repliedId", comment, @"content", nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.currDiscuss.videoId, @"videoId" ,comment, @"content", nil];
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
            [AlertWithTip flashSuccessMessage:@"回复成功"];
        }else{
            NSLog(@"PUBLISH FAILURE!!!!!!!!");
            NSLog(@"%@",[responseDict objectForKey:@"display_message"]);
            [AlertWithTip flashFailedMessage:[responseDict objectForKey:@"display_message"] isKeyboard:NO];
        }
    } failure:^(MVDataController *dataController, NSError *error) {
        NSLog(@"MVComment error :%@",error);
        [self hideLoading];
        [indicatorView stopAnimating];
        alert.hidden = NO;
        [alert.commentTextView becomeFirstResponder];
        [AlertWithTip flashFailedMessage:@"评论失败" isKeyboard:NO];

    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NoticeDataController sharedInstance] getNoticeCount:^(NoticeDataController *dataController, NSDictionary *resultDict) {
        NSArray *resultArray = [resultDict objectForKey:@"data"];
        [[NoticeDataController sharedInstance].countArray removeAllObjects];
        [[NoticeDataController sharedInstance].countArray addObjectsFromArray:resultArray];
        [self showUnReadImage];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
