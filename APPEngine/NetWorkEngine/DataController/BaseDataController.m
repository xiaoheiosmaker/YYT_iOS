//
//  BaseDataController.m
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"

#define pageSizeDef 20

@interface BaseDataController ()
{
    
}
@property(retain,nonatomic) NSMutableArray* observers;
@end

@implementation BaseDataController
{
    
}

- (id)init
{
    if(self = [super init]) {
        _pageSize = pageSizeDef;
        self.observers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
    self.observers = nil;
}

- (void)addObserver:(id)observer
{
    if(observer == nil)
        return;
    
    for(AssignObject* temp in self.observers)
    {
        if(observer == temp.object)//已经存在
            return;
    }
    
    AssignObject* temp = [[AssignObject alloc] init];
    temp.object = observer;
    
    [self.observers addObject:temp];
}

- (void)removeObserver:(id)observer
{
    if(observer == nil)
        return;
    
    for(AssignObject* temp in self.observers)
    {
        if(observer == temp.object)
        {
            [self.observers removeObject:temp];
        }
    }
}

- (NSUInteger) countOfObservers
{
    return [self.observers count];
}

- (id)observerAtIndex:(NSUInteger)index
{
    if(index < [self countOfObservers])
    {
        AssignObject* temp = [self.observers objectAtIndex:index];
        return temp.object;
    }
    
    return nil;
}

@end
