//
//  IconLabel.m
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "IconLabel.h"
#import "UIColor+Generator.h"

@interface IconLabel ()
{
    __weak UIImageView *iconImageView;
    __weak UILabel *mainLabel;
}
@end

@implementation IconLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 20, 20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:imageView];
        iconImageView = imageView;
        
        UIFont *font = [UIFont systemFontOfSize:12];
        frame = CGRectMake(21, 0, 98, 21);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = font;
        label.textColor = [UIColor yytGrayColor];
        [self addSubview:label];
        mainLabel = label;
    }
    return self;
}

- (void)setIconImageName:(NSString *)iconImageName
{
    UIImage *image = iconImageView ? [UIImage imageNamed:iconImageName] : nil;
    iconImageView.image = image;
}

- (void)setText:(NSString *)text
{
    mainLabel.text = text;
}

@end
