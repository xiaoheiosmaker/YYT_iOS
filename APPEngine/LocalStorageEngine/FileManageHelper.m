//
//  FileManageHelper.m
//  KtingS
//
//  Created by kenshin on 13-7-24.
//  Copyright (c) 2013年 酷听网. All rights reserved.
//

#import "FileManageHelper.h"
#import "DbDao.h"

@implementation FileManageHelper

+ (void)copyInitFileIFNeeded
{
    [self copyFileDatabaseIFNeeded];
    [self copyUrlFileIFNeeded];
}

/// 如果需要，拷贝资源目录的数据库到用户目录，通常只有程序第一次启动时候真正执行
+ (void)copyFileDatabaseIFNeeded
{
    NSString *dbPath = [RootDirectory stringByAppendingPathComponent:DBNAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        TTDINFO(@"%@文件已经存在了,不进行拷贝",DBNAME);
    }else{
        NSString *resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBNAME];
        
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        
        [[NSFileManager defaultManager] createFileAtPath:dbPath
                                                contents:mainBundleFile
                                              attributes:nil];
        
    }
}


+ (void)copyUrlFileIFNeeded
{
    /*
    NSString *filePath = [RootDirectory stringByAppendingPathComponent:URL_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        TTDINFO(@"%@文件已经存在了,不进行拷贝",URL_FILE);
    }else{
        NSString *resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:URL_FILE];
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:mainBundleFile
                                              attributes:nil];
        
    }
    */
}

+ (void)updateDatabaseIFNeeded
{
    NSString *dbPath = [RootDirectory stringByAppendingPathComponent:DBNAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        [[DbDao sharedInstance] updateDBStruct];
    }
}


@end
