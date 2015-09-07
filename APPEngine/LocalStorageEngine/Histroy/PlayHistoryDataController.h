//
//  HistroyDataController.h
//  YYTHD
//
//  Created by IAN on 13-11-4.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
#import "PlayHistoryEntity.h"
#import "PlayHistoryEntity+Addition.h"

@class PlayHistoryEntity;
@class MVItem;
@class MLItem;

@interface PlayHistoryDataController : BaseDataController

+ (PlayHistoryDataController *)sharedInstance;
+ (void)releaseSharedInstance;

//get the histroy entities
- (NSUInteger)numberOfObjectsWithPlayHistoryType:(PlayHistoryType)type;
- (PlayHistoryEntity *)playHistoryEntityAtIndex:(NSInteger)index withType:(PlayHistoryType)type;
- (void)clearData;

- (void)reloadData;

//add histroy entities
- (void)addMVItem:(MVItem *)mvItem;
- (void)addMLItem:(MLItem *)mlItem;

@end
