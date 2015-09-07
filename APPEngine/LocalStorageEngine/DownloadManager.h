//
//  DownloadManager.h
//  YYTHD
//
//  Created by btxkenshin on 10/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVItem.h"
#import "MVDownloadItem.h"


#define NF_Download_ADD @"NF_Download_ADD"
#define NF_Download_START @"NF_Download_START"
#define NF_Top_DownloadNum_Show @"NF_Top_DownloadNum_Show"
#define NF_Download_Complete @"NF_Download_Complete"
#define NF_Download_Failed @"NF_Download_Failed"

#define NF_Download_ReceiveBytes @"NF_Download_ReceiveBytes"
#define NF_Download_Progress @"NF_Download_Progress"

extern NSString * const YYTDownloadQueueDidStartedNotification;
extern NSString * const YYTDownloadQueueDidCompletedNotification;

@interface DownloadManager : NSObject

+ (DownloadManager *)sharedDownloadManager;

- (NSMutableArray *)downloadList;
- (MVDownloadItem *)downloadItemOfKeyID:(NSNumber *)keyID;

/**
 *	@brief	是否已经添加下载
 *
 *	@param 	keyId 	标示id
 *
 *	@return	YES 表示已经添加 NO 表示未添加
 */
- (BOOL)isAdded:(NSString *)keyId;


/**
 *  下载MVItem
 *
 *  @param item    MVItem
 *  @param quality YYTMVQuality
 */
- (void)downloadMVItem:(MVItem *)item quality:(YYTMovieQuality)quality;


- (void)startDownload:(MVDownloadItem *)item;

- (void)cancelDownload:(MVDownloadItem *)item;

- (void)deleteDownload:(MVDownloadItem *)item;


- (BOOL)isDownloadComplete:(MVDownloadItem *)item;
- (BOOL)isDownloading:(MVDownloadItem *)item;

- (void)cancelDownloadAll;


/**
 *	@brief	保存下载状态信息到数据库
 *
 *	@param 	changeStatus 	是否改变下载的status状态，如果是程序终止调用则传YES，否则传NO(如进入后台)
 */
- (void)saveAllDownloadInfosToDB:(BOOL)changeStatus;



@end
