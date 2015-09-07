//
//  SingleViewGroup.m
//  YYTHD
//
//  Created by shuilin on 11/4/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SingleViewGroup.h"

@implementation SingleViewGroup

- (void)selectItem:(id)item
{
    for(UIView* view in self.items)
    {
        view.hidden = YES;
    }
    
    UIView* view = item;
    view.hidden = NO;
    self.selectedItem = item;
}

@end
