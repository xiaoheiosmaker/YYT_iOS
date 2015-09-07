//
//  NewsImageViewController.h
//  YYTHD
//
//  Created by IAN on 14-3-18.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsImageViewController : UIViewController

- (void)setAnimationStartView:(UIView *)view;
- (void)loadImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)image;

@end
