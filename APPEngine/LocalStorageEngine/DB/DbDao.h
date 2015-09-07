//
//  DbDao.h
//  KTing
//
//  Created by btxkenshin on 12-11-15.
//  Copyright (c) 2012年 酷听网. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVDownloadItem.h"

@class FMDatabaseQueue;
@class FMResultSet;


@interface DbDao : NSObject
{

}

@property (nonatomic, strong) NSString *dbFile;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;


+(DbDao *)sharedInstance;

- (void)updateDBStruct;
- (BOOL)updateDBToVersion250;




- (NSMutableArray *)getALLMVDownloadItems;

- (MVDownloadItem *)getMVDownloadItem:(NSString *)keyID;

- (void)addMVDownloadItem:(MVDownloadItem *)item;

- (void)updateMVDownloadPath:(MVDownloadItem *)item;
- (BOOL)updateMVDownItemStatus:(MVDownloadItem *)item;

- (BOOL)deleteMVDownItem:(MVDownloadItem *)item;

@end
