//
//  PlaceView.m
//  YYTHD
//
//  Created by shuilin on 11/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "PlaceView.h"

@interface PlaceView ()
{
    
}
@property(retain,nonatomic) IBOutlet UIImageView* tipImageView;
@property(retain,nonatomic) IBOutlet UILabel* tipLabel;

@end

@implementation PlaceView

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

- (void)setTipImage:(UIImage *)tipImage
{
    _tipImage = tipImage;
    
    self.tipImageView.image = tipImage;
}

- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    
    self.tipLabel.text = tipText;
}

@end
