//
//  MVCell.h
//  YYTHD
//
//  Created by 崔海成 on 12/13/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVItem.h"
extern const int MVCellHeight;

@interface MVCell : UITableViewCell
@property (nonatomic, weak) id controller;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) MVItem *item;
@end
