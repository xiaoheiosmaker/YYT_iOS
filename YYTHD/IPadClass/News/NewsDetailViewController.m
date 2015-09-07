//
//  NewsDetailViewController.m
//  YYTHD
//
//  Created by IAN on 14-3-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsPreviewImageCell.h"
#import "NewsDataController.h"
#import "NewsItem.h"
#import "YYTAlertView.h"
#import "NewsItem+NewsDetail.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "NewsImageViewController.h"

static NSString * const kNewsPreviewReuseIdentifier = @"kNewsPreviewReuseIdentifier";

@interface NewsDetailViewController ()<UIGestureRecognizerDelegate>
{
    NSInteger _imageIndex;
    ALAssetsLibrary* _library;
}

@property (nonatomic) NewsItem *item;
@property (nonatomic) NewsDataController *dataController;
@property (nonatomic) MBRoundProgressView *imageProgressView;

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataController = [[NewsDataController alloc] init];
        _library = [[ALAssetsLibrary alloc] init];
        
    }
    return self;
}

- (void)loadNewsWithID:(NSNumber *)newsID
{
    __weak id wself = self;
    [self showLoading];
    [self.dataController getNewsDetailWithID:newsID
                           completionHandler:^(NewsItem *item, NSError *error) {
                               [wself hideLoading];
                               if (error) {
                                   NSString *message = [error yytErrorMessage];
                                   [YYTAlertView flashFailureMessage:message];
                               }
                               else {
                                   self.item = item;
                                   [self reloadData];
                               }
                           }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self resetTopView:NO];
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    [self.topView isShowSideButton:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"News_title"]];
    
    [self.previewCollectionView registerClass:[NewsPreviewImageCell class] forCellWithReuseIdentifier:kNewsPreviewReuseIdentifier];
    
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    self.textView.clipsToBounds = NO;
    
    MBRoundProgressView *progressView = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    progressView.annular = YES;
    progressView.progressTintColor = [UIColor yytGreenColor];
    progressView.backgroundTintColor = [UIColor whiteColor];
    progressView.center = CGPointMake(CGRectGetMidX(self.newsImageView.bounds), CGRectGetMidY(self.newsImageView.bounds));
    [self.newsImageView addSubview:progressView];
    self.imageProgressView = progressView;
    progressView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageEvent:)];
    tap.delegate = self;
    self.newsImageView.userInteractionEnabled = YES;
    [self.newsImageView addGestureRecognizer:tap];
}

- (void)tapImageEvent:(id)sender
{
    NewsImageViewController *viewController = [[NewsImageViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setAnimationStartView:self.newsImageView];
    UIImage *placeholder = self.newsImageView.image;
    NSURL *imageURL = [self.item originImageURLAtIndex:_imageIndex];
    [viewController loadImageWithURL:imageURL placeholder:placeholder];
    [self presentViewController:viewController animated:NO completion:NULL];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}


- (IBAction)saveImageEvent:(id)sender
{
    UIImage *image = [self.newsImageView image];
    if (!image) {
        return;
    }
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusNotDetermined || status == ALAuthorizationStatusAuthorized) {
        [_library writeImageToSavedPhotosAlbum:[image CGImage]
                                      metadata:nil
                               completionBlock:^(NSURL *assetURL, NSError *error) {
                                   if (error) {
                                       [YYTAlertView flashFailureMessage:@"保存图片失败"];
                                   }
                                   else {
                                       [YYTAlertView flashSuccessMessage:@"保存图片成功"];
                                   }
                               }];
    }
}


- (void)reloadData
{
    if ([self.item newsImagesCount]) {
        [self showImageAtIndex:0];
        [self.previewCollectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.previewCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }
    self.textView.attributedText = [self.item detailAttributedString];
}

- (void)showImageAtIndex:(NSInteger)index
{
    _imageIndex = index;
    NSURL *imageURL = [self.item originImageURLAtIndex:index];
    
    self.imageProgressView.hidden = NO;
    __weak MBRoundProgressView *progressView = self.imageProgressView;
    progressView.progress = 0.0;
    [self.newsImageView setImageWithURL:imageURL
                       placeholderImage:nil
                                options:0
                               progress:^(NSUInteger receivedSize, long long expectedSize) {
                                   CGFloat progeress = (CGFloat)receivedSize/expectedSize;
                                   progressView.progress = progeress;

                               }
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  progressView.hidden = YES;
                              }];
    
    int total = [self.item newsImagesCount];
    NSString *str = [NSString stringWithFormat:@"第%d/%d页",(int)index+1,total];
    self.previewLabel.text = str;
}



#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.item newsImagesCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPreviewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewsPreviewReuseIdentifier forIndexPath:indexPath];
    
    NSURL *url = [self.item previewImageURLAtIndex:indexPath.item];
    [cell setImageWithURL:url];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showImageAtIndex:indexPath.row];
}

@end
