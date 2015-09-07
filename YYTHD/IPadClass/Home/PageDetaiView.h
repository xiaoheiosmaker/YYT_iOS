//
//  PageDetaiView.h
//  YYTHD
//
//  Created by ssj on 13-11-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FontPageItem;
@interface PageDetaiView : UIView

@property (strong, nonatomic) UILabel *artistLabel;
@property (strong, nonatomic) UILabel *musicLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *popImageView;



- (void)setContentWithFontPageItem:(FontPageItem *)item;
+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;
@end
