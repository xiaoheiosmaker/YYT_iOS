//
//  MVDownloadCell.m
//  YYTHD
//
//  Created by btxkenshin on 10/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVDownloadCell.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "MVItemView.h"

static CGFloat MVImageHeight = 137;
static CGFloat MVImageWidth = 242;

static const CGFloat FontSize = 12;

static const CGFloat BTN_IMAGEVIEW_TAG = 201;

@implementation MVDownloadCell
{
    UIImageView *_imageView;
    UIImageView *_qualityImageView;
    UILabel *_titleLabel;
    UILabel *_artistLabel;
    
    
    UIView *_progressOptionView;
    
    UIImageView *_progerssBgView;
    UIImageView *_progerssIndicatorView;
    UILabel *_lCurrentSize;
    UILabel *_lTotalSize;
    UILabel *_lStatus;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImage = [UIImage imageNamed:@"mv_bg"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.image = bgImage;
        [self addSubview:bgImageView];
        
        CGFloat topMargin = 4;
        CGFloat leftMargin = 4;
        
        CGRect imageFrame = CGRectMake(leftMargin, topMargin, MVImageWidth, MVImageHeight);
        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        btnImageView.tag = BTN_IMAGEVIEW_TAG;
        [self addSubview:btnImageView];
        _imageView = btnImageView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(217, topMargin, 29, 19)];
        [self addSubview:imageView];
        _qualityImageView = imageView;
        
        CGFloat x = leftMargin;
        CGFloat y = MVImageHeight+topMargin;
        CGFloat width = CGRectGetWidth(frame)-2*x;
        CGFloat height = CGRectGetHeight(frame)-y-topMargin;
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        infoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:infoView];
        
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
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, 25, width, 20)];
        label.font = [UIFont systemFontOfSize:FontSize];
        label.textColor = [UIColor yytGreenColor];
        [infoView addSubview:label];
        _artistLabel = label;
        
        //======================================================================//
        //setup progress view
        CGRect progressFrame = imageFrame;
        progressFrame.origin.y = CGRectGetMaxY(progressFrame)-42;
        progressFrame.size.height = 42;
        
        _progressOptionView = [[UIView alloc] initWithFrame:progressFrame];
        _progressOptionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        x = 10;
        y = 10;
        CGFloat progressHeight = 10;
        _progerssBgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, CGRectGetWidth(progressFrame)-10*2, progressHeight)];
        UIImage *maxTrackImage = [UIImage imageNamed:@"player_slider_maxTrack"];
        maxTrackImage = [maxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        _progerssBgView.image = maxTrackImage;
        [_progressOptionView addSubview:_progerssBgView];
        
        _progerssIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 8, progressHeight)];
        UIImage *miniTrackImage = [UIImage imageNamed:@"player_slider_miniTrack"];
        miniTrackImage = [miniTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        _progerssIndicatorView.image = miniTrackImage;
        [_progressOptionView addSubview:_progerssIndicatorView];
        
        x += 5;
        y += progressHeight+2;
        _lCurrentSize = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 15)];
        _lCurrentSize.backgroundColor = [UIColor clearColor];
        _lCurrentSize.textColor = [UIColor yytGreenColor];
        _lCurrentSize.textAlignment = UITextAlignmentRight;
        _lCurrentSize.font = [UIFont systemFontOfSize:10];
        _lCurrentSize.text = @"1M";
        [_progressOptionView addSubview:_lCurrentSize];
        
        _lTotalSize = [[UILabel alloc] initWithFrame:CGRectMake(_lCurrentSize.right, y, 70, 15)];
        _lTotalSize.backgroundColor = [UIColor clearColor];
        _lTotalSize.textColor = [UIColor whiteColor];
        _lTotalSize.font = [UIFont systemFontOfSize:10];
        _lTotalSize.text = @"/10M";
        [_progressOptionView addSubview:_lTotalSize];
        
        x = CGRectGetMaxX(_progerssBgView.frame)-55;
        _lStatus = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 15)];
        _lStatus.backgroundColor = [UIColor clearColor];
        _lStatus.textColor = [UIColor whiteColor];
        _lStatus.textAlignment = NSTextAlignmentRight;
        _lStatus.font = [UIFont systemFontOfSize:10];
        _lStatus.text = @"下载状态";
        [_progressOptionView addSubview:_lStatus];
        

        [self addSubview:_progressOptionView];
    }
    return self;
}

+ (CGSize)defaultSize
{
    return CGSizeMake(250, 198);
}

- (void)reloadData:(MVDownloadItem *)item
{
    _titleLabel.text = item.title;
    _artistLabel.text = item.artistName;
    [_imageView setImageWithURL:item.thumbnailPic placeholderImage:nil];
    _qualityImageView.image = [self imageForQuality:item.quality];
    
    if (item.status == DownloadStatusComplete) {
        _progressOptionView.hidden = YES;
    }else{
        _progressOptionView.hidden = NO;
        
        CGFloat cbytes_m = (float)item.cbytes/1024/1024;
        CGFloat tbytes_m = (float)item.tbytes/1024/1024;
        _lCurrentSize.text = [NSString stringWithFormat:@"%.0fM",cbytes_m];
        CGSize size = [[NSString stringWithFormat:@"%.0fM",cbytes_m] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(1000, _lCurrentSize.height) lineBreakMode:NSLineBreakByCharWrapping];
        _lCurrentSize.width = size.width;
        _lTotalSize.left = _lCurrentSize.right;
        _lTotalSize.text = [NSString stringWithFormat:@"/%.0fM",tbytes_m];
        
        
        _lStatus.text = [item statusDes];
        
        _progerssIndicatorView.width = _progerssBgView.width * item.currentProgress;
    }
}

- (UIImage *)imageForQuality:(YYTMovieQuality)quality
{
    UIImage *image = nil;
    switch (quality) {
        case YYTMovieQualityDefault:
        {
            //标清不显示标识
            //image = [UIImage imageNamed:@"DefIcon"];
            break;
        }
        case YYTMovieQualityHD:
        {
            image = [UIImage imageNamed:@"HDIcon"];
            break;
        }
        case YYTMovieQualityUHD:
        default:
            break;
    }
    
    return image;
}

@end
