//
//  PlayHistroyCell.m
//  YYTHD
//
//  Created by IAN on 13-11-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PlayHistroyCell.h"

@implementation PlayHistroyCell

- (id)initWithStyle:(PlayHistroyCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat imageWidth = 93;
        if (style == PlayHistroyCellStyleSquareImage) {
            imageWidth = 49;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, 49)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _coverImageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 6, 175, 20)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:label];
        _titleLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, 16, 175, 20)];
        label.textColor = [UIColor yytGreenColor];
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor clearColor];
        label.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
        _artistLabel = label;
        
        //self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.backgroundColor = [UIColor clearColor];
        
        //backgroundView
        static UIColor *backgroundColor = nil;
        if (!backgroundColor) {
            CGFloat red,green,blue;
            UIColor *color = [UIColor yytGreenColor];
            [color getRed:&red green:&green blue:&blue alpha:NULL];
            backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = backgroundColor;
        self.selectedBackgroundView = view;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //imageView
    int x = 5+CGRectGetMidX(self.coverImageView.bounds);
    int y = CGRectGetMidY(self.contentView.bounds);
    self.coverImageView.center = CGPointMake(x, y);
    
    x = CGRectGetMaxX(self.coverImageView.frame) + 15;
    y -= 20;
    int textWidth = CGRectGetWidth(self.contentView.frame)-x-5;
    
    CGRect frame = self.titleLabel.frame;
    frame.origin = CGPointMake(x, y);
    frame.size.width = textWidth;
    self.titleLabel.frame = frame;
    
    y += 20;
    frame = self.artistLabel.frame;
    frame.origin = CGPointMake(x, y);
    frame.size.width = textWidth;
    self.artistLabel.frame = frame;
}

@end
