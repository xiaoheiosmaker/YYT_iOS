//
//  MLPosterView.m
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLPosterView.h"
#import "UIColor+Generator.h"
#import "MLItem.h"
#import "MLAuthor.h"

@interface MLPosterView()
{
    __weak UIImageView *coverImageView;
    __weak UIImageView *authorImageView;
    __weak UILabel *authorLabel;
}
@end

@implementation MLPosterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame;
        UIImageView *imageView;
        
        frame = CGRectMake(0, 0, 240, 240);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor yytBackgroundColor];
        [self addSubview:imageView];
        coverImageView = imageView;
        
        frame = CGRectMake(5, 211, 52, 52);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = 26;
        imageView.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"ml_list_header_backgorund"];
        imageView.image = image;
        [self addSubview:imageView];
        
        frame = CGRectMake(7, 213, 48, 48);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = 24;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        authorImageView = imageView;
        
        UIFont *font = [UIFont systemFontOfSize:12.0];
        UILabel *label;

        frame = CGRectMake(64, 247, 109, 21);
        label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = [UIColor yytGreenColor];
        label.font = font;
        [self addSubview:label];
        authorLabel = label;
        
        frame = CGRectMake(4, 270, 234, 21);
        label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = [UIColor yytDarkGrayColor];
        label.font = font;
        [self addSubview:label];
        self.titleLabel = label;
    }
    return self;
}

- (void)setItem:(MLItem *)item
{
    if (item.coverImage)
        coverImageView.image = item.coverImage;
    else
        [self setCoverURL:item.playListBigPic];
    [self setAuthor:item.author];
    [self setTitle:item.title];
}

- (void)setCoverURL:(NSURL *)coverURL
{
    if (!coverURL) return;
    [coverImageView cancelCurrentImageLoad];
    coverImageView.image = nil;
    [coverImageView setImageWithURL:coverURL];
}

- (void)setAuthor:(MLAuthor *)author
{
    if (!author) return;
    [authorImageView cancelCurrentImageLoad];
    authorImageView.image = nil;
    [authorImageView setImageWithURL:author.largeAvatar placeholderImage:[UIImage imageNamed:@"headIcon"]];
    
    authorLabel.text = author.nickName;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
