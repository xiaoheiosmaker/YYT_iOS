//
//  VideoQualityCell.m
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "VideoQualityCell.h"

@interface VideoQualityCell ()
{
    
}
@property(retain,nonatomic) SingleButtonGroup* singleButtonGroup;
@property(retain,nonatomic) IBOutlet UIButton* normalButton;
@property(retain,nonatomic) IBOutlet UIButton* button540;

- (IBAction)clickNormalButton:(id)sender;
- (IBAction)click540Button:(id)sender;

@end

@implementation VideoQualityCell

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

- (void)awakeFromNib
{
    self.singleButtonGroup = [[SingleButtonGroup alloc] init];
    [self.singleButtonGroup addItem:self.normalButton];
    [self.singleButtonGroup addItem:self.button540];
}

- (void)setType:(VideoQualityType)type
{
    _type = type;
    
    if(type == Normal_Video)
    {
        [self.singleButtonGroup selectItem:self.normalButton];
    }
    else if(type == P540_Video)
    {
        [self.singleButtonGroup selectItem:self.button540];
    }
}

- (IBAction)clickNormalButton:(id)sender
{
    [self.singleButtonGroup selectItem:sender];
    [self.delegate videoQualityCell:self clickedNormalButton:self];
}

- (IBAction)click540Button:(id)sender
{
    [self.singleButtonGroup selectItem:sender];
    [self.delegate videoQualityCell:self clicked540Button:sender];
}

@end
