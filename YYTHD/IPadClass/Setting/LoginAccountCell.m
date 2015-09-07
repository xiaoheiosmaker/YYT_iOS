//
//  LoginAccountCell.m
//  YYTHD
//
//  Created by shuilin on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "LoginAccountCell.h"

@interface LoginAccountCell ()
{
    
}
@property(retain,nonatomic) IBOutlet UIView* anchorView;

- (IBAction)clickedLogin:(id)sender;
@end

@implementation LoginAccountCell

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
    self.switcher = [[YYTUISwitch alloc] initWithFrame:CGRectMake(0, 0, 67, 30)];
    self.switcher.on = YES;
    [self.switcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switcher];
    
    //开关按钮位置
    self.switcher.center = self.anchorView.center;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickedLogin:(id)sender
{
    [self.delegate loginAccountCell:self clickedLogin:sender];
}

- (void)switchChanged:(id)sender
{
    //YYTUISwitch* switcher = sender;
    //NSLog(@":%d",switcher.on);
    [self.delegate loginAccountCell:self clickedLogin:sender];
}

@end
