//
//  LoginAccountCell.h
//  YYTHD
//
//  Created by shuilin on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTUISwitch.h"

@class LoginAccountCell;
@protocol LoginAccountCellDelegate <NSObject>
- (void)loginAccountCell:(LoginAccountCell*)cell clickedLogin:(id)sender;
@end

@interface LoginAccountCell : UITableViewCell
{
    
}
@property(assign,nonatomic) id <LoginAccountCellDelegate> delegate;

@property(retain,nonatomic) IBOutlet UILabel* titleLabel;
@property(retain,nonatomic) IBOutlet UILabel* statusLabel;
@property(retain,nonatomic) IBOutlet UILabel* nickLabel;
//@property(retain,nonatomic) IBOutlet UIButton* actionButton;
@property(retain,nonatomic) YYTUISwitch* switcher;
@property(retain,nonatomic) IBOutlet UIImageView* backImageView;
@end
