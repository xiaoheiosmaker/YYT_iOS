//
//  AcceleratedItemView.h
//  test-iPad
//
//  Created by IAN on 13-12-24.
//  Copyright (c) 2013年 YinYueTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceleratedItemView : UIImageView
{
    CGRect _orginFrame;
}

@property (nonatomic, assign) CGFloat factor;

- (void)accelerateWithOffset:(CGFloat)offset;

@end
