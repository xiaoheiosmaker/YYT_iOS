//
//  SideMenuCell.m
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SideMenuCell.h"

@interface SideMenuCell ()
{
    
}
- (IBAction)clickItemButton:(id)sender;
@end

@implementation SideMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickItemButton:(id)sender
{
    [self.delegate sideMenuCell:self clickedButton:sender];
}
@end
