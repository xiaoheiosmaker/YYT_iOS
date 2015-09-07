//
//  YYTClientParamGenerator.m
//  YYTHD
//
//  Created by IAN on 13-11-7.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTClientParamGenerator.h"
#import "NSString+MD5Addition.h"
#import "OpenUDID.h"
#import "sys/sysctl.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "YYTClient.h"
#import "YYTLoginInfo.h"
#import "UserDataController.h"
#import "MF_Base64Additions.h"

@implementation YYTClientParamGenerator

static NSDictionary * configDic = nil;

+ (void)load
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    if ([configPath length]) {
        configDic = [NSDictionary dictionaryWithContentsOfFile:configPath];
    }
}

+ (NSString *)AppKey
{
    return [self valueInConfigDicForKeyPath:@"AppId.App_Key"];
}

+ (NSString *)AppSecret
{
    return [self valueInConfigDicForKeyPath:@"AppId.App_Secret"];
}


+ (NSString *)AppID
{
    return [self valueInConfigDicForKeyPath:@"AppId.App_Id"];
}

+ (NSString *)channelID
{
    return [self valueInConfigDicForKeyPath:@"ChannelId.YinYueTaiChannelId"];
}

+ (NSString *)DeviceID
{
    NSString *uid = [OpenUDID value];
    return [uid stringFromMD5];
}

+ (NSString *)oauth
{
    NSString *oauth = [NSString stringWithFormat:@"%@:%@",[self AppKey],[self AppSecret]];
    return [oauth base64String];
}


/**
 *  设备版本信息，用于适配，统计。
 *  值为Base64 UTF8编码加密
 *  @return 系统名称_系统版本_分辨率_渠道编号_设备型号
 */
+ (NSString *)DeviceV
{
    UIDevice *device = [UIDevice currentDevice];
    
    //系统名
    NSString *os = device.systemName;
    //系统版本
    NSString *ov = device.systemVersion;
    //分辨率
    UIScreenMode *mode = [UIScreen mainScreen].currentMode;
    NSString *rn = [NSString stringWithFormat:@"%d*%d", (int)mode.size.width, (int)mode.size.height];
    
    //渠道号
    NSString *clid = [self channelID];
    
    //设备型号
    NSString *dt = [self doDevicePlatform];
    
    NSString *string = [NSString stringWithFormat:@"%@_%@_%@_%@_%@",os,ov,rn,clid,dt];
    return [string base64String];
}

/**
 *  网络信息
 *  值为Base64 UTF8编码加密。
 *  运营商（ChinaUnicom/CMCC/ChinaTelecom）
 *  网络模式（WIFI/3GNET/3GWAP/2G/非WIFI）
 *  @return 运营商_网络模式
 */
+ (NSString *)DeviceN:(AFNetworkReachabilityStatus)status
{
    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *cr = carrier.carrierName;
    
    //网络类型
    NSString *as = nil;
    
    //AFNetworkReachabilityStatus status = [[YYTClient sharedInstance] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        as = @"WIFI";
    } else {
        as = @"非WIFI";
    }

    NSString *str = [NSString stringWithFormat:@"%@_%@",cr,as];
    
    return [str base64String];
}

+ (NSString *)Authorization
{
    NSString *token = [[[UserDataController sharedInstance] loginInfo] access_token];
    if ([token length]) {
        return [NSString stringWithFormat:@"Bearer %@",token];
    }
    else {
        return [NSString stringWithFormat:@"Basic %@",[self oauth]];
    }
}

#pragma mark - Private Method
+ (NSString *) doDevicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]) {
        platform = @"iPhone 5";
    } else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod touch 4";
    } else if ([platform isEqualToString:@"iPad3,2"]) {
        platform = @"iPad 3 3G";
    } else if ([platform isEqualToString:@"iPad3,1"]) {
        platform = @"iPad 3 WiFi";
    } else if ([platform isEqualToString:@"iPad2,2"]) {
        platform = @"iPad 2 3G";
    } else if ([platform isEqualToString:@"iPad2,1"]) {
        platform = @"iPad 2 WiFi";
    } else if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        platform = @"iPhone Simulator";
    }
    return platform;
}

+ (instancetype)valueInConfigDicForKeyPath:(NSString *)keyPath
{
    if (configDic) {
        id value = [configDic valueForKeyPath:keyPath];
        if (value) {
            return value;
        }
    }
    return nil;
}

@end
