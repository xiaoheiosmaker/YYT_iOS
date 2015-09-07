//
//  CustomPlaceholderTextField.m
//  YYTHD
//
//  Created by 崔海成 on 2/18/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "CustomPlaceholderTextField.h"

@implementation CustomPlaceholderTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawPlaceholderInRect:(CGRect)rect
{
    UIColor *curColor = self.placeHolderColor ?: [UIColor colorWithWhite:1.0 alpha:0.6];
    
    [curColor setFill];
    CGSize drawSize = [[self placeholder] sizeWithFont:self.font];
    CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - drawSize.height) / 2.0, rect.size.width, rect.size.height);
    [[self placeholder] drawInRect:drawRect withFont:self.font];
}

@end
