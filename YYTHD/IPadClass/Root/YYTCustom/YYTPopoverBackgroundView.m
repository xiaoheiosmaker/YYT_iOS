//
//  YYTPopoverBackgroundView.m
//  YYTHD
//
//  Created by IAN on 13-11-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPopoverBackgroundView.h"

static CGFloat const ArrowBase = 24;
static CGFloat const ArrowHeight = 12;
static CGFloat const RectRadius = 4;
static CGFloat const CPOffset = 1.8;
static CGFloat const ArrowCurvature = 6.0f;

@implementation YYTPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [[UIColor clearColor] CGColor];
    }
    return self;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

+ (CGFloat)arrowHeight
{
    return ArrowHeight;
}

+ (CGFloat)arrowBase
{
    return ArrowBase;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Build the popover path
    CGRect frame = [self clipRect:rect];
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float width = frame.size.width;
    float height = frame.size.height;
    
    float radius = RectRadius; //Radius of the curvature.
    
    float cpOffset = CPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(xMin, yMin + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    //In this case, the arrow is located between LT2 and RT1
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        CGPoint arrowPoint = CGPointMake(width/2 + self.arrowOffset, 0);
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - ArrowBase/2, yMin)];//left side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - ArrowBase/2 + ArrowCurvature, yMin) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + ArrowBase/2, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + ArrowBase/2 - ArrowCurvature, yMin)];//right side
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    
    //In this case, the arrow is located between RT2 and RB1
    if (self.arrowDirection == UIPopoverArrowDirectionRight) {
        CGPoint arrowPoint = CGPointMake(CGRectGetWidth(self.frame), height/2 + self.arrowOffset);
        [popoverPath addLineToPoint:CGPointMake(xMax, arrowPoint.y - ArrowBase/2)];//left side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(xMax, arrowPoint.y - ArrowBase/2 + ArrowCurvature) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(xMax, arrowPoint.y + ArrowBase/2) controlPoint1:arrowPoint controlPoint2:CGPointMake(xMax, arrowPoint.y + ArrowBase/2 - ArrowCurvature)];//right side
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    //In this case, the arrow is located somewhere between LB1 and RB2
    if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        CGPoint arrowPoint = CGPointMake(width/2 + self.arrowOffset, CGRectGetHeight(self.frame));
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + ArrowBase/2, yMax)];//right side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + ArrowBase/2 - ArrowCurvature, yMax) controlPoint2:arrowPoint];//arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - ArrowBase/2, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - ArrowBase/2 + ArrowCurvature, yMax)];
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    
    //In this case, the arrow is located between LB2 and LT1
    if (self.arrowDirection == UIPopoverArrowDirectionLeft) {
        CGPoint arrowPoint = CGPointMake(0, height/2 + self.arrowOffset);
        [popoverPath addLineToPoint:CGPointMake(xMin, arrowPoint.y + ArrowBase/2)];//right side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(xMin, arrowPoint.y + ArrowBase/2 - ArrowCurvature) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(xMin, arrowPoint.y - ArrowBase/2) controlPoint1:arrowPoint controlPoint2:CGPointMake(xMin, arrowPoint.y - ArrowBase/2 + ArrowCurvature)];//left side
    }
    
    [popoverPath closePath];
    
    [[UIColor yytTransparentBlackColor] setFill];
    [popoverPath fill];
    
    /*
    //Draw border if we need to
    //The border is done last because it needs to be drawn on top of everything else
    if (kDrawBorder) {
        [kBorderColor setStroke];
        popoverPath.lineWidth = kBorderWidth;
        [popoverPath stroke];
    }
    */
}


/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //根据arrowDirection得到contentRect
    CGRect contentRect = [self clipRect:rect];
    
    CGFloat x = contentRect.origin.x;
    CGFloat y = contentRect.origin.y;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    const CGFloat halfArrowBase = ArrowBase/2;
    
    // 圆角半径
    const CGFloat radius = RectRadius;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, x+radius, y);
    
    // up arrow
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        CGFloat offset = width/2 + self.arrowOffset;
        CGContextAddLineToPoint(context, offset-halfArrowBase, y);
        CGContextAddLineToPoint(context, offset, 0);
        CGContextAddLineToPoint(context, offset+halfArrowBase, y);
    }
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, x + width - radius, y);
    CGContextAddArc(context, x + width - radius, y + radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // right arrow
    if (self.arrowDirection == UIPopoverArrowDirectionRight) {
        CGFloat offset = height/2 + self.arrowOffset;
        CGContextAddLineToPoint(context, width, offset-halfArrowBase);
        CGContextAddLineToPoint(context, rect.size.height, offset);
        CGContextAddLineToPoint(context, width, offset+halfArrowBase);
    }
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, x + width, y + height - radius);
    CGContextAddArc(context, x + width - radius, y+ height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // down arrow
    if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        CGFloat offset = width/2 + self.arrowOffset;
        CGContextAddLineToPoint(context, offset+halfArrowBase, height);
        CGContextAddLineToPoint(context, offset, rect.size.height);
        CGContextAddLineToPoint(context, offset-halfArrowBase, height);
    }
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, x + radius, y + height);
    CGContextAddArc(context, x + radius, y + height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // left arrow
    if (self.arrowDirection == UIPopoverArrowDirectionLeft) {
        CGFloat offset = height/2 + self.arrowOffset;
        CGContextAddLineToPoint(context, x, offset+halfArrowBase);
        CGContextAddLineToPoint(context, 0, offset);
        CGContextAddLineToPoint(context, x, offset-halfArrowBase);
    }

    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, x, y+radius);
    CGContextAddArc(context, x+radius, y+radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.8);
    CGContextDrawPath(context, kCGPathFill);
}
*/

- (CGRect)clipRect:(CGRect)rect
{
    CGPoint origin = rect.origin;
    CGSize size = rect.size;
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
        {
            origin.y += ArrowHeight;
            //no break
        }
        case UIPopoverArrowDirectionDown:
        {
            size.height -= ArrowHeight;
            break;
        }
        case UIPopoverArrowDirectionLeft:
        {
            origin.x += ArrowHeight;
            //no break
        }
        case UIPopoverArrowDirectionRight:
        {
            size.width -= ArrowHeight;
            break;
        }
        default:
            break;
    }
    
    CGRect clipedRect = {origin, size};//CGRectMake(origin.x, origin.y, size.width, size.height);
    return clipedRect;
}

@end
