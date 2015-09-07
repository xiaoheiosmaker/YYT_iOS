//
//  SideMenuView.h
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuCell.h"
#import "SideMenuItem.h"

@class SideMenuView;
@protocol SideMenuViewDelegate <NSObject>
- (void)sideMenuView:(SideMenuView*)menuView clickedDownloadMV:(id)sender;
- (void)sideMenuView:(SideMenuView*)menuView clickedCollectMV:(id)sender;
- (void)sideMenuView:(SideMenuView*)menuView clickedCollectML:(id)sender;
- (void)sideMenuView:(SideMenuView*)menuView clickedMyML:(id)sender;
- (void)sideMenuView:(SideMenuView*)menuView clickedOrderArtist:(id)sender;
@end

@interface SideMenuView : UIView <SideMenuCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(assign,nonatomic) id<SideMenuViewDelegate> delegate;
@property(retain,nonatomic) IBOutlet UITableView* tbv;
@end
