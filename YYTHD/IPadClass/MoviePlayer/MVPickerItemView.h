//
//  MVPickerItemView.h
//  YYTHD
//
//  Created by IAN on 13-11-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVPickerItemView : UIView

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

- (void)setContentWithMVItem:(MVItem *)item;

- (void)setPlayMarkHidden:(BOOL)hidden;
- (BOOL)playMarkIsHidden;

@end
