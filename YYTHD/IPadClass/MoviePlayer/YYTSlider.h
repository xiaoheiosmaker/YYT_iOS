//
//  YYTSlider.h
//  YYTHD
//
//  Created by IAN on 13-11-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTSlider : UIControl

@property (nonatomic, strong) UIImage *miniTrackImage;
@property (nonatomic, strong) UIImage *maxTrackImage;
@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat bufferProgress;

@end
