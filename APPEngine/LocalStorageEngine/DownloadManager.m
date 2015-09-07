//
//  DownloadManager.m
//  YYTHD
//
//  Created by btxkenshin on 10/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "DownloadManager.h"
#import "DbDao.h"
#import "LocalStorage.h"
#import "AFDownloadRequestOperation.h"
#import <SIAlertView.h>
#import "MVItem.h"
#import "YYTClient.h"
#import "accesskeylib.h"
#import "StatisticManager.h"

#define kCurrentMaxDownload 3

NSString * const YYTDownloadQueueDidStartedNotification = @"YYTDownloadDidStarted";
NSString * const YYTDownloadQueueDidCompletedNotification = @"YYTDownloadQueueDidCompleted";

@interface DownloadManager ()

@property (nonatomic, strong) NSOperationQueue *afQueue;
@property (nonatomic, strong) NSMutableArray *downloadInfos;
@property (strong, nonatomic) NSMutableDictionary *downloadInfosDict;

@end

@implementation DownloadManager

static DownloadManager *sharedDownloadManager = nil;

- (id)init {
    if ((self = [super init])) {
        
        [self makeVideoRootDirectoryIfNotExist];
        
        _afQueue = [[NSOperationQueue alloc] init];
        [_afQueue setMaxConcurrentOperationCount:kCurrentMaxDownload];
        
        _downloadInfos = [[NSMutableArray alloc] init];
        _downloadInfosDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (DownloadManager *)sharedDownloadManager
{
    @synchronized(self)
    {
        if (sharedDownloadManager == nil)
        {
            sharedDownloadManager = [[self alloc] init];
        }
    }
    return sharedDownloadManager;
}

- (NSMutableArray *)downloadList
{
    return _downloadInfos;
}

- (MVDownloadItem *)downloadItemOfKeyID:(NSNumber *)keyID
{
    return [_downloadInfosDict objectForKey:keyID];
}

- (void)makeVideoRootDirectoryIfNotExist
{
    NSString  *audioPath = [NSString stringWithFormat:@"%@/%@", RootDirectory, VideoDirectory];
    if([[NSFileManager defaultManager]fileExistsAtPath:audioPath] == NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        [SystemSupport addSkipBackupAttributeToItemAtURL:url];
    }
    
    NSString  *audioTmpPath = [NSString stringWithFormat:@"%@/%@", RootDirectory, TmpVideoDirectory];
    if([[NSFileManager defaultManager]fileExistsAtPath:audioTmpPath] == NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:audioTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:audioTmpPath];
        [SystemSupport addSkipBackupAttributeToItemAtURL:url];
    }
}

#pragma mark - Download Entrance
- (void)sendStatisticForMV:(MVDownloadItem *)item
{
    [StatisticManager sendAutoStatisticToPath:DownloadStatisticPath userInfo:@{StatisticIDInfoKey:item.keyID}];
}

- (void)downloadMVItem:(MVItem *)item quality:(YYTMovieQuality)quality
{
    NSInteger keyId = [item.keyID integerValue]*10 + quality;
    if([self isAdded:[NSString stringWithFormat:@"%d",keyId]]) {
        [AlertWithTip flashFailedMessage:@"此MV已添加下载"];
        return;
    }
    
    DbDao *dao = [DbDao sharedInstance];
    MVDownloadItem *mvDownInfo = [[MVDownloadItem alloc] initWithMVItem:item quality:quality];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dao addMVDownloadItem:mvDownInfo];
    });
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NF_Download_ADD object:mvDownInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NF_Top_DownloadNum_Show object:nil];
    
    if ([YYTClient sharedInstance].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"当前不在wifi网络下" andMessage:@"是否继续下载？"];
        [alertView addButtonWithTitle:@"继续"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self startDownload:mvDownInfo];
                                  [AlertWithTip flashSuccessMessage:@"成功添加下载"];
                              }];
        [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:nil];
        [alertView show];
        
        return;
    }
    
    [AlertWithTip flashSuccessMessage:@"成功添加下载"];
    [self startDownload:mvDownInfo];
    [self sendStatisticForMV:mvDownInfo];
}

#pragma mark - add
- (BOOL)isAdded:(NSString *)keyId
{
    DbDao *dao = [DbDao sharedInstance];
    
    MVDownloadItem *item = [dao getMVDownloadItem:keyId];
    if ([item.keyID intValue] > 0) {
        return YES;
    }
    return NO;
}

/*
- (void)addDownload:(MVItem *)mv beginImmediately:(BOOL)begin
{
    DbDao *dao = [DbDao sharedInstance];
    
    if([self isAdded:[NSString stringWithFormat:@"%d",[mv.keyID intValue]]]){
        TTDERROR(@"mv:%d--已经添加过下载",[mv.keyID intValue]);
        return;
    }
    
    MVDownloadItem *mvDownInfo = [[MVDownloadItem alloc] initWithMVItem:mv];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dao addMVDownloadItem:mvDownInfo];
    });
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NF_Download_ADD object:mvDownInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:NF_Top_DownloadNum_Show object:nil];
    
    if (begin) {
        [self startDownload:mvDownInfo];
    }
}
*/

- (void)startDownload:(MVDownloadItem *)item
{
    [self.downloadInfos addObject:item];
    [self.downloadInfosDict setObject:item forKey:item.keyID];
    
    NSString *tmpPath = [LocalStorage videoTempPath:[item.keyID intValue]];
    NSString *finalPath = [LocalStorage videoPath:[item.keyID intValue]];
    
    item.status = DownloadStatusWait;
    item.tmpPath = tmpPath;
    item.path = finalPath;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DbDao sharedInstance] updateMVDownloadPath:item];
        [[DbDao sharedInstance] updateMVDownItemStatus:item];
    });
    
    //选择清晰度
    NSString *mvAddress = item.url;
    
    mvAddress = [accesskeylib getAccessKeyUrl:mvAddress];
    finalPath = [RootDirectory stringByAppendingPathComponent:finalPath];
    tmpPath = [RootDirectory stringByAppendingPathComponent:tmpPath];
    [LocalStorage removePath:finalPath];
    
    NSMutableURLRequest *nsrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mvAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:nsrequest targetPath:finalPath tempPath:tmpPath shouldResume:YES];
    operation.userInfo = [NSDictionary dictionaryWithObject:item.keyID forKey:@"sid"];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(AFHTTPRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        
        item.cbytes = totalBytesReadForFile;
        item.tbytes = totalBytesExpectedToReadForFile;
        item.currentProgress = percentDone;
        item.status = DownloadStatusDownloading;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_ReceiveBytes object:item];
        [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Progress object:item];
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        item.status = DownloadStatusComplete;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[DbDao sharedInstance] updateMVDownItemStatus:item];
        });
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Complete object:item];
        
        [self.downloadInfos removeObject:item];
        [self.downloadInfosDict removeObjectForKey:item.keyID];
        
        [self postQueueCompleteNotificationIfNeed];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        item.status = DownloadStatusDefault;
        if (operation.isCancelled != YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Failed object:item userInfo:@{@"error":error,@"operation":operation}];
        }
        
        MVDownloadItem *theInfo = [self.downloadInfosDict objectForKey:item.keyID];
        if (theInfo) {
            
            theInfo.status = item.status;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DbDao sharedInstance] updateMVDownItemStatus:theInfo];
            });
            
            [self.downloadInfos removeObject:theInfo];
            [self.downloadInfosDict removeObjectForKey:item.keyID];
            
            [self postQueueCompleteNotificationIfNeed];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_START object:item];
    
    [_afQueue addOperation:operation]; //开始下载
    
    [self postQueueStartNotificationIfNeed];
}

- (void)cancelDownload:(MVDownloadItem *)item
{
    item.status = DownloadStatusDefault;
    
    NSArray *operations = [_afQueue operations];
    for (NSOperation *operation in operations) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }

        BOOL hasMatchingPath = [[[(AFHTTPRequestOperation *)operation userInfo] objectForKey:@"sid"] isEqualToNumber:item.keyID];
        
        if (hasMatchingPath) {
            [operation cancel];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Cancel object:item];
    
    //移出队列
    MVDownloadItem *theInfo = [_downloadInfosDict objectForKey:item.keyID];
    if (theInfo) {
        
        theInfo.status = item.status;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[DbDao sharedInstance] updateMVDownItemStatus:theInfo];
        });
        
        [_downloadInfosDict removeObjectForKey:item.keyID];
        [_downloadInfos removeObject:theInfo];
    }
    [self postQueueCompleteNotificationIfNeed];
}

- (void)deleteDownload:(MVDownloadItem *)item
{
    if (item.status == DownloadStatusDownloading || item.status == DownloadStatusDefault) {
        
        if(item.status == DownloadStatusDownloading)
            [self cancelDownload:item];
        
        BOOL success = NO;
        
        NSString *audiopathTemp = [LocalStorage videoTempPath:[item.keyID intValue]];
        audiopathTemp = [RootDirectory stringByAppendingPathComponent:audiopathTemp];
        if (![[NSFileManager defaultManager] fileExistsAtPath:audiopathTemp]) {
            success = YES;
        }
        else {
            if( [[NSFileManager defaultManager] isDeletableFileAtPath:audiopathTemp]) {
                success = [[NSFileManager defaultManager] removeItemAtPath:audiopathTemp error:nil];
            }
        }
        
        NSString *audiopath = [LocalStorage videoPath:[item.keyID intValue]];
        audiopath = [RootDirectory stringByAppendingPathComponent:audiopath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:audiopath]) {
            success = YES;
        }
        else {
            if( [[NSFileManager defaultManager] isDeletableFileAtPath:audiopath]) {
                success = [[NSFileManager defaultManager] removeItemAtPath:audiopath error:nil];
            }
        }
        
        if (success) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DbDao sharedInstance] deleteMVDownItem:item];
            });
        }
    }
    else {
        BOOL success = NO;
        
        NSString *audiopath = [LocalStorage videoPath:[item.keyID intValue]];
        audiopath = [RootDirectory stringByAppendingPathComponent:audiopath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:audiopath]) {
            success = YES;
        }else{
            if( [[NSFileManager defaultManager] isDeletableFileAtPath:audiopath]){
                success = [[NSFileManager defaultManager] removeItemAtPath:audiopath error:nil];
            }
        }
        
        if (success) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DbDao sharedInstance] deleteMVDownItem:item];
            });
        
        }
    }
    
    MVDownloadItem *theInfo = [_downloadInfosDict objectForKey:item.keyID];
    if (theInfo) {
        [_downloadInfosDict removeObjectForKey:item.keyID];
        [_downloadInfos removeObject:theInfo];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Delete object:item];
    [self postQueueCompleteNotificationIfNeed];
}

- (void)postQueueStartNotificationIfNeed
{
    NSInteger count = _downloadInfos.count;
    if (count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYTDownloadQueueDidStartedNotification object:self];
    }
}

- (void)postQueueCompleteNotificationIfNeed
{
    NSInteger count = _downloadInfos.count;
    if(count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYTDownloadQueueDidCompletedNotification object:self];
    }
}

- (BOOL)isDownloadComplete:(MVDownloadItem *)item
{
    return item.status == DownloadStatusComplete;
}

- (BOOL)isDownloading:(MVDownloadItem *)item
{
    return item.status == DownloadStatusDownloading;
}

- (void)cancelDownloadAll
{
    TTLogFunction();
    if(_afQueue)
    {
        NSArray *operations = [_afQueue operations];
        for (NSOperation *operation in operations) {
            if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
                continue;
            }
            [operation cancel];
        }
        
        _afQueue = nil;
        for(MVDownloadItem *info in self.downloadInfos){
            if (info.status == DownloadStatusDownloading) {
                info.status = DownloadStatusDefault;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[DbDao sharedInstance] updateMVDownItemStatus:info];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:NF_Download_Cancel object:info];
            }
        }
        
        [self.downloadInfos removeAllObjects];
        [self.downloadInfosDict removeAllObjects];
        
        _afQueue = [[NSOperationQueue alloc] init];
        [_afQueue setMaxConcurrentOperationCount:kCurrentMaxDownload];
        
    }
}

- (void)saveAllDownloadInfosToDB:(BOOL)changeStatus
{
    for(MVDownloadItem *info in self.downloadInfos){
        if (info.status == DownloadStatusDownloading || info.status == DownloadStatusWait) {
            if (changeStatus) {
                info.status = DownloadStatusDefault;
            }
            [[DbDao sharedInstance] updateMVDownItemStatus:info];
        }
    }
}

@end
