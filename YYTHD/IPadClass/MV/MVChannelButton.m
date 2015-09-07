//
//  MVChannelButton.m
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVChannelButton.h"
#import "MVChannel.h"
#import <QuartzCore/QuartzCore.h>
#import <UIButton+WebCache.h>
#import "UIImage+GrayImage.h"

#define kMVChannelImageSize 62
@interface MVChannelButton ()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *grayImage;

@end

@implementation MVChannelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //颜色
        [self setTitleColor:[UIColor yytLightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor yytGreenColor] forState:UIControlStateSelected];
        
        //字体
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        //没有对任意大小frame做匹配
        //圆角图片处理
        self.imageView.layer.cornerRadius = kMVChannelImageSize/2;
        //self.imageView.layer.borderWidth = 3;
        //self.imageView.layer.borderColor = [[UIColor yytLightGrayColor] CGColor];
    }
    return self;
}

//convenient creator
+ (MVChannelButton *)channelButton
{
    id btn = [[self alloc] initWithFrame:CGRectMake(0, 0, kMVChannelImageSize, kMVChannelImageSize+20)];
    return btn;
}

//custom getter
- (UIImage *)grayImage
{
    if (_grayImage == nil) {
        if (self.originImage) {
            _grayImage = [self.originImage getGrayImage];
        }
    }
    return _grayImage;
}

- (void)setValueWithMVChannel:(MVChannel *)channel
{
    [self setTitle:channel.name forState:UIControlStateNormal];
    __weak MVChannelButton *weekSelf = self;
    [self setImageWithURL:channel.coverURL
                 forState:UIControlStateNormal
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    weekSelf.originImage = image;
                    if (weekSelf.isGray) {
                        [weekSelf useGrayImage:YES];
                    }
                }];
}

- (void)setGray:(BOOL)gray
{
    if (_gray != gray) {
        _gray = gray;
        [self useGrayImage:gray];
    }
}

- (void)useGrayImage:(BOOL)gray
{
    UIImage *image = self.originImage;
    if (gray && image) {
        image = self.grayImage;
    }
    
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    imageView.frame = CGRectMake(0, 0, kMVChannelImageSize, kMVChannelImageSize);
    imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);
    label.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds), 20);
    label.textAlignment = NSTextAlignmentCenter;
}

@end
