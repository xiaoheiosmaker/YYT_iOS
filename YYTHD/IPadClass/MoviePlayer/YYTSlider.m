//
//  YYTSlider.m
//  YYTHD
//
//  Created by IAN on 13-11-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTSlider.h"

@implementation YYTSlider
{
    BOOL _shoudRejectSetProgress;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        UIImage *miniTrackImage = [UIImage imageNamed:@"player_slider_miniTrack"];
        miniTrackImage = [miniTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 4, 3)];
        //[slider setMinimumTrackImage:miniTrackImage forState:UIControlStateNormal];
        self.miniTrackImage = miniTrackImage;
        
        UIImage *maxTrackImage = [UIImage imageNamed:@"player_slider_maxTrack"];
        maxTrackImage = [maxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 4, 3)];
        //[slider setMaximumTrackImage:maxTrackImage forState:UIControlStateNormal];
        self.maxTrackImage = maxTrackImage;
        
        UIImage *thumbImage = [UIImage imageNamed:@"player_slider_thumb"];
        //[slider setThumbImage:thumbImage forState:UIControlStateNormal];
        self.thumbImage = thumbImage;
    }
    return self;
}

#pragma mark - Touch Event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    thumbRect = UIEdgeInsetsInsetRect(thumbRect, edgeInsets);
    if (CGRectContainsPoint(thumbRect, touchPoint)) {
        //点击thumb,拒绝外部设置progress,跟踪触摸事件
        _shoudRejectSetProgress = YES;
        return YES;
    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    _progress = touchPoint.x/CGRectGetWidth(self.bounds);
    if (_progress < 0) {
        _progress = 0;
    }
    if (_progress > 1) {
        _progress = 1;
    }
    [self setNeedsDisplay];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _shoudRejectSetProgress = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    _shoudRejectSetProgress = NO;
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress
{
    if (_shoudRejectSetProgress) {
        return;
    }
    
    if (progress < 0 || progress > 1) {
        return;
    }
    
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)setBufferProgress:(CGFloat)bufferProgress
{
    if (_bufferProgress != bufferProgress) {
        _bufferProgress = bufferProgress;
        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

#pragma mark - draw
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGFloat height = 8;
    
    CGRect trackRect = bounds;
    trackRect.size.height = height;
    int y = (CGRectGetHeight(bounds)-height)/2;
    trackRect.origin.y += y;
    return trackRect;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds
{
    CGSize thumbSize = self.thumbImage.size;
    int x = CGRectGetMinX(bounds) + CGRectGetWidth(bounds)*self.progress - thumbSize.width/2;
    int y = CGRectGetMinY(bounds) + (CGRectGetHeight(bounds)-thumbSize.height)/2;
    
    CGRect thumbRect = CGRectMake(x, y, thumbSize.width, thumbSize.height);
    return thumbRect;
}


- (void)drawRect:(CGRect)rect
{
    CGRect trackRect = [self trackRectForBounds:rect];
    
    int x = 10;
    UIEdgeInsets thumbEdge = UIEdgeInsetsMake(0, x, 0, 9);
    CGRect thumbBounds = UIEdgeInsetsInsetRect(rect, thumbEdge);
    CGFloat width = CGRectGetWidth(thumbBounds);
    
    CGRect progressRect = trackRect;
    progressRect.size.width = x + width * self.progress;
    
    CGRect bufferRect = trackRect;
    bufferRect.size.width = CGRectGetWidth(trackRect) * self.bufferProgress;
    
    //draw maxTrack
    UIImage *maxTrackImage = self.maxTrackImage;
    [maxTrackImage drawInRect:trackRect];
    
    //buffer
    UIImage *bufferImage = self.maxTrackImage;
    [bufferImage drawInRect:bufferRect];
    
    //progress
    UIImage *miniTrackImage = self.miniTrackImage;
    [miniTrackImage drawInRect:progressRect];
    
    //thumb
    CGRect thumbRect = [self thumbRectForBounds:thumbBounds];
    UIImage *thumbImage = self.thumbImage;
    [thumbImage drawInRect:thumbRect];
}

@end
