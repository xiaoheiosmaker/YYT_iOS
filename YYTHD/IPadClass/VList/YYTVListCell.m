//
//  YYTVListCell.m
//  YYTHD
//
//  Created by ssj on 13-10-16.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTVListCell.h"

@implementation YYTVListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mvItemView = [[MVItemView alloc] initWithFrame:CGRectMake(0, 5, 250, 198)];
        [self addSubview:self.mvItemView];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
