//
//  SingleButtonGroup.m
//  YYTHD
//
//  Created by shuilin on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SingleButtonGroup.h"

@implementation SingleButtonGroup

- (void)selectItem:(id)item
{
    if([self.items indexOfObject:item] == NSNotFound)
    {
        return;
    }
    
    for(UIButton* button in self.items)
    {
        button.selected = NO;
    }
    
    UIButton* button = item;
    button.selected = YES;
    
    self.selectedItem = item;
}

@end
