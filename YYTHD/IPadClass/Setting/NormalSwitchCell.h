//
//  NormalSwitchCell.h
//  YYTHD
//
//  Created by shuilin on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTUISwitch.h"

@class NormalSwitchCell;
@protocol NormalSwitchCellDelegate <NSObject>
- (void)normalSwitchCell:(NormalSwitchCell*)cell switched:(BOOL)bOn;
- (void)clearDataCell:(NormalSwitchCell*)cell;
@end


@interface NormalSwitchCell : UITableViewCell
{
    
}
@property(assign,nonatomic) id <NormalSwitchCellDelegate> delegate;
@property(retain,nonatomic) IBOutlet UILabel* leftLabel;
@property(retain,nonatomic) IBOutlet UIImageView* backImageView;
@property(retain,nonatomic) YYTUISwitch* switcher;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end
