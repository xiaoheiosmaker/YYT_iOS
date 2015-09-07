//
//  ExtraUpView.m
//  TestLoad
//
//  Created by isgoinc on 13-2-25.
//  Copyright (c) 2013年 isgoinc. All rights reserved.
//

#import "ExtraUpView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExtraUpView

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

-(void) awakeFromNib
{
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.arrowImageView.frame;
    layer.contentsGravity = kCAGravityResizeAspect;
    //layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
    layer.contents = (id)[UIImage imageNamed:@"刷新提示箭头.png"].CGImage;
    
    [[self layer] addSublayer:layer];
    
    _arrowLayer=layer;
    
    [self reset];
}

-(void) reset
{
    _state = RefreshPrelude;
    _arrowLayer.transform = CATransform3DIdentity;
    _arrowLayer.hidden = NO;
    [self.activityView stopAnimating];
    [self.tipLabel setText:@"下拉刷新"];
}

-(void) trackY:(CGFloat) y
{
    if (_state == RefreshPrelude && y < -65.0f)
    {
        _state = RefreshExceed;
        [self.tipLabel setText:@"松开加载"];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        _arrowLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        
    }
    else if (_state == RefreshExceed && y > -65.0f && y < 0.0f)
    {
        _state = RefreshPrelude;
        [self.tipLabel setText:@"下拉刷新"];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        _arrowLayer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }

}

-(void) endTrackY:(CGFloat)y
{
    if (y <= - 65.0f && _state != RefreshLoading)
    {
        _state = RefreshLoading;
        [self.tipLabel setText:@"加载中..."];
        _arrowLayer.hidden = YES;
        [self.activityView startAnimating];
        [self.delegate comeBeginUpLoading];
    }
}
@end
