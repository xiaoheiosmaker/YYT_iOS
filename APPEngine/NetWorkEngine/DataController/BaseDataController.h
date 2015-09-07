//
//  BaseDataController.h
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssignObject.h"
#import "YYTClient.h"
#import "MTLJSONAdapter.h"

@interface BaseDataController : NSObject
{
    
}

@property (nonatomic, assign) NSInteger pageSize;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

- (NSUInteger) countOfObservers;
- (id)observerAtIndex:(NSUInteger)index;
@end
