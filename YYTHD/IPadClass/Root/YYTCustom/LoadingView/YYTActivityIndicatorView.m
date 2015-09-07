//
//  YYTActivityIndicatorView.m
//  YYTHD
//
//  Created by shuilin on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTActivityIndicatorView.h"

@interface YYTActivityIndicatorView ()
{
    
}

@property(retain,nonatomic) YYTActivitySubView* currentView;

- (void)doInit;
- (void)reloadSubView;
@end

@implementation YYTActivityIndicatorView

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

- (void)awakeFromNib
{
    [self doInit];
}

- (void)doInit
{
    self.hidesWhenStopped = YES;
    self.supportCancel = YES;
    self.supportTip = YES;
    
    self.hidden = self.hidesWhenStopped;
    
    [self reloadSubView];
}

- (void)reloadSubView
{
    NSUInteger index = 0;
    if(self.supportTip && self.supportCancel)
    {
        index = 0;
    }
    else if(self.supportTip && !self.supportCancel)
    {
        index = 1;
    }
    else if(!self.supportTip && self.supportCancel)
    {
        index = 2;
    }
    else if(!self.supportTip && !self.supportCancel)
    {
        index = 3;
    }
    
    [self.currentView removeFromSuperview];
    
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"YYTActivitySubView" owner:self options:nil];
    self.currentView = [views objectAtIndex:index];
    self.currentView.delegate = self.delegate;  //传下去
    [self addSubview:self.currentView];
    
    [self sizeToFit];
}

- (void)setDelegate:(id<YYTActivitySubViewDelegate>)delegate
{
    _delegate = delegate;
    self.currentView.delegate = delegate;
}

- (void)setTipText:(NSString *)tipText
{
    self.currentView.tipLabel.text = tipText;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    self.currentView.activityIndicatorView.hidesWhenStopped = hidesWhenStopped;
}

- (void)setSupportTip:(BOOL)supportTip
{
    _supportTip = supportTip;
    
    [self reloadSubView];
}

- (void)setSupportCancel:(BOOL)supportCancel
{
    _supportCancel = supportCancel;
    
    [self reloadSubView];
}

- (void)startAnimating
{
    self.hidden = NO;
    [self.currentView.activityIndicatorView startAnimating];
}

- (void)stopAnimating
{
    if(self.hidesWhenStopped)
    {
        self.hidden = YES;
    }
    [self.currentView.activityIndicatorView stopAnimating];
}

- (BOOL)isAnimating
{
    return self.currentView.activityIndicatorView.isAnimating;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize asize = self.currentView.frame.size;
    return asize;
}

@end
