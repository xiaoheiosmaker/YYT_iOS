//
//  YueDanItemView.m
//  YYTHD
//
//  Created by 崔海成 on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLItemView.h"

@implementation MLItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.loadingIndicator.center = self.coverImageView.center;
}

@end
