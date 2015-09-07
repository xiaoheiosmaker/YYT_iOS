//
//  YYTUILabel.m
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTUILabel.h"

@implementation YYTUILabel

@synthesize textSelectedColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)theSelected
{
    if (_selected == theSelected) {
        return;
    }
    
    _selected = theSelected;
    
    if (_selected) {
        _oldColor = self.textColor;
        self.textColor = self.textSelectedColor;
    }else {
        self.textColor = _oldColor;
    }
}

- (BOOL)selected
{
    return _selected;
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
