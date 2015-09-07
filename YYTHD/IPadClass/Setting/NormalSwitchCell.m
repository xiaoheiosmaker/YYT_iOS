//
//  NormalSwitchCell.m
//  YYTHD
//
//  Created by shuilin on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "NormalSwitchCell.h"

@interface NormalSwitchCell ()
{
    
}
@property(retain,nonatomic) IBOutlet UIView* anchorView;
@end

@implementation NormalSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.switcher = [[YYTUISwitch alloc] initWithFrame:CGRectMake(0, 0, 67, 30)] ;
    self.switcher.on = YES;
    [self.switcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switcher];
    
    //开关按钮位置
    self.switcher.center = self.anchorView.center;
    self.clearButton.center = self.anchorView.center;
    self.clearButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clearButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clearDataCell:)]) {
        [_delegate clearDataCell:self];
    }
}

- (void)switchChanged:(id)sender
{
    YYTUISwitch* switcher = sender;
    [self.delegate normalSwitchCell:self switched:switcher.on];
}
@end
