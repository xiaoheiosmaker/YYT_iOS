//
//  SingleGroup.m
//  YYTHD
//
//  Created by shuilin on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SingleGroup.h"

@interface SingleGroup ()
{
    
}

@end

@implementation SingleGroup

- (id)init
{
    self = [super init];
    if(self)
    {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.items = nil;
    self.selectedItem = nil;
}

- (void)addItem:(id)item
{
    [self.items addObject:item];
}

- (void)selectItem:(id)item
{
}
@end
