//
//  ArtistMVCell.m
//  YYTHD
//
//  Created by ssj on 13-10-28.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistMVCell.h"
#import "MVItemView.h"

@implementation ArtistMVCell

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
- (void)resetContent:(NSArray *)mvArray
{
    if ([mvArray count] > 0) {
        
        for(UIView *v in self.subviews){
            if ([v isKindOfClass:[MVItemView class]]) {
                [v removeFromSuperview];
            }
        }
        
//        MVItemView *mvItemView = [MVItemView defaultSizeView];
        
        
    }
    
}


@end
