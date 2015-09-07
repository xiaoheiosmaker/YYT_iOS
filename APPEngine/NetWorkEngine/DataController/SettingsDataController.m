//
//  SettingsDataController.m
//  YYTHD
//
//  Created by shuilin on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SettingsDataController.h"
#import "DownloadManager.h"

@interface SettingsDataController()
{
    
}
@end

@implementation SettingsDataController
@synthesize lockOn = _lockOn;
- (id)init
{
    self = [super init];
    if(self)
    {
        self.sinaAccount = [[ShareAccount alloc] init];
        self.qqAccount = [[ShareAccount alloc] init];
        self.tencentAccount = [[ShareAccount alloc] init];
        self.renrenAccount = [[ShareAccount alloc] init];
        
        [self loadItems];
    }
    return self;
}

- (void)dealloc
{
    self.sinaAccount = nil;
    self.qqAccount = nil;
    self.tencentAccount = nil;
    self.renrenAccount = nil;
}

+ (SettingsDataController*) singleTon
{
    @synchronized(self)
    {
        static SettingsDataController* dataController = nil;
        if(dataController == nil)
        {
            dataController = [[SettingsDataController alloc] init];
            [[NSNotificationCenter defaultCenter] addObserverForName:YYTDownloadQueueDidCompletedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            }];
            [[NSNotificationCenter defaultCenter] addObserverForName:YYTDownloadQueueDidStartedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                if (dataController.lockOn) {
                    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                }
            }];
        }
        return dataController;
    }
}

- (void)setLockOn:(BOOL)lockOn
{
    if (lockOn != _lockOn) {
        _lockOn = lockOn;
        if (lockOn && [[DownloadManager sharedDownloadManager].downloadList count] > 0) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
        else {
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
    }
}

- (void)saveItem:(NSString *)kItem
{
    if(kItem.length == 0)
    {
        return;
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([kItem isEqualToString:kVideoQualityItem])
    {
        NSNumber* videoQualityNumber = [NSNumber numberWithInteger:self.videoQualityType];
        [userDefaults setObject:videoQualityNumber forKey:kVideoQualityItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kLockSwitchItem])
    {
        NSNumber* lockOnNumber = [NSNumber numberWithInteger:self.lockOn];
        [userDefaults setObject:lockOnNumber forKey:kLockSwitchItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kSinaAccountItem])
    {
        NSData* sinaData = [NSKeyedArchiver archivedDataWithRootObject:self.sinaAccount];
        [userDefaults setObject:sinaData forKey:kSinaAccountItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kQQAccountItem])
    {
        NSData* qqData = [NSKeyedArchiver archivedDataWithRootObject:self.qqAccount];
        [userDefaults setObject:qqData forKey:kQQAccountItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kTencentAccountItem])
    {
        NSData* tencentData = [NSKeyedArchiver archivedDataWithRootObject:self.tencentAccount];
        [userDefaults setObject:tencentData forKey:kTencentAccountItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kRenrenAccountItem])
    {
        NSData* renrenData = [NSKeyedArchiver archivedDataWithRootObject:self.renrenAccount];
        [userDefaults setObject:renrenData forKey:kRenrenAccountItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kMessageSwitchItem])
    {
        NSNumber* number = [NSNumber numberWithInteger:self.messageOn];
        [userDefaults setObject:number forKey:kMessageSwitchItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kNewMVSwitchItem])
    {
        NSNumber* number = [NSNumber numberWithInteger:self.newMvOn];
        [userDefaults setObject:number forKey:kNewMVSwitchItem];
        [userDefaults synchronize];
    }
    else if([kItem isEqualToString:kNetSwitchItem])
    {
        NSNumber* number = [NSNumber numberWithInteger:self.netOn];
        [userDefaults setObject:number forKey:kNetSwitchItem];
        [userDefaults synchronize];
    }
}

- (void)loadItems
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    /*
    NSNumber* videoQualityNumber = [userDefaults objectForKey:kVideoQualityItem];
    if(videoQualityNumber == nil)
    {
        //默认
        self.videoQualityType = Normal_Video;
    }
    else
    {
        self.videoQualityType = [videoQualityNumber integerValue];
    }
    */
    
    NSNumber* lockOnNumber = [userDefaults objectForKey:kLockSwitchItem];
    if(lockOnNumber == nil)
    {
        //默认
        self.lockOn = YES;
    }
    else
    {
        self.lockOn = [lockOnNumber integerValue];
    }
    
    NSData* sinaData = [userDefaults objectForKey:kSinaAccountItem];
    if(sinaData == nil)
    {
        //默认
        self.sinaAccount.name = @"未登录的用户";
        self.sinaAccount.status = Logout_Status;
        self.sinaAccount.token = @"";
    }
    else
    {
        self.sinaAccount = [NSKeyedUnarchiver unarchiveObjectWithData:sinaData];
    }
    
    NSData* qqData = [userDefaults objectForKey:kQQAccountItem];
    if(qqData == nil)
    {
        //默认
        self.qqAccount.name = @"未登录的用户";
        self.qqAccount.status = Logout_Status;
        self.qqAccount.token = @"";
    }
    else
    {
        self.qqAccount = [NSKeyedUnarchiver unarchiveObjectWithData:qqData];
    }

    
    NSData* tencentData = [userDefaults objectForKey:kTencentAccountItem];
    if(tencentData == nil)
    {
        //默认
        self.tencentAccount.name = @"未登录的用户";
        self.tencentAccount.status = Logout_Status;
        self.tencentAccount.token = @"";
    }
    else
    {
        self.tencentAccount = [NSKeyedUnarchiver unarchiveObjectWithData:tencentData];
    }

    
    NSData* renrenData = [userDefaults objectForKey:kRenrenAccountItem];
    if(renrenData == nil)
    {
        //默认
        self.renrenAccount.name = @"未登录的用户";
        self.renrenAccount.status = Logout_Status;
        self.renrenAccount.token = @"";
    }
    else
    {
        self.renrenAccount = [NSKeyedUnarchiver unarchiveObjectWithData:renrenData];
    }
    
    NSNumber* messageOnNumber = [userDefaults objectForKey:kMessageSwitchItem];
    if(messageOnNumber == nil)
    {
        //默认
        self.messageOn = YES;
    }
    else
    {
        self.messageOn = [messageOnNumber integerValue];
    }
    
    NSNumber* newMvOnNumber = [userDefaults objectForKey:kNewMVSwitchItem];
    if(newMvOnNumber == nil)
    {
        //默认
        self.newMvOn = YES;
    }
    else
    {
        self.newMvOn = [newMvOnNumber integerValue];
    }
    
    NSNumber* netOnNumber = [userDefaults objectForKey:kNetSwitchItem];
    if(netOnNumber == nil)
    {
        //默认
        self.netOn = YES;
    }
    else
    {
        self.netOn = [netOnNumber integerValue];
    }

    
    //NSLog(@"video:%d,lockon:%d,sina name : %@,sina status:%d",self.videoQualityType,self.lockOn,self.sinaAccount.name,self.sinaAccount.status);
}

@end
