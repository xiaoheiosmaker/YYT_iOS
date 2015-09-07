//
//  MVItemViewForSearch.m
//  YYTHD
//
//  Created by ssj on 14-2-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "MVItemViewForSearch.h"
#import "MVItem.h"

@implementation MVItemViewForSearch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageViewSHD = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Video_HD"]];
        imageViewSHD.frame = CGRectMake(frame.size.width- 10 - 23, 4, 29, 19);
        self.videoSHD = imageViewSHD;
        self.videoSHD.hidden = YES;
        [self addSubview:self.videoSHD];
        UIImageView *imageViewHD = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HDIcon"]];
        imageViewHD.frame = imageViewSHD.frame;
        self.videoHD = imageViewHD;
        self.videoHD.hidden = YES;
        [self addSubview:self.videoHD];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(5, self.imageBtn.height - 53 + 5, self.imageBtn.width-1, 53)];
        UIImage *shadow = [UIImage imageNamed:@"home_itemShadow"];
        infoView.backgroundColor = [UIColor colorWithPatternImage:shadow];
        infoView.userInteractionEnabled = NO;
        [self addSubview:infoView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 37, 38, 16)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.durationLabel = timeLabel;
        [infoView addSubview:self.durationLabel];
    }
    return self;
}

- (void)setContentWithMVItem:(MVItem *)item{
    [super setContentWithMVItem:item];
    VideoType videoStatus = [item videoType];
    if (videoStatus == VideoSHD) {
        self.videoSHD.hidden = NO;
    }else if (videoStatus == VideoHD){
        self.videoHD.hidden = NO;
    }else{
        
    }
    self.durationLabel.text = [NSString stringWithFormat:@"%@",[item getVidepDuration]];
//    [self.durationLabel sizeToFit];
}

//- (void)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
