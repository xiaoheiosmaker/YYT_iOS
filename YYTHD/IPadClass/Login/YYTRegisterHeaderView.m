//
//  YYTRegisterView.m
//  YYTHD
//
//  Created by 崔海成 on 12/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTRegisterHeaderView.h"

@implementation YYTRegisterHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)close:(id)sender {
    if ([self.controller respondsToSelector:@selector(close:)]) {
        [self.controller close:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
