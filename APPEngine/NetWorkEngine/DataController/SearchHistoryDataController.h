//
//  SearchHistoryDataController.h
//  YYTHD
//
//  Created by ssj on 13-11-4.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchHistory.h"
#import <CoreData/CoreData.h>
@interface SearchHistoryDataController : NSObject{
    dispatch_queue_t queue;//历史数据持久化线程
}
@property(nonatomic) NSUInteger maxCountOfHistoryList;//比如20
@property (nonatomic, strong) NSManagedObjectContext *historyContext;

- (SearchHistory *)createEntityForHistory;

- (void)setMaxCountOfHistoryList:(NSUInteger)maxCountOfHistoryList;

- (void)configureHistoryContext;

- (void)clearHistory;

- (NSArray *)getHistoryArray;

- (void)addToHistory:(NSString *)word;

@end
