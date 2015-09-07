//
//  MVDescriptionView.m
//  YYTHD
//
//  Created by IAN on 13-10-12.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVDescriptionView.h"
#import "MVItem.h"

@implementation MVDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"mv_bg2"];
        
        CGFloat x = CGRectGetMinX(self.titleLabel.frame);
        CGFloat y = CGRectGetMaxY(_artistsView.frame);
        
        UIView *infoView = _infoView;
        infoView.backgroundColor = [UIColor clearColor];
        CGRect infoFrame = infoView.frame;
        infoFrame.size.height = CGRectGetHeight(frame)-CGRectGetMinY(infoView.frame)-8;
        infoView.frame = infoFrame;
        
        
        CGFloat width = CGRectGetWidth(self.titleLabel.frame);
        CGFloat height = CGRectGetHeight(infoView.frame)-8;
        
        y += 3;
        //play count
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
        imageView.image = [UIImage imageNamed:@"miniPlayIcon"];
        [infoView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+23, y, 50, 20)];
        label.textColor = [UIColor colorWithHEXColor:0xa9a6a6];
        label.font = [UIFont systemFontOfSize:12];
        [infoView addSubview:label];
        _playCountLabel = label;
        
        //comment count
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+72, y, 20, 20)];
        imageView.image = [UIImage imageNamed:@"miniCommentIcon"];
        [infoView addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(x+23+72, y, 50, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHEXColor:0xa9a6a6];
        [infoView addSubview:label];
        _commentCountLabel = label;
        
        y += 22;
        //Description
        //labelBounderView表示了label最大的显示范围，方便label自适应大小
        width += CGRectGetWidth(self.addBtn.frame);
        UIView *labelBounderView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height-y)];
        labelBounderView.clipsToBounds = YES;
        [infoView addSubview:labelBounderView];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHEXColor:0xa9a6a6];
        [labelBounderView addSubview:label];
        _descriptionLabel = label;
    }
    return self;
}

+ (CGSize)defaultSize
{
    return CGSizeMake(250, 272);
}

- (void)setContentWithMVItem:(MVItem *)item
{
    [super setContentWithMVItem:item];
    self.playCountLabel.text = [item.totalViews stringValue];
    self.commentCountLabel.text = [item.totalComments stringValue];
    self.descriptionLabel.text = item.desc;
    [self resizeDescriptionLabel];
}

- (void)resizeDescriptionLabel
{
    UILabel *label = self.descriptionLabel;
    UIView *bounderView = [label superview];
    label.frame = bounderView.bounds;
    [label sizeToFit];
    if (CGRectGetHeight(label.frame) > CGRectGetHeight(bounderView.bounds)) {
        label.frame = bounderView.bounds;
    }
}

@end
