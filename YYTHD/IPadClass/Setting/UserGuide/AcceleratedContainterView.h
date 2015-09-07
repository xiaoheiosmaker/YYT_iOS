//
//  AcceleratedContainterView.h
//  test-iPad
//
//  Created by IAN on 13-12-24.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceleratedContainterView : UIView
{
    NSMutableArray *_settedSubviews;
}

- (void)prepareToShow;

- (void)accelerateWithOffset:(CGFloat)offset;


@end
