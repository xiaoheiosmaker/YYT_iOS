//
//  SideMenuCell.h
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SideMenuCell;
@protocol SideMenuCellDelegate <NSObject>
- (void) sideMenuCell:(SideMenuCell*)cell clickedButton:(id)sender;
@end

@interface SideMenuCell : UITableViewCell
{
    
}
@property(assign,nonatomic) id <SideMenuCellDelegate> delegate;
@property(retain,nonatomic) IBOutlet UIButton* itemButton;
@end
