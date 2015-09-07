//
//  YYTClientParamGenerator.h
//  YYTHD
//
//  Created by IAN on 13-11-7.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTClientParamGenerator : NSObject
/**
 *  应用的App编号，统一分配。头信息必须包含此参数。
 *
 *  @return AppID
 */
+ (NSString *)AppID;

/**
 *  设备的唯一编号，就是V1协议中的uniqueId。
 *  策略为32位无重复字符串，能够表示一部设备。
 *
 *  @return (MD5)device.uniqueIdentifier
 */
+ (NSString *)DeviceID;

/**
 *  渠道号
 *
 *  @return 渠道号
 */
+ (NSString *)channelID;

/**
 *  设备版本信息，用于适配，统计。
 *  值为Base64 UTF8编码加密
 *  @return 系统名称_系统版本_分辨率_渠道编号_设备型号
 */
+ (NSString *)DeviceV;

/**
 *  网络信息
 *  值为Base64 UTF8编码加密。
 *  运营商（ChinaUnicom/CMCC/ChinaTelecom）
 *  网络模式（WIFI/3GNET/3GWAP/2G/非WIFI）
 *  @return 运营商_网络模式
 */
+ (NSString *)DeviceN:(AFNetworkReachabilityStatus)status;

/**
 *  授权
 *
 *  @return Bearer+空格+token
 */
+ (NSString *)Authorization;


@end
