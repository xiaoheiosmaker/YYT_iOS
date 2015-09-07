//
//  MVItemView.m
//  YYTHD
//
//  Created by IAN on 13-10-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVItemView.h"
#import "MVItem.h"
#import "MVOfVListItem.h"
#import <UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "Artist.h"

static CGFloat MVImageHeight = 137;
static CGFloat MVImageWidth = 242;

static const CGFloat FontSize = 12;

static const CGFloat BTN_IMAGEVIEW_TAG = 201;

@implementation MVItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImage = [UIImage imageNamed:@"mv_bg"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.image = bgImage;
        [self addSubview:bgImageView];
        _bgImageView = bgImageView;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator = indicatorView;
        [_bgImageView addSubview:_loadingIndicator];
        _loadingIndicator.center = _bgImageView.center;
        
        CGFloat topMargin = 4;
        CGFloat leftMargin = 4;
        
        CGRect imageFrame = CGRectMake(leftMargin, topMargin, MVImageWidth, MVImageHeight);
        //imageBtn
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = imageFrame;
        [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        _imageBtn = imageBtn;
        
        //BTN自带的方法不能实现图片的拉伸功能
        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:imageBtn.bounds];
        btnImageView.tag = BTN_IMAGEVIEW_TAG;
        //btnImageView.userInteractionEnabled = YES;
        [self.imageBtn insertSubview:btnImageView atIndex:0];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 54*0.8, 54*0.8)];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        UILabel *rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 50*0.8, 50*0.8)];
        rankingLabel.textAlignment = NSTextAlignmentCenter;
        rankingLabel.textColor = [UIColor whiteColor];
        rankingLabel.font = [UIFont systemFontOfSize:30];
        _imageView = imageView;
        _rankingLabel = rankingLabel;
        _rankingLabel.backgroundColor = [UIColor clearColor];
        [_imageView addSubview:_rankingLabel];
        _imageView.hidden = YES;
        
        UIImageView *playingView = [[UIImageView alloc] initWithFrame:CGRectMake(205, 100, 33, 33)];
        imageView.backgroundColor = [UIColor clearColor];
        playingView.image = IMAGE(@"VListCurrtntPlay");
        [self addSubview:playingView];
        _playingView = playingView;
        _playingView.hidden = YES;
        
        int x = leftMargin;
        int y = MVImageHeight+topMargin;
        int width = CGRectGetWidth(frame)-2*x;
        int height = CGRectGetHeight(frame)-y-topMargin;
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        infoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:infoView];
        _infoView = infoView;
        
        x = 7;
        width = CGRectGetWidth(frame)-x-45;
        //title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 5, width, 20)];
        label.textColor = [UIColor yytDarkGrayColor];
        label.backgroundColor = [UIColor clearColor];
        [infoView addSubview:label];
        _titleLabel = label;
        _titleLabel.font = [UIFont systemFontOfSize:FontSize];
        
        //artists
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 25, width, 20)];
        [infoView addSubview:view];
        _artistsView = view;
        
        //add-Btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(195, 5, 40, 40);
        [btn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"add_h"] forState:UIControlStateHighlighted];
        [infoView addSubview:btn];
        _addBtn = btn;
        
        _loadingIndicator.center = self.imageBtn.center;
    }
    return self;
}

+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(250, 198);
}

- (void)setContentWithMVItem:(MVItem *)item
{
    self.mvItem = item;
    self.titleLabel.text = item.title;
    [self setupArtistView:item.artists];
    [_loadingIndicator startAnimating];
    UIImageView *imageView = (UIImageView *)[self.imageBtn viewWithTag:BTN_IMAGEVIEW_TAG];
    imageView.alpha = 0.0f;
    __weak UIImageView *imgView = imageView;
    [imageView setImageWithURL:item.coverImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [UIView animateWithDuration:0.5 animations:^{
            _loadingIndicator.alpha = 0.0f;
            imgView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_loadingIndicator stopAnimating];
                [_loadingIndicator removeFromSuperview];
                _loadingIndicator = nil;
            }
        }];
     }];

    
}

- (void)setContentWithMVOfVListItem:(MVItem *)item{
    self.mvItem = item;
    self.titleLabel.text = item.title;
    [self setupArtistView:item.artists];
    
    UIImageView *imageView = (UIImageView *)[self.imageBtn viewWithTag:BTN_IMAGEVIEW_TAG];
    [imageView setImageWithURL:item.coverImageURL placeholderImage:nil];
}

#pragma mark - Private
- (void)setupArtistView:(NSArray *)artists
{
    //clear prev btns
    [[_artistsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //setup btns
    int x = 0;
    int y = 0;
    
    CGFloat boundX = CGRectGetWidth(_artistsView.bounds);
    CGFloat boundY = CGRectGetHeight(_artistsView.bounds);
    
    NSInteger i = 0;
    for (Artist *art in artists) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
        [btn setTitle:art.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yytGreenColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        
        CGRect frame = btn.frame;
        frame.origin.x = x;
        y = (boundY-CGRectGetHeight(frame))/2;
        frame.origin.y = y;
        btn.frame = frame;
        
        if (CGRectGetMaxX(btn.frame)>boundX) {
            //超出显示范围，不处理
            break;
        }
        
        btn.tag = i++;
        [btn addTarget:self action:@selector(artistBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_artistsView addSubview:btn];
        
        x = CGRectGetMaxX(btn.frame)+3;
    }
    
}

- (void)artistBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MVItemVIew:didClickedArtist:)]) {
        NSInteger index = [sender tag];
        Artist *art = [self.mvItem.artists objectAtIndex:index];
        [self.delegate MVItemVIew:self didClickedArtist:art];
    }
}

- (void)imageBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MVItemViewDidClickedImage:)]) {
        [self.delegate MVItemViewDidClickedImage:self];
    }
}

- (void)addBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MVItemViewDidClickedAddBtn:)]) {
        [MobClick event:@"Add_list" label:@"加号添加至悦单"];
        [MobClick event:@"Login_Event" label:@"加号添加至悦单"];
        [self.delegate MVItemViewDidClickedAddBtn:self];
    }
}

@end
