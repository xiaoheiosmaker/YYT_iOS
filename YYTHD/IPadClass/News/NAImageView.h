//
//  NAImageView.h
//  YYTHD
//
//  Created by IAN on 14-3-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAImageView : UIView

@property (nonatomic) UIImage *image;

- (void)setImageWithURL:(NSURL *)url;

@end
