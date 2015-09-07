//
//  PlayHistoryEntity+Addition.m
//  YYTHD
//
//  Created by IAN on 13-11-5.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PlayHistoryEntity+Addition.h"

NSString * const YYTPlayHistoryEntityName = @"PlayHistoryEntity";

@implementation PlayHistoryEntity (Addition)

- (void)deleteFromContext:(NSManagedObjectContext *)context
{
    if (!self.isDeleted) {
        [context deleteObject:self];
    }
}

@end
