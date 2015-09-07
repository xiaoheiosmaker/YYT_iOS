//
//  LocalStorage.m
//  KtingS
//
//  Created by kenshin on 13-7-24.
//  Copyright (c) 2013年 酷听网. All rights reserved.
//

#import "LocalStorage.h"
#import "SINGLETONGCD.h"



@implementation LocalStorage

SINGLETON_GCD(LocalStorage);


+ (NSString *)makeBookPath:(NSString *)bid{
    NSString *bookPath = [[RootDirectory  stringByAppendingPathComponent:VideoDirectory] stringByAppendingPathComponent:bid];
    if([[NSFileManager defaultManager]fileExistsAtPath:bookPath] == NO){
		[[NSFileManager defaultManager] createDirectoryAtPath:bookPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:bookPath];
        [SystemSupport addSkipBackupAttributeToItemAtURL:url];
	}
    return bookPath;
}

+ (NSString *)makeTempBookPath:(NSString *)bid{
    NSString *bookPath = [[RootDirectory  stringByAppendingPathComponent:TmpVideoDirectory] stringByAppendingPathComponent:bid];
    if([[NSFileManager defaultManager]fileExistsAtPath:bookPath] == NO){
		[[NSFileManager defaultManager] createDirectoryAtPath:bookPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:bookPath];
        [SystemSupport addSkipBackupAttributeToItemAtURL:url];
	}
    return bookPath;
}


+ (NSString *)videoPath:(int)mvid{
    //NSString *videoDictPath = [RootDirectory  stringByAppendingPathComponent:VideoDirectory];
    NSString *videoDictPath = VideoDirectory;
    NSString *theVidepPath = [videoDictPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4",mvid]];
    return theVidepPath;
}

+ (NSString *)videoTempPath:(int)mvid
{
    //NSString *videoDictPath = [RootDirectory  stringByAppendingPathComponent:TmpVideoDirectory];
    NSString *videoDictPath = TmpVideoDirectory;
    NSString *theVidepPath = [videoDictPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4",mvid]];
    return theVidepPath;
}

+ (void)removePath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path isDirectory:NULL]) {
        [manager removeItemAtPath:path error:nil];
    }
}


+ (void)cacheDict:(NSDictionary *)dict fileName:(NSString *)fileName
{
    //BOOL isok = [dict writeToFile:[[RootDirectory  stringByAppendingPathComponent:CacheDirectoryRoot] stringByAppendingString:fileName] atomically:YES];
    //TTDINFO(@"isok---%d",isok);
}

+ (NSDictionary *)dictFromCache:(NSString *)fileName
{
    return [NSDictionary dictionaryWithContentsOfFile:[[RootDirectory  stringByAppendingPathComponent:CacheDirectoryRoot] stringByAppendingString:fileName]];
}

+ (NSNumber*) totalDiskSpace {
#if __IPHONE_4_0
    NSError* error = nil;
    NSDictionary* fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: &error];
    if (error)
        return nil;
#else
    NSDictionary* fattributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath: NSHomeDirectory()];
#endif
    
    return [fattributes objectForKey: NSFileSystemSize];
}

+ (NSNumber*) freeDiskSpace {
#if __IPHONE_4_0
    NSError* error = nil;
    NSDictionary* fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: &error];
    
    if (error)
        return nil;
#else
    NSDictionary* fattributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath: NSHomeDirectory()];
#endif
    
    //TTDINFO(@"System free space: %lld", [[fattributes objectForKey:NSFileSystemFreeSize] longLongValue]);
    
    return [fattributes objectForKey: NSFileSystemFreeSize];
}




+ (long long)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    long long size = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for(int i = 0; i<[array count]; i++)
        
    {
        
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
            
        {
            
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            
            size += fileAttributeDic.fileSize;
            
        }
        
        else
        {
            size += [self fileSizeForDir:fullPath];
        }
        
    }
    
    
    return size;
    
    
    
}

@end
