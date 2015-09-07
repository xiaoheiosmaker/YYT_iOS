//
//  MyDownloadViewController.m
//  YYTHD
//
//  Created by IAN on 13-11-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MyDownloadViewController.h"
#import "ExButton.h"
#import "DbDao.h"
#import "MVDownloadCell.h"
#import "DownloadManager.h"
#import "LocalStorage.h"
#import "YYTMoviePlayerViewController.h"
#import "ExButton.h"

@interface MyDownloadViewController ()<GMGridViewActionDelegate,GMGridViewDataSource>
{
    ExButton *_editBtn;
    BOOL _needRefresh;
}

@property (weak, nonatomic) IBOutlet GMGridView *gmGridView;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation MyDownloadViewController

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
    self.emptyViewController.holderImage = IMAGE(@"无下载");
    self.emptyViewController.holderText = NODOENLOADMV;
    self.emptyViewController.scrv.scrollEnabled = NO;
    
    [self.topView isShowSideButton:YES];
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"myDownload_title"]];
    
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
    
    //为全屏大小的ScrollView添加contentInset，为上层控件留白。
    _gmGridView.sortingDelegate = nil; //禁止长按拖动
    _gmGridView.centerGrid = NO;
    _gmGridView.itemSpacing = 4;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 5);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(nfDownloadAdd:) name:NF_Download_ADD object:nil];
    [center addObserver:self selector:@selector(nfDownloadStart:) name:NF_Download_START object:nil];
    [center addObserver:self selector:@selector(nfDownloadCancel:) name:NF_Download_Cancel object:nil];
    [center addObserver:self selector:@selector(nfDownloadComplete:) name:NF_Download_Complete object:nil];
    [center addObserver:self selector:@selector(nfDownloadFailed:) name:NF_Download_Failed object:nil];
    [center addObserver:self selector:@selector(nfDownloadProgress:) name:NF_Download_Progress object:nil];
    
    [self initLocalList];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL isEditing = [_editBtn exSelected];
    if (isEditing) {
        [self editBtnClicked:_editBtn];
    }
    _needRefresh = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _needRefresh = NO;
}

- (void)initLocalList
{
    self.list = [[DbDao sharedInstance] getALLMVDownloadItems];
    [self checkEmpty:self.list];
    
    //mearge 下载进度
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MVDownloadItem *itemTmp = (MVDownloadItem *)obj;
        MVDownloadItem *itemTmpOfDownload = [[DownloadManager sharedDownloadManager] downloadItemOfKeyID:itemTmp.keyID];
        if (itemTmpOfDownload && itemTmpOfDownload.status == DownloadStatusDownloading) {
            itemTmp.cbytes = itemTmpOfDownload.cbytes;
            itemTmp.tbytes = itemTmpOfDownload.tbytes;
            itemTmp.currentProgress = itemTmpOfDownload.currentProgress;
            itemTmp.status = itemTmpOfDownload.status;
        }
    }];
    
    [_gmGridView reloadData];
}

- (void)editBtnClicked:(ExButton *)sender
{
    BOOL isEditing = [sender exSelected];
    if (![self.list count] && !isEditing) {
        //没有下载项时不允许编辑
        return;
    }
    
    [_gmGridView setEditing:!isEditing animated:YES];
    [sender setExSelected:!isEditing];
    //[self makeAllModuleEntranceDisappear:!isEditing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
- (void)nfDownloadAdd:(NSNotification *)notification
{
    MVDownloadItem *item = notification.object;
    
    [_list insertObject:item atIndex:0];
    [self checkEmpty:_list];
    
    [_gmGridView insertObjectAtIndex:0 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)nfDownloadCancel:(NSNotification *)notification
{
    MVDownloadItem *item = notification.object;
    
    __block int index = NSNotFound;
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MVDownloadItem *itemTmp = (MVDownloadItem *)obj;
        if ([itemTmp.keyID intValue] == [item.keyID intValue]) {
            itemTmp.status = item.status;
            
            index = idx;
            MVDownloadCell *cell = (MVDownloadCell *)[_gmGridView cellForItemAtIndex:index];
            if(cell){
                [cell reloadData:itemTmp];
            }
            
            *stop = YES;
        }
    }];
    
}

- (void)nfDownloadStart:(NSNotification *)notification
{
    MVDownloadItem *item = notification.object;
    
    __block int index = NSNotFound;
    
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MVDownloadItem *itemTmp = (MVDownloadItem *)obj;
        if ([itemTmp.keyID intValue] == [item.keyID intValue]) {
            itemTmp.status = item.status;
            
            index = idx;
            
            MVDownloadCell *cell = (MVDownloadCell *)[_gmGridView cellForItemAtIndex:index];
            if(cell){
                [cell reloadData:itemTmp];
            }
            
            *stop = YES;
        }
    }];
    
}

- (void)nfDownloadComplete:(NSNotification *)notification
{
    MVDownloadItem *item = notification.object;
    
    __block int index = NSNotFound;
    
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MVDownloadItem *itemTmp = (MVDownloadItem *)obj;
        if ([itemTmp.keyID intValue] == [item.keyID intValue]) {
            itemTmp.status = item.status;
            
            index = idx;
            
            MVDownloadCell *cell = (MVDownloadCell *)[_gmGridView cellForItemAtIndex:index];
            if(cell){
                [cell reloadData:itemTmp];
            }
            
            *stop = YES;
        }
    }];
    
}

- (void)nfDownloadFailed:(NSNotification *)notification
{
    MVDownloadItem *item = notification.object;
    NSDictionary *dict = notification.userInfo;
    NSError *error = [dict objectForKey:@"error"];
    
    [UIAlertView alertViewWithTitle:@"下载出错" message:[error localizedDescription]];
    //[AlertWithTip flashFailedMessage:@"下载出错"];
    
    __block int index = NSNotFound;
    
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MVDownloadItem *itemTmp = (MVDownloadItem *)obj;
        if ([itemTmp.keyID intValue] == [item.keyID intValue]) {
            itemTmp.status = item.status;
            
            index = idx;
            
            MVDownloadCell *cell = (MVDownloadCell *)[_gmGridView cellForItemAtIndex:index];
            if(cell){
                [cell reloadData:itemTmp];
            }
            
            *stop = YES;
        }
    }];
    
}

- (void)nfDownloadProgress:(NSNotification *)notification
{
    if (!_needRefresh) {
        return;
    }
    
    MVDownloadItem *item = notification.object;
    __block int index = NSNotFound;
    __block MVDownloadItem *itemTmp = nil;
    [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        itemTmp = (MVDownloadItem *)obj;
        if ([itemTmp.keyID intValue] == [item.keyID intValue]) {
            itemTmp.cbytes = item.cbytes;
            itemTmp.tbytes = item.tbytes;
            itemTmp.currentProgress = item.currentProgress;
            itemTmp.status = item.status;
            
            index = idx;
            
            MVDownloadCell *cell = (MVDownloadCell *)[_gmGridView cellForItemAtIndex:index];
            if(cell){
                [cell reloadData:itemTmp];
            }
            *stop = YES;
        }
    }];
    
}

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.list count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return [MVItemView defaultSize];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    MVDownloadCell *cell = (MVDownloadCell *)[gridView dequeueReusableCell];
    if (!cell) {
        CGRect frame = CGRectZero;
        frame.size = [MVDownloadCell defaultSize];
        cell = [[MVDownloadCell alloc] initWithFrame:frame];
        cell.deleteButtonIcon = [UIImage imageNamed:@"delete"];
        cell.deleteButtonOffset = CGPointMake(-2, -5);
    }
    
    [cell reloadData:[self.list objectAtIndex:index]];
    
    return cell;
}

#pragma mark GMGridViewDelegate
- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    MVDownloadItem *item = [_list objectAtIndex:position];
    if (!item) {
        return;
    }
    
    if (item.status == DownloadStatusComplete) {
        YYTMoviePlayerViewController *playerViewController = [YYTMoviePlayerViewController downloadMoviePlayerViewController];
        [playerViewController loadPlayList:@[item] startImmediately:YES];
        [self presentViewController:playerViewController animated:YES completion:NULL];
    }
    else if(item.status == DownloadStatusDefault) {
        [[DownloadManager sharedDownloadManager] startDownload:item];
    }
    else if(item.status == DownloadStatusDownloading) {
        [[DownloadManager sharedDownloadManager] cancelDownload:item];
    }
    else if(item.status == DownloadStatusWait) {
        [[DownloadManager sharedDownloadManager] cancelDownload:item];
    }
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"确认删除此MV?" confirmBlock:^{
        MVDownloadItem *item = [_list objectAtIndex:index];
        if (!item) {
            return;
        }
        [_list removeObjectAtIndex:index];
        [self checkEmpty:_list];
        [_gmGridView reloadData];
        [[DownloadManager sharedDownloadManager] deleteDownload:item];
    }];
    [alert showInView:self.view];
    //_lastDeleteItemIndexAsked = index;
}


@end
