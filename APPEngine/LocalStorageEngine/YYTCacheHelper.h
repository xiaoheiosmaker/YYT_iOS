//
//  YYTCacheHelper.h
//  YYTHD
//
//  Created by IAN on 13-11-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  缓存的辅助类
 */
@interface YYTCacheHelper : NSObject

/**
 *  根据图片的URL从SDImageCache中取出图片
 *
 *  @param url 图片的URL
 *
 *  @return 缓存中的image,不存在返回nil
 */
+ (UIImage *)cachedImageWithURL:(NSURL *)url;

@end
