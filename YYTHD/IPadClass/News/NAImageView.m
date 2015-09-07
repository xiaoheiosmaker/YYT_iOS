//
//  NAImageView.m
//  YYTHD
//
//  Created by IAN on 14-3-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NAImageView.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation NAImageView
{
    id<SDWebImageOperation> _operation;
    CALayer *_imageLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;

    }
    return self;
}

- (CALayer *)imageLayer
{
    if (_imageLayer == nil) {
        CALayer *layer = [[CALayer alloc] init];
        layer.bounds = self.bounds;
        layer.anchorPoint = CGPointZero;
        layer.position = CGPointZero;
        layer.contentsGravity = kCAGravityBottomLeft;
        [self.layer addSublayer:layer];
        _imageLayer = layer;
    }
    
    return _imageLayer;
}


- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        
        if (!image && _operation) {
            [self cancelCurrentLoad];
        }
        
        CALayer *layer = [self imageLayer];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer.contents = (__bridge id)([image CGImage]);
        if (image) {
            CGFloat scale = CGRectGetWidth(self.frame)/image.size.width;
            layer.transform = CATransform3DMakeScale(scale, scale, 1);
        }
        [CATransaction commit];
    }
}

- (void)setImageWithURL:(NSURL *)url
{
    if (_operation) {
        [self cancelCurrentLoad];
    }
    
    if (url)
    {
        __weak NAImageView *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
             {
                 if (!wself) return;
                 dispatch_main_sync_safe(^
                                         {
                                             __strong NAImageView *sself = wself;
                                             if (!sself) return;
                                             if (image)
                                             {
                                                 [sself setImage:image];
                                             }
                                         });
             }];
        _operation = operation;
    }
}

- (void)cancelCurrentLoad
{
    [_operation cancel];
    _operation = nil;
}

@end
