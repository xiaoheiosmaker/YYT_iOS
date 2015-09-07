//
//  AppHelper.m
//  YYTHD
//
//  Created by IAN on 13-11-5.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "AppDelegateHelper.h"

#import "UserGuideViewController.h"
#import "FileManageHelper.h"
#import "DownloadManager.h"
#import "WeiboSDK.h"

#import "PlayHistoryDataController.h"
#import "MVDataController.h"
#import "SettingsDataController.h"
#import "MobClick.h"
#import <AVFoundation/AVFoundation.h>
#import "YYTClientParamGenerator.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

static NSString *YYTServerTimeKey = @"YYTServerTime";

__weak static UIViewController *RootViewController = nil;

@implementation AppDelegateHelper

+ (void)setRootViewController:(UIViewController *)rootViewController
{
    if (RootViewController != rootViewController) {
        RootViewController = rootViewController;
    }
}

+ (UIViewController *)rootViewController
{
    return RootViewController;
}

+ (void)showUserGuideIfNeed
{
    NSString *UserGuideFlag = @"UserGuideFlag";
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:UserGuideFlag];
    if (!flag) {
        UserGuideViewController *userGuide = [[UserGuideViewController alloc] init];
        [RootViewController presentViewController:userGuide animated:NO completion:NULL];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserGuideFlag];
    }
}


+ (void)prepareDataForAppLaunching
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    // 友盟社会化组件
    [UMSocialData setAppKey:UMENG_APP_KEY];
    [MobClick checkUpdate];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_OATH_KEY];
    
    [UMSocialConfig setWXAppId:WX_APP_ID url:nil];
    [WXApi registerApp:WX_APP_ID];
    
    // 友盟Track
    NSString * appKey = UMENG_TRACK_APP_KEY;
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey,deviceName,mac,idfa,idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    
    // 友盟统计
    NSString *channelID = [YYTClientParamGenerator channelID];
    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:REALTIME channelId:channelID];
    
    //根据需要初始化文件/目录/数据库等
    [FileManageHelper copyInitFileIFNeeded];
    [FileManageHelper updateDatabaseIFNeeded];
    
    // 为了启动观察者，访问一下单例，详见单例方法
    [SettingsDataController singleTon];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self requestServerTime];
}

+ (void)recoverDataForAppAwake
{
    [self requestServerTime];
}

+ (void)releaseSharedResources
{
    [PlayHistoryDataController releaseSharedInstance];
}

+ (void)saveAppState
{
    //保存当前下载进度
    [[DownloadManager sharedDownloadManager] saveAllDownloadInfosToDB:YES];
}

+ (void)requestServerTime
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS"];
    }
    
    [[YYTClient sharedInstance] getPath:URL_TIME
                             parameters:nil
                                success:^(id content, id responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSString *timeStr = responseObject[@"time"];
                                        NSDate *date = [dateFormatter dateFromString:timeStr];
                                        NSTimeInterval interval = [date timeIntervalSinceNow];
                                        [[NSUserDefaults standardUserDefaults] setDouble:interval forKey:YYTServerTimeKey];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                    }
                                }
                                failure:^(id content, NSError *error) {}];
}

+ (NSTimeInterval)serverTime
{
    NSTimeInterval time = [[NSUserDefaults standardUserDefaults] doubleForKey:YYTServerTimeKey];
    return time;
}

// UMeng 相关
+ (NSString * )macString{
    
    int                 mib[6];
    size_t                 len;
    char                 *buf;
    unsigned char         *ptr;
    struct if_msghdr     *ifm;
    struct sockaddr_dl     *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

@end
