//
//  YYTUIButton.m
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTUIButton.h"

@implementation YYTUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (UIButton*)configureForBackButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action
                                   normalImg:(UIImage*)normalImg clickedImg:(UIImage*)clickedImg
{
	// Experimentally determined
	CGFloat padTRL[3] = {6, 8, 12};
    
	// Text must be put in its own UIView, s.t. it can be positioned to mimic system buttons
	UILabel* label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:12];
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(0, 1);
	label.text = title;
	[label sizeToFit];
    
	// The underlying art files must be added to the project
	UIImage* norm = [normalImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	UIImage* click = [clickedImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[self setImage:norm forState:UIControlStateNormal];
    [self setImage:click forState:UIControlStateHighlighted];
    //	[self setBackgroundImage:norm forState:UIControlStateHighlighted];
	[self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
	// Calculate dimensions
	CGSize labelSize = label.frame.size;
	CGFloat controlWidth = labelSize.width+padTRL[1]+padTRL[2];
	controlWidth = controlWidth>=norm.size.width?controlWidth:norm.size.width;
    
	// Assemble and size the views
	self.frame = CGRectMake(0, 0, controlWidth, 30);
	[self addSubview:label];
	label.frame = CGRectMake(padTRL[2], padTRL[0], labelSize.width, labelSize.height);
    
	// Clean up
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

@end
