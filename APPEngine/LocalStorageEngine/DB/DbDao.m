//
//  DbDao.m
//  SqliteTest
//
//  Created by foxwang on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DbDao.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"



static DbDao *gSharedInstance = nil;

@implementation DbDao
@synthesize dbFile;
@synthesize dbQueue;

+(DbDao *)sharedInstance
{
    @synchronized(self)
    {
        if (gSharedInstance == nil)
            gSharedInstance = [[DbDao alloc] init];
    }
    return gSharedInstance;    
}

- (void)dealloc
{
    self.dbQueue = nil;
}

- (id)init
{

    self = [super init];
    if (self)
    {
        self.dbFile = [RootDirectory stringByAppendingPathComponent:DBNAME];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbFile];
    }
    return  self;
}

- (BOOL)setDataStructureVersion:(int)version
{
    __block BOOL success = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE yyt_sys SET db_version = ?,lastupdatedtime = ?";
        success = [db executeUpdate:sql,[NSNumber numberWithInt:version],[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]];
        //TTDINFO(@"jieguo:%@", [NSNumber numberWithBool:success]);
    }]; 
    return success;
}

- (int)getDataStructureVersion
{
    __block int version = 0; 
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from yyt_sys limit 1";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            version = [rs intForColumn:@"db_version"];
        }
    }];
    
    return version;
}


- (BOOL)createTableSys
{
    __block BOOL success = NO;
    
    //CREATE TABLE Subscription (OrderId VARCHAR(32) PRIMARY KEY ,UserName VARCHAR(32) NOT NULL ,ProductId VARCHAR(16) NOT NULL);
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"CREATE TABLE yyt_sys (serial int(11) PRIMARY KEY ,db_version int(11) DEFAULT(0) NOT NULL, current_version int(11) DEFAULT(0) NOT NULL, lastupdatedtime int(11));";
        success = [db executeUpdate:sql];
        //TTDINFO(@"createTableSys:%@", [NSNumber numberWithBool:success]);
        
        if (success) {
            NSString *sql = @"insert into yyt_sys(db_version,current_version,lastupdatedtime) values (?,?,?)";
            success = [db executeUpdate:sql,[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]];
            //TTDINFO(@"insert ktingsys:%@", [NSNumber numberWithBool:success]);
        }
        
    }];
    
    return success;
}

- (BOOL)updateDBToVersion250
{
    //ALTER TABLE Subscription ADD COLUMN Key BLOB
    __block BOOL success = NO;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"ALTER TABLE chapter_down_info ADD COLUMN audio_times VARCHAR(100)";
        success = [db executeUpdate:sql];
        //TTDINFO(@"updateDBToVersion250:%@", [NSNumber numberWithBool:success]);
    }];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"ALTER TABLE listen_history ADD COLUMN section_index integer DEFAULT 1";
        success = [db executeUpdate:sql];
        
        //TTDINFO(@"updateDBToVersion250:%@", [NSNumber numberWithBool:success]);
    }];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"ALTER TABLE listen_history ADD COLUMN is_local integer DEFAULT 0";
        success = [db executeUpdate:sql];
        
        //TTDINFO(@"updateDBToVersion250:%@", [NSNumber numberWithBool:success]);
    }];
    
    return success;
}

- (void)updateDBStruct
{
    
    //[self updateDBListenHistoryTest];
    
    NSUInteger version = [self getDataStructureVersion];
    
    if (version == 0) {//还没有sys表，需要创建
        
        [self createTableSys];
        
        version = 1;
    }
    
//    if (version < 250) {
//        
//        [self updateDBToVersion250];
//        // upgrade your SQLite database data structure to version 1
//        
//        version = 250;
//        
//    }
    
    [self setDataStructureVersion:version];
}

#pragma mark - MVDownloadItem

- (MVDownloadItem *)rsToMVDownloadItem:(FMResultSet*)rs
{
    MVDownloadItem *item = [[MVDownloadItem alloc] initWithResultSet:rs];
    return item;
}

- (NSMutableArray *)getALLMVDownloadItems
{
    __block NSMutableArray *items = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from mv_download order by id DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            [items addObject:[self rsToMVDownloadItem :rs]];
        }
    }];
    
    
    return items;
}

- (void)addMVDownloadItem:(MVDownloadItem *)item
{
    //TTDINFO(@"id:%@", item.keyID);
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into mv_download(mvid,title,artist_name,thumbnail_pic,url,video_size,tmp_path,path,audio_time,cbytes,tbytes,current_progress,status,quality) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        [db executeUpdate:sql,
         item.keyID, item.title, item.artistName, item.thumbnailPic, item.url,
         item.videoSize,item.tmpPath,item.path,
         item.audioTimes,[NSNumber numberWithInt:item.cbytes],[NSNumber numberWithInt:item.tbytes],[NSNumber numberWithFloat:item.currentProgress],[NSNumber numberWithInt:item.status],[NSNumber numberWithInteger:item.quality]];
        //TTDINFO(@"success:%d--%@",su,[db lastError]);
    }];
}

- (MVDownloadItem *)getMVDownloadItem:(NSString *)keyID;
{
    __block MVDownloadItem *item = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from mv_download where mvid = ?";
        FMResultSet *rs = [db executeQuery:sql,keyID];
        while ([rs next])
        {
            item = [self rsToMVDownloadItem:rs];
        }
    }];
    
    return item;
}

- (void)updateMVDownloadPath:(MVDownloadItem *)item
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE mv_download SET tmp_path = ?, path = ? WHERE mvid = ?";
        [db executeUpdate:sql,item.tmpPath,item.path,item.keyID];
    }];
}

- (BOOL)updateMVDownItemStatus:(MVDownloadItem *)item
{
    __block BOOL success = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE mv_download SET status = ?, cbytes = ?, tbytes = ?, current_progress = ? WHERE mvid = ?";
        success = [db executeUpdate:sql,[NSNumber numberWithInt:item.status],[NSNumber numberWithInt:item.cbytes],[NSNumber numberWithInt:item.tbytes],[NSNumber numberWithFloat:item.currentProgress],item.keyID];
        //TTDINFO(@"jieguo:%@==%@", [NSNumber numberWithBool:success],[db lastError]);
    }];
    return success;
}

- (BOOL)deleteMVDownItem:(MVDownloadItem *)item
{
    __block BOOL success = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM mv_download WHERE mvid = ?";
        success = [db executeUpdate:sql,item.keyID];
        //TTDINFO(@"jieguo:%@", [NSNumber numberWithBool:success]);
    }];
    return success;
}

#pragma mark - BookDownInfo

/*
- (BOOL)isBookDownInfoEmpty:(NSString *)bid
{
    __block int tbytes = 0; 
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from chapter_down_info where bid = ?";
        FMResultSet *rs = [db executeQuery:sql,bid];
        while ([rs next])
        {
            tbytes += [rs intForColumn:@"tbytes"];
        }
    }];
    
    return tbytes==0;
}

- (BookDownInfo *)rsToBookDownInfo:(FMResultSet*)rs
{
    BookDownInfo *book = [[BookDownInfo alloc] init];
    book.ID = [rs intForColumn:@"serial"];
    book.bookid = [rs stringForColumn:@"bookid"];
    book.bookname = [rs stringForColumn:@"bookname"];
    book.imgurl = [rs stringForColumn:@"imgurl"];
    book.downloaded_num = [rs intForColumn:@"downloaded_num"];
    book.total_download_num = [rs intForColumn:@"total_download_num"];

    
    book.chapters = [NSMutableArray array];
    
    return book;
}

- (void)addBookDownInfo:(BookDownInfo *)book
{
    TTDINFO(@"id:%@", book.bookid);
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into book_down_info(bookid,bookname,imgurl,downloaded_num,total_download_num) values (?, ?,?, ?,?)";
        [db executeUpdate:sql,book.bookid,book.bookname,book.imgurl,[NSNumber numberWithInt:book.downloaded_num],[NSNumber numberWithInt:book.total_download_num]];
    }];  
}

- (BOOL)deleteBookDownInfo:(BookDownInfo *)info
{
    __block BOOL success = NO;
    
    BOOL infosSuccess = [self deleteChapterDownInfosByBookId:info.bookid];
    if (infosSuccess) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"DELETE FROM book_down_info WHERE bookid = ?";
            success = [db executeUpdate:sql,info.bookid];
            TTDINFO(@"jieguo:%@", [NSNumber numberWithBool:success]);
        }];
        
    }
     
    return success;
}

- (int)getBookDownInfoTbytes:(NSString *)bid
{
    __block int tbytes = 0; 
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from chapter_down_info where bid = ?";
        FMResultSet *rs = [db executeQuery:sql,bid];
        while ([rs next])
        {
            tbytes += [rs intForColumn:@"tbytes"];
        }
    }];
    
    return tbytes;
}

- (NSMutableArray *)getBookDownInfos
{
    __block NSMutableArray *books = [[NSMutableArray alloc] init];  
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *sql = @"select * from book_down_info order by serial DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            [books addObject:[self rsToBookDownInfo :rs]]; 
        }
    }];
    
    
    return books;
}
*/


@end