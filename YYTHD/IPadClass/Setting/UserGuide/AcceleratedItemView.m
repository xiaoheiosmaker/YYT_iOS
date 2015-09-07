//
//  AcceleratedItemView.m
//  test-iPad
//
//  Created by IAN on 13-12-24.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import "AcceleratedItemView.h"

@implementation AcceleratedItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _orginFrame = frame;
    }
    return self;
}

- (void)awakeFromNib
{
    _orginFrame = self.frame;
}


- (void)accelerateWithOffset:(CGFloat)offset
{
    CGFloat factor = self.factor;
    if (offset < 0) {
        factor = 1 - factor;
    }
    
    CGFloat itemOffset = offset * factor;
    CGRect frame = _orginFrame;
    frame.origin.x += itemOffset;
    self.frame = frame;
}

@end
