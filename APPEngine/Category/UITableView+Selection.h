//
//  UITableView+Selection.h
//  YYTHD
//
//  Created by 崔海成 on 12/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (Selection)
- (BOOL)isAllSelected;
- (void)selectAll;
- (void)deselectAll;
@end
