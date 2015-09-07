//
//  ArtistDetailView.m
//  YYTHD
//
//  Created by ssj on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistDetailView.h"
#import "Artist.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArtistDetailView

- (void)awakeFromNib{
    self.userInteractionEnabled = YES;
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.cornerRadius = 41.5;
    self.headImageView.layer.masksToBounds = YES;
    self.orderBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.artistName.textColor = [UIColor yytDarkGrayColor];
    self.mvCountLabel.textColor = [UIColor yytGrayColor];
    self.totalOrderCount.textColor = [UIColor yytGrayColor];
    self.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"artist_backImageView"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.backgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setContentWithArtist:(Artist *)artist{
    [self.headImageView setImageWithURL:[NSURL URLWithString:artist.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
    self.artistName.text = artist.name;
    NSInteger length = [NSString stringWithFormat:@"%@",artist.videoCount].length;
    NSRange range = {2,length};
    self.mvCountLabel.text = [NSString stringWithFormat:@"收录%@个MV",artist.videoCount];
    [self.mvCountLabel setTextColor:[UIColor yytDarkGrayColor] range:range];
    length = [NSString stringWithFormat:@"%@",artist.subCount].length;;
    NSRange rag = {1,length};
    self.totalOrderCount.text = [NSString stringWithFormat:@"有%@个人订阅",artist.subCount];
    [self.totalOrderCount setTextColor:[UIColor yytDarkGrayColor] range:rag];
}

+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(300, 120);
}

- (IBAction)backgroundClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(artistDetailViewClicked:)]) {
        [_delegate artistDetailViewClicked:self];
    }
}
- (IBAction)orderBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(artistOrderClicked:)]) {
        [_delegate artistOrderClicked:self];
    }
}
- (IBAction)cancelBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(artistCancelClicked:)]) {
        [_delegate artistCancelClicked:self];
    }
}
@end
