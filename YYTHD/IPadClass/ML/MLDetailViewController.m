//
//  MLDetailViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLDetailViewController.h"
#import "MLItem.h"
#import "MVItem.h"
#import "MLDataController.h"
#import "MLAuthor.h"
#import "UserDataController.h"
#import "MVDetailViewController.h"
#import "YYTMoviePlayerViewController.h"
#import "ShareAssistantController.h"
#import "TopView.h"
#import "UIColor+Generator.h"
#import "AlertWithTip.h"
#import "YYTAlert.h"
#import "PlatformSelectViewController.h"
#import "YYTPopoverBackgroundView.h"
#import "SystemSupport.h"
#import "MVCell.h"
#import "MVHeaderView.h"

#define DESCRIPTION_PLACE_HOLDER @"请填写一段悦单描述"
#define TITLE_PLACE_HOLDER @"请填写悦单名"

@interface MLDetailViewController () <
PlatformSelectViewControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    MVHeaderView *_mvHeaderView;
}
@property (weak, nonatomic) IBOutlet UITableView *mvTableView;
@property (weak, nonatomic) IBOutlet UIImageView *playIconView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIconView;
@property (weak, nonatomic) IBOutlet UIImageView *authorBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackgroundImageView;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (nonatomic, readonly) UIButton *deSelectedAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *btnBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *changeCoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (nonatomic, readonly) MVHeaderView *mvHeaderView;

@property (nonatomic, strong)UIPopoverController *imagePickerPopover;
@property (nonatomic, strong)UINavigationController *imagePickerNavigationController;

@property (nonatomic, strong)NSMutableArray *videos;

@property (nonatomic) BOOL allMVSelected;
@property (nonatomic) BOOL keyboardShown;
@property (nonatomic, strong)UIImage *coverImageToUpload;
@property (nonatomic, readonly)YYTMoviePlayerViewController *playerVC;
@property (nonatomic, readonly)UIPopoverController *platformPopover;

- (IBAction)playBtnClicked:(id)sender;
- (IBAction)favoriteBtnClicked:(id)sender;
- (IBAction)shareBtnClicked:(id)sender;
- (IBAction)selectAllBtnClicked:(id)sender;
- (void)deSelectedAllBtnClicked:(id)sender;
- (IBAction)changeCoverBtnCliecked:(id)sender;
- (IBAction)deleteBtnClicked:(id)sender;

- (void)hideKeyboard;
- (void)fetchDetailForID:(NSNumber *)mlID;
- (void)updateViewForItem:(MLItem *)item;
- (void)playMLFromIndex:(int)index;
- (void)alertMessage:(NSString *)message;
@end

@implementation MLDetailViewController
@synthesize mlItem = _mlItem;
@synthesize allMVSelected = _allMVSelected;
@synthesize deSelectedAllBtn = _deSelectedAllBtn;
@synthesize coverImageToUpload = _coverImageToUpload;
@synthesize playerVC = _playerVC;
@synthesize platformPopover = _platformPopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.videos = [NSMutableArray array];
    }
    return self;
}

- (id)initWithMLItem:(MLItem *)item editing:(BOOL)editing
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mlItem = item;
        self.mlItem.title = nil;
        self.editable = YES;
        self.editing = YES;
        self.needCommit = YES;
    }
    return self;
}

- (id)initWithMLID:(NSNumber *)keyID
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        MLItem *item = [[MLItem alloc] init];
        if (keyID) {
            item.keyID = keyID;
        }
        self.mlItem = item;
    }
    return self;
}

- (id)initWithMLID:(NSNumber *)keyID editing:(BOOL)editing
{
    self = [self initWithMLID:keyID];
    if (self) {
        self.editing = editing;
        self.editable = YES;
        self.needCommit = YES;
    }
    return self;
}

- (id)initWithMLID:(NSNumber *)keyID editable:(BOOL)editable
{
    self = [self initWithMLID:keyID];
    if (self) {
        self.editable = editable;
    }
    return self;
}

- (MVHeaderView *)mvHeaderView
{
    if (!_mvHeaderView) {
        _mvHeaderView = [[MVHeaderView alloc] init];
    }
    return _mvHeaderView;
}

- (void)setVideos:(NSMutableArray *)videos
{
    _videos = videos;
    self.mvHeaderView.amountOfMV = [videos count];
    [self.mvTableView reloadData];
}

- (YYTMoviePlayerViewController *)playerVC
{
    if (!_playerVC) {
        _playerVC = [YYTMoviePlayerViewController movieListPlayerViewControllerWithMLItem:self.mlItem];
    }
    return _playerVC;
}

- (UIPopoverController *)platformPopover
{
    if (!_platformPopover) {
        PlatformSelectViewController *platformVC = [[PlatformSelectViewController alloc] init];
        platformVC.delegate = self;
        _platformPopover = [[UIPopoverController alloc] initWithContentViewController:platformVC];
        _platformPopover.popoverBackgroundViewClass = [YYTPopoverBackgroundView class];
    }
    return _platformPopover;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetTopView:NO];
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    if (self.editable) {
        [self.topView setTitleImage:[UIImage imageNamed:@"ml_edit_title"]];
        [self.topView addSubview:self.editBtn];
        [self.topView addSubview:self.doneBtn];
        [self.topView addSubview:self.commitIndicator];
    }
    else {
        [self.topView setTitleImage:[UIImage imageNamed:@"ml_detail_title"]];
    }
    self.authorImageView.layer.cornerRadius = 24.0f;
    self.authorImageView.layer.masksToBounds = YES;
    self.authorLabel.hidden = self.editable;
    self.doneBtn.hidden = !self.editing;
    self.editBtn.hidden = self.editing;
    self.descriptionTextView.editable = self.editing;
    self.playCountLabel.hidden = self.editing;
    self.playIconView.hidden = self.editing;
    self.favoriteCountLabel.hidden = self.editing;
    self.favoriteIconView.hidden = self.editing;
    self.playBtn.hidden = self.editing;
    self.favoriteBtn.hidden = self.editing;
    self.shareBtn.hidden = self.editing;
    self.deleteBtn.hidden = !self.editing;
    self.changeCoverBtn.hidden = !self.editing;
    self.titleTextView.editable = self.editing;
    self.descriptionTextView.editable = self.editing;
    if (self.editing) {
        self.titleTextView.backgroundColor = [UIColor yytBackgroundColor];
        self.descriptionTextView.backgroundColor = self.titleTextView.backgroundColor;
    }
    else {
        self.titleTextView.backgroundColor = [UIColor clearColor];
        self.descriptionTextView.backgroundColor = self.titleTextView.backgroundColor;
    }
    
    // 必须先设置placeholder，然后才能设置textColor
    self.titleTextView.placeholder = TITLE_PLACE_HOLDER;
    self.titleTextView.textColor = [UIColor yytDarkGrayColor];
    if ([SystemSupport versionPriorTo7]) {
        UIEdgeInsets edgeInsets = self.titleTextView.contentInset;
        edgeInsets.top = 0;
        self.titleTextView.contentInset = edgeInsets;
    }
    else {
        UIEdgeInsets textEdgeInsets = self.titleTextView.textContainerInset;
        textEdgeInsets.top = 0;
        self.titleTextView.textContainerInset = textEdgeInsets;
    }
    self.descriptionTextView.placeholder = DESCRIPTION_PLACE_HOLDER;
    self.descriptionTextView.textColor = [UIColor yytDarkGrayColor];
    self.favoriteCountLabel.textColor = [UIColor yytGrayColor];
    self.playCountLabel.textColor = [UIColor yytGrayColor];
    self.authorLabel.textColor = [UIColor yytGreenColor];
    
    self.btnBackgroundView.hidden = !self.editing;
    self.selectAllBtn.hidden = !self.editing;
    self.deSelectedAllBtn.autoresizingMask = self.selectAllBtn.autoresizingMask;
    self.deSelectedAllBtn.hidden = YES;
    [self.selectAllBtn.superview addSubview:self.deSelectedAllBtn];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"contentBackground"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.infoBackgroundImageView.image = backgroundImage;
    backgroundImage = [backgroundImage copy];
    self.descriptionBackgroundImageView.image = backgroundImage;
    
    CGFloat statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    for (UIView *subview in self.view.subviews) {
        if (subview != self.topView && subview != self.statusBarBackView) {
            CGPoint topLeft = subview.origin;
            topLeft.y += statusBarHeight;
            subview.origin = topLeft;
        }
    }
    
    self.mvTableView.editing = self.editing;
    self.mvTableView.dataSource = self;
    self.mvTableView.delegate = self;
    self.mvTableView.allowsMultipleSelection = NO;
    self.mvTableView.allowsMultipleSelectionDuringEditing = YES;
    self.mvTableView.tableHeaderView = self.mvHeaderView;
    self.mvTableView.contentInset = UIEdgeInsetsMake(70, 0, 84, 0);
    self.mvTableView.origin = CGPointMake(self.mvTableView.origin.x, statusBarHeight);
    self.mvTableView.size = CGSizeMake(self.mvTableView.width, self.view.height);
    self.mvTableView.clipsToBounds = NO;
    UIEdgeInsets edgeInsets = self.mvTableView.contentInset;
    edgeInsets.right = -7;
    self.mvTableView.scrollIndicatorInsets = edgeInsets;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleTextFieldChanged:) name:UITextViewTextDidChangeNotification object:self.titleTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(descriptionTextViewChanged:) name:UITextViewTextDidChangeNotification object:self.descriptionTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self updateViewForItem:self.mlItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setEditable:(BOOL)editable
{
    [super setEditable:editable];
    self.authorLabel.hidden = editable;
}

- (void)setEditing:(BOOL)editing
{
    if (self.editing != editing) {
        [super setEditing:editing];
        self.titleTextView.editable = self.editing;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        if (self.editing) {
            self.titleTextView.backgroundColor = [UIColor yytBackgroundColor];
            self.descriptionTextView.backgroundColor = self.titleTextView.backgroundColor;
            self.topView.titleImageView.image = [UIImage imageNamed:@"ml_edit_title"];
        }
        else {
            self.titleTextView.backgroundColor = [UIColor clearColor];
            self.descriptionTextView.backgroundColor = self.titleTextView.backgroundColor;
            self.topView.titleImageView.image = [UIImage imageNamed:@"ml_detail_title"];
        }
        [UIView commitAnimations];
        self.descriptionTextView.editable = self.editing;
        self.playCountLabel.hidden = self.editing;
        self.playIconView.hidden = self.editing;
        self.favoriteCountLabel.hidden = self.editing;
        self.favoriteIconView.hidden = self.editing;
        self.playBtn.hidden = self.editing;
        self.favoriteBtn.hidden = self.editing;
        self.shareBtn.hidden = self.editing;
        if (self.needCommit) {
            self.playBtn.enabled = NO;
            self.favoriteBtn.enabled = NO;
            self.shareBtn.enabled = NO;
        }
        self.mvTableView.editing = self.editing;
        // 编辑相关的按钮在进入编辑状态后需要显示，离开编辑状态后需要隐藏
        if (self.editing) {
            self.selectAllBtn.hidden = self.allMVSelected;
            self.deSelectedAllBtn.hidden = !self.allMVSelected;
        } else {
            self.selectAllBtn.hidden = YES;
            self.deSelectedAllBtn.hidden = YES;
        }
        self.btnBackgroundView.hidden = !self.editing;
        self.deleteBtn.hidden = !self.editing;
        self.changeCoverBtn.hidden = !self.editing;
    }
}

- (UIButton *)deSelectedAllBtn
{
    if (!_deSelectedAllBtn) {
        _deSelectedAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImg = [UIImage imageNamed:@"ml_detail_deselected_all"];
        UIImage *highImg = [UIImage imageNamed:@"ml_detail_deselected_all_h"];
        CGSize size = normalImg.size;
        [_deSelectedAllBtn setImage:normalImg
                           forState:UIControlStateNormal];
        [_deSelectedAllBtn setImage:highImg
                           forState:UIControlStateHighlighted];
        _deSelectedAllBtn.frame = CGRectMake(0, 0, size.width, size.height);
        _deSelectedAllBtn.center = self.selectAllBtn.center;
        [_deSelectedAllBtn addTarget:self
                              action:@selector(deSelectedAllBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _deSelectedAllBtn;
}

- (void)setAllMVSelected:(BOOL)allMVSelected
{
    if (_allMVSelected != allMVSelected) {
        _allMVSelected = allMVSelected;
        self.selectAllBtn.hidden = _allMVSelected;
        self.deSelectedAllBtn.hidden = !_allMVSelected;
        self.deSelectedAllBtn.center = self.selectAllBtn.center;
    }
}

- (IBAction)selectAllBtnClicked:(id)sender {
    [self hideKeyboard];
    int rowCount = [self.mvTableView numberOfRowsInSection:0];
    for (int i = 0; i < rowCount; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [self.mvTableView selectRowAtIndexPath:index
                                      animated:NO
                                scrollPosition:UITableViewScrollPositionNone];
    }
    self.allMVSelected = YES;
}

- (void)deSelectedAllBtnClicked:(id)sender
{
    [self hideKeyboard];
    int rowCount = [self.mvTableView numberOfRowsInSection:0];
    for (int i = 0; i < rowCount; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [self.mvTableView deselectRowAtIndexPath:index animated:NO];
    }
    self.allMVSelected = NO;
}

- (IBAction)deleteBtnClicked:(id)sender {
    [self hideKeyboard];
    NSArray *array = [self.mvTableView indexPathsForSelectedRows];
    if ([self.mvTableView numberOfRowsInSection:0] == [array count]) {
        self.deleteBtn.enabled = NO;
        self.selectAllBtn.enabled = NO;
        self.selectAllBtn.hidden = NO;
        self.deSelectedAllBtn.hidden = YES;
    }
    if ([array count] > 0) {
        self.needCommit = YES;
    }
    for (int i = [array count] - 1; i >= 0; i--) {
        NSIndexPath *indexPath = [array objectAtIndex:i];
        [self.videos removeObjectAtIndex:indexPath.row];
    }
    self.selectAllBtn.enabled = [self.videos count] > 0;
    self.mvHeaderView.amountOfMV = [self.videos count];
    [self.mvTableView deleteRowsAtIndexPaths:array
                            withRowAnimation:UITableViewRowAnimationFade];
}

- (void)btnBackClicked
{
    [self hideKeyboard];
    if (self.needCommit) {
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要放弃修改么？"confirmBlock:^{
            [self ingoreChange];
        }];
        [alert showInView:self.view];
    } else {
        [super btnBackClicked];
    }
}

- (void)doneBtnClicked:(id)sender
{
    [self hideKeyboard];
    if ([self.titleTextView.text length] > 30) {
        [self alertMessage:@"悦单标题长度不能超过30个字"];
        return;
    }
    if ([self.descriptionTextView.text length] > 2000) {
        [self alertMessage:@"悦单描述长度不能超过2000个字"];
        return;
    }
    if (self.needCommit) {
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要保存修改么？" confirmBlock:^{
            [self confirmChange];
        }];
        [alert showInView:self.view];
    } else {
        self.editing = NO;
    }
}

- (void)hideKeyboard
{
    if ([self.titleTextView isFirstResponder]) {
        [self.titleTextView resignFirstResponder];
    }
    if ([self.descriptionTextView isFirstResponder]) {
        [self.descriptionTextView resignFirstResponder];
    }
}

- (void)ingoreChange
{
    if (self.delegate) {
        [self.delegate cancelCreateMLInDetailViewController:self];
    }
    [super btnBackClicked];
}

- (void)confirmChange
{
    self.editing = NO;
}

- (void)alertMessage:(NSString *)message
{
    YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:message delegate:nil];
    [alert showInView:self.view];
}

- (IBAction)playBtnClicked:(id)sender {
    if ([self.videos count] > 0) {
        [self playMLFromIndex:0];
    } else {
        [AlertWithTip flashFailedMessage:@"无法播放空悦单"];
    }
}

- (IBAction)favoriteBtnClicked:(id)sender {
    if ([[UserDataController sharedInstance] isLogin]) {
        self.favoriteBtn.enabled = NO;
        [[MLDataController sharedObject] addFavoriteWithID:self.mlItem.keyID completion:^(BOOL success, NSError *error) {
            self.favoriteBtn.enabled = YES;
            if (success) {
                [AlertWithTip flashSuccessMessage:@"收藏悦单成功"];
            } else {
                [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
            }
        }];
    } else {
        [[LoginAssistantController sharedInstance] loginInView:self.view];
    }
}

- (IBAction)shareBtnClicked:(id)sender {
    CGRect fromRect = [sender frame];
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    CGRect newRect = [rootVC.view convertRect:fromRect fromView:[sender superview]];
    [[self platformPopover] presentPopoverFromRect:newRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)changeCoverBtnCliecked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"现在拍照", @"从相册选择", nil];
        [actionSheet showInView:self.view];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self showImagePicker:imagePicker];
    }
}

- (void)updateML
{
    void (^completionBlock)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
        [self.commitIndicator stopAnimating];
        if (success) {
            [AlertWithTip flashSuccessMessage:@"修改悦单成功"];
            self.needCommit = NO;
            self.editBtn.hidden = NO;
            self.playBtn.enabled = YES;
            self.favoriteBtn.enabled = YES;
            self.shareBtn.enabled = YES;
            [self fetchDetailForID:self.mlItem.keyID];
        } else {
            [self alertMessage:@"修改悦单失败"];
            self.doneBtn.hidden = NO;
        }
    };
    if (self.coverImageToUpload) {
    [[MLDataController sharedObject] uploadCoverImage:self.coverImageToUpload completionBlock:^(NSString *imageURL, NSError *error) {
        [[MLDataController sharedObject] updateMLWithID:self.mlItem.keyID title:self.titleTextView.text descrip:self.descriptionTextView.text headImage:imageURL backgroundImage:@"" videoData:_videos completion:completionBlock];
    }];
    } else {
        [[MLDataController sharedObject] updateMLWithID:self.mlItem.keyID title:self.titleTextView.text descrip:self.descriptionTextView.text headImage:@"" backgroundImage:@"" videoData:_videos completion:completionBlock];
    }
}

- (void)createML
{
    if (!self.titleTextView.text || [self.titleTextView.text isEqualToString:@""]) {
        [self alertMessage:@"不能创建标题为空的悦单"];
        self.editing = YES;
        return;
    }
    if ([self.videos count] == 0) {
        [self alertMessage:@"不能创建没有视频的悦单"];
        self.editing = YES;
        return;
    }
    
    NSMutableString *vids = [@"" mutableCopy];
    for (int i = 0; i < [self.videos count]; i++) {
        MVItem *mv = [self.videos objectAtIndex:i];
        [vids appendFormat:@"%d", [mv.keyID intValue]];
        if (i + 1 < [self.videos count]) {
            [vids appendString:@","];
        }
    }
    if (self.delegate) {
        [self.delegate detailViewController:self
                          createMLWithTitle:self.titleTextView.text
                                 coverImage:self.coverImageView.image
                                description:self.descriptionTextView.text
                                   videoIDs:vids
                                 completion:^(MLItem *item, NSError *error) {
                                     [self.commitIndicator stopAnimating];
                                     if (error) {
                                         NSString *message = [error yytErrorMessage];
                                         [AlertWithTip flashFailedMessage:message];
                                         self.editing = YES;
                                         self.doneBtn.hidden = NO;
                                     }
                                     else {
                                         self.mlItem = item;
                                         [AlertWithTip flashSuccessMessage:@"创建悦单成功"];
                                         self.needCommit = NO;
                                         self.editBtn.hidden = NO;
                                         self.playBtn.enabled = YES;
                                         self.favoriteBtn.enabled = YES;
                                         self.shareBtn.enabled = YES;
                                     }
        }];
    }
}

- (void)commit
{
    BOOL isCreateML = self.mlItem.keyID == nil;
    if (isCreateML) {
        [self createML];
    } else {
        [self updateML];
    }
}

- (void)titleTextFieldChanged:(NSNotification *)notification
{
    self.needCommit = YES;
}

- (void)descriptionTextViewChanged:(NSNotification *)notification
{
    self.needCommit = YES;
}

- (void)keyboardShown:(NSNotification *)notification
{
    if (self.keyboardShown) return;
    
    if ([self.descriptionTextView isFirstResponder]) {
        self.keyboardShown = YES;
        NSDictionary *keyboardInfo = [notification userInfo];
        NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
            keyboardFrame.size = CGSizeMake(keyboardFrame.size.height, keyboardFrame.size.width);
        }
        for (UIView *subview in self.view.subviews) {
            subview.origin = CGPointMake(subview.origin.x, subview.origin.y - keyboardFrame.size.height);
        }
    }
}

- (void)keyboardHidden:(NSNotification *)notification
{
    if (!self.keyboardShown) return;
    
    self.keyboardShown = NO;
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
        keyboardFrame.size = CGSizeMake(keyboardFrame.size.height, keyboardFrame.size.width);
    }
    for (UIView *subview in self.view.subviews) {
        subview.origin = CGPointMake(subview.origin.x, subview.origin.y + keyboardFrame.size.height);
    }
}

- (void)setMlItem:(MLItem *)item
{
    if (_mlItem != item) {
        _mlItem = item;
        // MLItem是来自于后台还是创建的新MLItem
        if (item.keyID) {
            [self fetchDetailForID:item.keyID];
        }
        else {
            self.videos = [_mlItem.videos mutableCopy];
        }
    }
}

- (void)fetchDetailForID:(NSNumber *)mlID
{
    void (^completionBlock)(MLItem *, NSError *) = ^(MLItem *item, NSError *error) {
        [self hideLoading];
        if (!error) {
            _mlItem = item;
            self.videos = [item.videos mutableCopy];
            [self updateViewForItem:item];
        } else {
            // TODO: 出错需要处理
        }
    };
    [self showLoading];
    [[MLDataController sharedObject] fetchMLDetailForID:mlID completion:completionBlock];
}

- (void)updateViewForItem:(MLItem *)item
{
    self.titleTextView.text = item.title;
    NSURL *coverPic = self.mlItem.playListBigPic ?: self.mlItem.coverPic;
    [self.coverImageView setImageWithURL:coverPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){}];
    NSURL *creatorAvatar;
    if (self.mlItem.author) {
        creatorAvatar = self.mlItem.author.largeAvatar;
    }
    else if ([[UserDataController sharedInstance] isLogin]) {
        creatorAvatar = [[UserDataController sharedInstance] currentUser].largeAvatar;
    }
    if (creatorAvatar) {
        [self.authorImageView setImageWithURL:creatorAvatar placeholderImage:[UIImage imageNamed:@"headIcon"]];
        self.authorLabel.text = self.mlItem.author.nickName;
    }
    self.playCountLabel.text = [NSString stringWithFormat:@"%d次播放", [item.totalViews intValue]];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d次收藏", [item.totalFavorites intValue]];
    self.descriptionTextView.text = item.description;
    if (item.videoCount.intValue == 0) {
        self.deleteBtn.enabled = NO;
        self.selectAllBtn.enabled = NO;
    }
    else {
        self.deleteBtn.enabled = YES;
        self.selectAllBtn.enabled = YES;
    }
}

- (void)playMLFromIndex:(int)index
{
    [self presentViewController:self.playerVC animated:YES completion:nil];
    [self.playerVC playMVItemAtIndex:index];
}

- (void)showImagePicker:(UIImagePickerController *)imagePicker
{
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    CGRect rect = self.changeCoverBtn.frame;
    [self.imagePickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.coverImageView setImage:image];
    self.needCommit = YES;
    self.coverImageToUpload = image;
    [self.imagePickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0) {         // "拍照"
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self showImagePicker:imagePicker];
    } else if (buttonIndex == 1) {  // "相册"
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showImagePicker:imagePicker];
    } 
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MVCellHeight;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allMVSelected) {
        self.allMVSelected = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        int totalCount = [self.mvTableView numberOfRowsInSection:0];
        int selectedCount = [[self.mvTableView  indexPathsForSelectedRows] count];
        if (totalCount == selectedCount) {
            self.allMVSelected = YES;
        }
    } else {
        [self playMLFromIndex:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVCell"];
    if (!cell) {
        cell = [[MVCell alloc] init];
        cell.controller = self;
        cell.tableView = tableView;
    }
    MVItem *item = [self.videos objectAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row) {
        return;
    }
    self.needCommit = YES;
    MVItem *item = [self.videos objectAtIndex:sourceIndexPath.row];
    [self.videos removeObject:item];
    [self.videos insertObject:item atIndex:destinationIndexPath.row];
}

#pragma mark - MLMVItemCellDelegate
- (void)joinToML:(id)sender atIndexPath:(NSIndexPath *)ip
{
    if (self.presentingViewController) {
        __weak MLDetailViewController *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf joinToML:sender atIndexPath:ip];
        }];
        return;
    }
    MVItem *item = [self.mlItem.videos objectAtIndex:ip.row];
    [AddMVToMLAssistantController sharedInstance].mvToAdd = item;
}

#pragma mark - PlatformSelectViewControllerDelegate
- (void)selectOpenPlatform:(int)opType
{
    [self.platformPopover dismissPopoverAnimated:NO];
    
    NSURL *coverPic = self.mlItem.playListBigPic ?: self.mlItem.coverPic;
    
    [[ShareAssistantController sharedInstance] sharePlaylistID:self.mlItem.keyID
                                                         title:self.mlItem.title
                                                imageURLString:coverPic.absoluteString
                                              inViewController:self
                                                toOpenPlatform:opType
                                                    completion:nil];
}

@end
