//
//  YYTActivitySubView.m
//  YYTHD
//
//  Created by shuilin on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTActivitySubView.h"

@interface YYTActivitySubView ()
{
    
}

- (IBAction)clickedCancelButton:(id)sender;
@end

@implementation YYTActivitySubView

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
    
}

- (IBAction)clickedCancelButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(yytActivitySubView:clickedCancel:)])
    {
        [self.delegate yytActivitySubView:self clickedCancel:sender];
    }
}

@end
