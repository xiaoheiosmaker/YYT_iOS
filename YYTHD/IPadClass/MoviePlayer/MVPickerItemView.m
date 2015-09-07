//
//  MVPickerItemView.m
//  YYTHD
//
//  Created by IAN on 13-11-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVPickerItemView.h"
#import "MVItem.h"

static CGFloat MVImageHeight = 95;
static CGFloat MVImageWidth = 170;

static const CGFloat FontSize = 10;

@implementation MVPickerItemView
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_artistLabel;
    
    UIImageView *_playMarkView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat topMargin = 4;
        CGFloat leftMargin = 0;
        
        CGRect imageFrame = CGRectMake(leftMargin, topMargin, MVImageWidth, MVImageHeight);
        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        btnImageView.contentMode = UIViewContentModeScaleAspectFill;
        btnImageView.clipsToBounds = YES;
        [self addSubview:btnImageView];
        _imageView = btnImageView;
        
        UIImage *playingIcon = [UIImage imageNamed:@"miniPlayingIcon"];
        UIImageView *playMark = [[UIImageView alloc] initWithImage:playingIcon];
        CGPoint markCenter = CGPointMake(14, 18);
        playMark.center = markCenter;
        playMark.hidden = YES;
        [self addSubview:playMark];
        _playMarkView = playMark;
        
        CGFloat x = leftMargin;
        CGFloat y = MVImageHeight+topMargin;
        CGFloat width = CGRectGetWidth(frame)-2*x;
        CGFloat height = CGRectGetHeight(frame)-y-topMargin;
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        infoView.backgroundColor = [UIColor clearColor];
        [self addSubview:infoView];
        
        x = 1;
        width = CGRectGetWidth(frame)-x-5;
        //title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 2, width, 18)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:FontSize];
        [infoView addSubview:label];
        _titleLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, 20, width, 18)];
        label.textColor = [UIColor yytGreenColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:FontSize];
        [infoView addSubview:label];
        _artistLabel = label;
    }
    return self;
}

- (void)setPlayMarkHidden:(BOOL)hidden
{
    _playMarkView.hidden = hidden;
}

- (BOOL)playMarkIsHidden
{
    return _playMarkView.hidden;
}

+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(170, 140);
}

- (void)setContentWithMVItem:(MVItem *)item
{
    _titleLabel.text = item.title;
    _artistLabel.text = [item artistName];
    [_imageView setImageWithURL:item.coverImageURL placeholderImage:nil];
}

@end
