//
//  UITableView+Selection.m
//  YYTHD
//
//  Created by 崔海成 on 12/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "UITableView+Selection.h"

@implementation UITableView (Selection)
- (BOOL)isAllSelected
{
    NSArray *selectedRows = [self indexPathsForSelectedRows];
    return [self numberOfRowsInSection:0] == [selectedRows count];
}

- (void)selectAll
{
    int rows = [self numberOfRowsInSection:0];
    for (int i = 0; i < rows; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        [self selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)deselectAll
{
    int rows = [self numberOfRowsInSection:0];
    for (int i = 0; i < rows; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        [self deselectRowAtIndexPath:ip animated:NO];
    }
}
@end
