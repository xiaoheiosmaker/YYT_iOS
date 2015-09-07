//
//  SingleGroup.h
//  YYTHD
//
//  Created by shuilin on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleGroup : NSObject
{
    
}
@property(retain,nonatomic) NSMutableArray* items;
@property(retain,nonatomic) id selectedItem;

- (void)addItem:(id)item;
- (void)selectItem:(id)item;
@end
