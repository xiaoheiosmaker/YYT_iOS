//
//  GridView.m
//  YYTHD
//
//  Created by 崔海成 on 1/6/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "GridView.h"
#import "SystemSupport.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.rowNumbers = 1;
    self.columnNumbers = 1;
    self.borderWeight = 1.0;
    self.borderColor = [UIColor redColor];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat lineWidth = self.borderWeight * ([UIScreen mainScreen].scale > 1.0 ? 0.5 : 1.0);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
    CGContextAddRect(context, rect);
    NSArray *subViews = self.subviews;
    int numSubViews = [subViews count];
    for (int i = 0; i < numSubViews - 1; i++) {
        UIView *subView = [subViews objectAtIndex:i];
        CGRect frame = subView.frame;
        CGContextMoveToPoint(context, rect.origin.x, frame.origin.y + frame.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, frame.origin.y + frame.size.height);
    }
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

- (void)setRowNumbers:(NSInteger)rowNumbers
{
    _rowNumbers = rowNumbers;
    [self setNeedsDisplay];
}

- (void)setColumnNumbers:(NSInteger)columnNumbers
{
    _columnNumbers = columnNumbers;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWeight:(CGFloat)borderWeight
{
    _borderWeight = borderWeight;
    [self setNeedsDisplay];
}

@end
