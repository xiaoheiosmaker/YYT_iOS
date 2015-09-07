//
//  PlayHistoryEntity+Addition.h
//  YYTHD
//
//  Created by IAN on 13-11-5.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PlayHistoryEntity.h"

extern NSString * const YYTPlayHistoryEntityName;

typedef NS_ENUM(NSInteger, PlayHistoryType) {
    PlayHistoryMVType = 0,
    PlayHistoryMLType,
};

@interface PlayHistoryEntity (Addition)

- (void)deleteFromContext:(NSManagedObjectContext *)context;

@end
