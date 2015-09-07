//
//  AcceleratedContainterView.m
//  test-iPad
//
//  Created by IAN on 13-12-24.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import "AcceleratedContainterView.h"
#import "AcceleratedItemView.h"

@implementation AcceleratedContainterView

- (void)awakeFromNib
{
    [self prepareToShow];
}

- (void)prepareToShow
{
    NSArray *subviews = [self subviews];
    CGFloat factor = 1.0f / ([subviews count] -1);
    
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AcceleratedItemView *itemView = obj;
        if ([itemView isKindOfClass:[AcceleratedItemView class]]) {
            itemView.factor = idx * factor;
        }
    }];
}

- (void)accelerateWithOffset:(CGFloat)offset
{
    //负值左移，正直右移
    CGFloat itemOffset = CGRectGetMinX(self.frame) - offset;
    
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AcceleratedItemView *itemView = obj;
        if ([itemView isKindOfClass:[AcceleratedItemView class]]) {
            [itemView accelerateWithOffset:itemOffset];
        }
    }];
}


@end
