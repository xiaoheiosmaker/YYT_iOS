//
//  PageDetaiView.m
//  YYTHD
//
//  Created by ssj on 13-11-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PageDetaiView.h"
#import "FontPageItem.h"

@implementation PageDetaiView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat x = 5;
        CGFloat y = 0;
        
        UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        CGSize shadowOffset = {0, 1};
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 43, 43)];
        self.popImageView = imageView;
        [self addSubview:self.popImageView];
        y += 45;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 1000, 20)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        self.musicLabel = label;
        [self addSubview:self.musicLabel];
        label.shadowColor = shadowColor;
        label.shadowOffset = shadowOffset;
        
        y += 20;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 1000, 20)];
        label.textColor = [UIColor yytGreenColor];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        self.descriptionLabel = label;
        [self addSubview:self.descriptionLabel];
        label.shadowColor = shadowColor;
        label.shadowOffset = shadowOffset;
    }
    return self;
}

- (void)setContentWithFontPageItem:(FontPageItem *)item{
//    self.artistLabel.text = item.description;
    self.musicLabel.text = item.title;
    self.descriptionLabel.text = item.description;
    if ([item.type isEqualToString:@"VIDEO"]) {
        self.popImageView.image = IMAGE(@"VIDEO");
    }else if ([item.type isEqualToString:@"PLAYLIST"]){
        self.popImageView.image = IMAGE(@"PLAYLIST");
    }else if ([item.type isEqualToString:@"AD"]){
        self.popImageView.image = IMAGE(@"AD");
    }else if ([item.type isEqualToString:@"ACTIVITY"]){
        self.popImageView.image = IMAGE(@"ACTIVITY");
    }else if ([item.type isEqualToString:@"ANNOUNCEMENT"]){
        self.popImageView.image = IMAGE(@"ANNOUNCEMENT");
    }else if ([item.type isEqualToString:@"PROGRAM"]){
        self.popImageView.image = IMAGE(@"PROGRAM");
    }else if ([item.type isEqualToString:@"WEEK_MAIN_STAR"]){
        self.popImageView.image = IMAGE(@"WEEK_MAIN_STAR");
    }
}

+ (CGSize)defaultSize{
    return CGSizeMake(260, 125);
}

+ (instancetype)defaultSizeView{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    return [[self alloc] initWithFrame:defaultFrame];
}

@end
