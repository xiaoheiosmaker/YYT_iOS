//
//  LocalStorage.h
//  KtingS
//
//  Created by kenshin on 13-7-24.
//  Copyright (c) 2013年 酷听网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject


#pragma mark 目录支持＋缓存

/// 创建书的存放目录
+ (NSString *)makeBookPath:(NSString *)bid;
+ (NSString *)makeTempBookPath:(NSString *)bid;
/// 获取mv视频存放目录
+ (NSString *)videoPath:(int)mvid;
+ (NSString *)videoTempPath:(int)mvid;
+ (void)removePath:(NSString *)path;


#pragma mark 缓存

/**
 *	@brief	写缓存到本地文件
 *
 *	@param 	dict       存储信息
 *	@param 	fileName   文件名
 */
+ (void)cacheDict:(NSDictionary *)dict fileName:(NSString *)fileName;
/// 从缓存文件fileName读取信息
+ (NSDictionary *)dictFromCache:(NSString *)fileName;


#pragma mark Other

// 硬盘总大小
+ (NSNumber *) totalDiskSpace;
// 硬盘剩余大小
+ (NSNumber *) freeDiskSpace;
// dir目录总大小
+ (long long)fileSizeForDir:(NSString*)path;

@end
