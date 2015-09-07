//
//  ArtistOrderView.m
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistOrderView.h"
#import "Artist.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArtistOrderView

- (void)awakeFromNib{
    self.headImageView.layer.cornerRadius = 46;
    self.headImageView.layer.masksToBounds = YES;
    self.orderBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.artistName.textColor = [UIColor yytDarkGrayColor];
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
+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(170, 192);
}
- (IBAction)cancelBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelOrderArtist:)]) {
        [_delegate cancelOrderArtist:self];
    }
}
- (IBAction)backGroundBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(artistOrderViewClicked:)]) {
        [_delegate artistOrderViewClicked:self];
    }
}
- (IBAction)orderBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderArtist:)]) {
        [_delegate orderArtist:self];
    }
}

- (void)setContentWithAtist:(Artist*)artist{
    [self.headImageView setImageWithURL:[NSURL URLWithString:artist.smallAvatar] placeholderImage:[UIImage imageNamed:@"default_headImage"]];
    self.artistName.text = artist.name;
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
