//
//  NewsImageViewController.m
//  YYTHD
//
//  Created by IAN on 14-3-18.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsImageViewController.h"

@interface NewsImageViewController ()<UIScrollViewDelegate>
{
    UIView *_startView;
}

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL beLoaded;
@property (nonatomic) BOOL beAnimated;
@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NewsImageViewController

- (void)dealloc
{
    [self.imageView cancelCurrentImageLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.beLoaded = NO;
        self.beAnimated = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)setAnimationStartView:(UIView *)view
{
    _startView = view;
}

- (void)loadImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)image
{
    self.imageView.image = image;
    __weak NewsImageViewController *wself = self;

    [self.imageView setImageWithURL:imageURL
                   placeholderImage:image
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if (wself.beAnimated) {
                                  [wself centerImageView];
                              }
                              wself.beLoaded = YES;
                          }];

}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    }
    return _imageView;
}

- (void)centerImageView
{
    UIImage *image = self.imageView.image;
    if (!self.scrollView || !image) {
        return;
    }
    
    CGFloat x = 0, y = 0;
    if (image.size.width < CGRectGetWidth(self.scrollView.frame)) {
        x = (CGRectGetWidth(self.scrollView.frame)-image.size.width)/2;
    }
    if (image.size.height < CGRectGetHeight(self.scrollView.frame)) {
        y = (CGRectGetHeight(self.scrollView.frame)-image.size.height)/2;
    }
    
    self.imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.scrollView addSubview:self.imageView];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.beLoaded) {
        CGSize imageSize = self.imageView.image.size;
        CGSize boundsSize = self.scrollView.bounds.size;
        self.scrollView.contentSize = CGSizeMake(MAX(imageSize.width, boundsSize.width), MAX(imageSize.height, boundsSize.height));
    }
    
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.3;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewEvent:)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.beAnimated) {
        CGRect startFrame = [self.view convertRect:_startView.frame fromView:[_startView superview]];
        self.imageView.frame = startFrame;
        [UIView animateWithDuration:0.35
                         animations:^{
                             [self centerImageView];
                         }
                         completion:^(BOOL finished) {
                             self.beAnimated = YES;
                         }];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
    CGSize imageSize = self.imageView.image.size;
    imageSize.width *= scale;
    imageSize.height *= scale;
    
    CGFloat x = 0, y = 0;
    if (imageSize.width < CGRectGetWidth(self.scrollView.frame)) {
        x = (CGRectGetWidth(self.scrollView.frame)-imageSize.width)/2;
    }
    if (imageSize.height < CGRectGetHeight(self.scrollView.frame)) {
        y = (CGRectGetHeight(self.scrollView.frame)-imageSize.height)/2;
    }
    
    CGRect frame = CGRectMake(x, y, imageSize.width, imageSize.height);
    self.imageView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

- (void)tapViewEvent:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
