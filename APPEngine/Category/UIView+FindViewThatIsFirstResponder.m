//
//  UIView+UIView_FindViewThatIsFirstResponder.m
//  YYTHD
//
//  Created by 崔海成 on 12/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "UIView+FindViewThatIsFirstResponder.h"

@implementation UIView (FindViewThatIsFirstResponder)
- (UIView *)firstResponder
{
    if ([self isFirstResponder]) return self;
    
    NSArray *subviews = self.subviews;
    UIView *firstResponder;
    for (UIView *subview in subviews) {
        firstResponder = [subview firstResponder];
        if (firstResponder) break;
    }
    return firstResponder;
}
@end
