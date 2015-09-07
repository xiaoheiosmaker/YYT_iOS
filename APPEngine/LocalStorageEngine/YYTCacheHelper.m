//
//  YYTCacheHelper.m
//  YYTHD
//
//  Created by IAN on 13-11-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTCacheHelper.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>

static UIImageView *SharedimageView = nil;

@implementation YYTCacheHelper
+ (void)initialize
{
    SharedimageView = [[UIImageView alloc] init];
}

+ (UIImage *)cachedImageWithURL:(NSURL *)url
{
    BOOL exist = [[SDWebImageManager sharedManager] diskImageExistsForURL:url];
    if (exist) {
        UIImageView *imageView = SharedimageView;
        [imageView setImageWithURL:url];
        return imageView.image;
    }
    
    return nil;
}

@end
