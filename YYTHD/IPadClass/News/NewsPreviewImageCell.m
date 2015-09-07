//
//  NewsPreviewImageCell.m
//  YYTHD
//
//  Created by IAN on 14-3-14.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsPreviewImageCell.h"
#import "NAImageView.h"

@implementation NewsPreviewImageCell
{
    NAImageView *_imageView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *indicatorImage = [UIImage imageNamed:@"News_indicator"];
        UIImageView *indicatorView = [[UIImageView alloc] initWithImage:indicatorImage];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        [view addSubview:indicatorView];
        self.selectedBackgroundView = view;
        
        NAImageView *imageView = [[NAImageView alloc] initWithFrame:CGRectMake(0, 6, 129, 94)];
        //imageView.backgroundColor = [UIColor colorWithHEXColor:0xf3f3f3];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)imageURL
{
    [_imageView setImageWithURL:imageURL];
}

- (void)prepareForReuse
{
    _imageView.image = nil;
}

@end
