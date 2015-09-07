//
//  SearchCell.m
//  YYTHD
//
//  Created by ssj on 13-11-6.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"cell_sel_background"];
    self.selectedBackgroundView = imageView;
    self.contentLabel.highlightedTextColor = [UIColor whiteColor];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
//    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    if (height * scale_screen == 1024) {
         self.lineBreadImage.height = 0.5;
    }
   
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
