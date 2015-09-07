//
//  ArtistView.m
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistShowView.h"
#import "Artist.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArtistShowView

- (void)awakeFromNib{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArtistView:)];
//    [self addGestureRecognizer:tap];
    self.artistHeaderView.layer.cornerRadius = 50.5f;
    self.artistHeaderView.layer.masksToBounds = YES;
    self.artistNameLabel.textColor = [UIColor yytGreenColor];
    self.totalCountLabel.textColor = [UIColor yytDarkGrayColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)tapArtistView:(id)sender{
    
}

+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(170, 170);
}

- (void)setContentWithAtist:(Artist*)artist{
    [self.artistHeaderView setImageWithURL:[NSURL URLWithString:artist.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
    self.artistNameLabel.text = artist.name;
    self.totalCountLabel.text = [NSString stringWithFormat:@"有%@个人订阅",artist.subCount];
}
- (IBAction)backgroundClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(artistShowViewClicked:)]) {
        [self.delegate artistShowViewClicked:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
