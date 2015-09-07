//
//  ImagesButton.m
//  YYTHD
//
//  Created by IAN on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ExButton.h"

@implementation ExButton
{
    BOOL _exSelected;
    
    UIImage *_normalImage;
    UIImage *_highlightedImage;
    
    UIImage *_exImage;
    UIImage *_exlightedImage;
}

- (void)setNormalImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (![self isSelected]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    _normalImage = image;
    _highlightedImage = highlightedImage;
}

- (void)setExSelectedImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if ([self exSelected]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    _exImage = image;
    _exlightedImage = highlightedImage;
}

- (void)setExSelected:(BOOL)selected
{
    if (_exSelected == selected) {
        return;
    }
    
    
    UIImage *image = nil;
    UIImage *hImage = nil;
    
    if (selected){
        image = _exImage;
        hImage = _exlightedImage;
    }
    else {
        image = _normalImage;
        hImage = _highlightedImage;
    }
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:hImage forState:UIControlStateHighlighted];
    
    _exSelected = selected;
}

- (BOOL)exSelected
{
    return _exSelected;
}

@end
