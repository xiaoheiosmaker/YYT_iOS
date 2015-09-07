//
//  ImagesButton.h
//  YYTHD
//
//  Created by IAN on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExButton : UIButton

- (void)setExSelected:(BOOL)selected;
- (BOOL)exSelected;

- (void)setNormalImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
- (void)setExSelectedImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

@end
