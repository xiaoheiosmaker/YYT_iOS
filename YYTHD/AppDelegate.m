//
//  AppDelegate.m
//  YYTHD
//
//  Created by btxkenshin on 10/10/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LocalStorage.h"
#import "DownloadManager.h"
#import "PushDataController.h"
#import "MVAristDataController.h"
#import "MyOrderArtist.h"
#import "AppDelegateHelper.h"
#import "SettingsDataController.h"
#import "ShareAssistantController.h"
#import "PushDataItem.h"
#import "PushApsItem.h"
#import "PushItem.h"
#import "PushDataController.h"
#import "MVDetailViewController.h"
#import "VViewController.h"
#import "UserDataController.h"
#import "HomeViewController.h"
#import "MLItem.h"
#import "MLParticularViewController.h"
#import "NoticeDataController.h"

@interface AppDelegate ()
{
    
}

@end


@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //加载资源
    [AppDelegateHelper prepareDataForAppLaunching];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self getUnReadCount];
    //获取系统通知
    [self setNotice];
    self.rootController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];
    
    [AppDelegateHelper setRootViewController:self.rootController];
    [AppDelegateHelper showUserGuideIfNeed];
    
    if (![SystemSupport versionPriorTo7]) {
        application.statusBarStyle = UIStatusBarStyleLightContent;
    }

    NSDictionary *pushDict = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    PushItem *pushItem = [[PushDataController singleTon] pushDataParseWithDict:pushDict];
    PushDataItem *pushDataItem = pushItem.data;
    NSString *dataType = pushItem.dataType;

    if ([dataType isEqualToString:@"frontpage"]) {
        //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        HomeViewController *home = [[HomeViewController alloc] init];
        [self.rootController.singleButtonGroup addItem:self.rootController.mlBtn];
        [self.rootController showViewController:home];
    }else if ([dataType isEqualToString:@"video"]){
        //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        MVDetailViewController *mvDetailViewController = [[MVDetailViewController alloc] initWithId:pushDataItem.keyId];
        [self.rootController showViewController:mvDetailViewController];
    }else if ([dataType isEqualToString:@"playlist"]){
        //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        MLItem *mlItem = [[MLItem alloc] init];
        mlItem.keyID = [NSNumber numberWithInteger:[pushDataItem.keyId integerValue]];
        MLParticularViewController *mlParticularViewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
        [self.rootController showViewController:mlParticularViewController];
    }else if ([dataType isEqualToString:@"vchart"]){
        //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        VViewController *vViewController = [[VViewController alloc] initWithCodeDate:pushDataItem.datecode area:pushDataItem.area];
        [self.rootController showViewController:vViewController];
        [self.rootController.singleButtonGroup addItem:self.rootController.vButton];
        //        [viewController presentModalViewController:vViewController animated:YES];
    }else if ([dataType isEqualToString:@"subscribe"]){
        self.unReadCount = pushDataItem.unreadCount;
        //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadCount" object:self.unReadCount];
    }

    return YES;
}

- (void)setNotice{
    [[NoticeDataController sharedInstance] getNoticeCount:^(NoticeDataController *dataController, NSDictionary *resultDict) {
        if ([[resultDict objectForKey:@"new"] integerValue]) {
            [NoticeDataController sharedInstance].isNew = YES;
        }else{
            [NoticeDataController sharedInstance].isNew = NO;
        }
        NSArray *resultArray = [resultDict objectForKey:@"data"];
        [[NoticeDataController sharedInstance].countArray removeAllObjects];
        [[NoticeDataController sharedInstance].countArray addObjectsFromArray:resultArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadImage" object:nil];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        
    }];
   
}

- (void)launchNotification:(NSNotification *)notification{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"message" message:[NSString stringWithFormat:@"object = %@ userInfo =%@",notification.object,notification.userInfo] delegate:self cancelButtonTitle:nil otherButtonTitles:@"sure", nil];
    [alert show];
}

- (void)getUnReadCount{
    MVAristDataController *artistDataController = [[MVAristDataController alloc] init];
    [artistDataController getArtistOrderMessage:nil success:^(MVAristDataController *dataController, MyOrderArtist *orderArtist) {
        self.unReadCount = orderArtist.unreadCount;
        if ([self.unReadCount integerValue]>99) {
            self.unReadCount = @"99";
        }
        if ([self.unReadCount integerValue] > 0 && [SettingsDataController singleTon].newMvOn) {
            
        }else{
            self.unReadCount = @"0";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadCount" object:self.unReadCount];
        
    } failure:^(MVAristDataController *dataController, NSError *error) {

    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //释放资源
    [AppDelegateHelper releaseSharedResources];
    
    //保存
    [AppDelegateHelper saveAppState];
    
    //获取我的订阅未读信息数
    MVAristDataController *artistDataController = [[MVAristDataController alloc] init];
    [artistDataController getArtistOrderMessage:nil success:^(MVAristDataController *dataController, MyOrderArtist *orderArtist) {
        self.unReadCount = orderArtist.unreadCount;
        if ([self.unReadCount integerValue]>99) {
            self.unReadCount = @"99";
        }
        if ([self.unReadCount integerValue] > 0 && [SettingsDataController singleTon].newMvOn) {
            
        }else{
            self.unReadCount = @"0";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadCount" object:self.unReadCount];
    } failure:^(MVAristDataController *dataController, NSError *error) {
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [AppDelegateHelper recoverDataForAppAwake];
    //获取系统通知
    [self setNotice];
    
//    MVDetailViewController *mvDetailViewController = [[MVDetailViewController alloc] initWithId:@"831975"];
//    [self.rootController showViewController:mvDetailViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService applicationDidBecomeActive];
    
    if ([[UIApplication sharedApplication] applicationIconBadgeNumber] > 0)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    //释放资源
    [AppDelegateHelper releaseSharedResources];
    //保存
    [AppDelegateHelper saveAppState];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    NSRange weiboRange = [urlString rangeOfString:WEIBO_OATH_KEY];
    if (weiboRange.location == NSNotFound) {
        [WXApi handleOpenURL:url delegate:self];
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString = [url absoluteString];
    NSRange weiboRange = [urlString rangeOfString:WEIBO_OATH_KEY];
    if (weiboRange.location == NSNotFound) {
        [WXApi handleOpenURL:url delegate:self];
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case 0: {
                // 分享成功
                [AlertWithTip flashSuccessMessage:@"成功分享到微信朋友圈"];
                break;
            }
            case -2: {
                // 取消分享
                break;
            }
            
            default: {
                if (resp.errStr) {
                    [AlertWithTip flashFailedMessage:resp.errStr];
                }
                else {
                    [AlertWithTip flashFailedMessage:@"分享到微信朋友圈失败"];
                }
                break;
            }
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class]) {
        NSLog(@"didReceiveWeiboRequest");
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        NSLog(@"didReceiveWeiboResponse");
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        WBAuthorizeResponse *aResponse = (WBAuthorizeResponse *)response;
        if (aResponse.accessToken) {
            UMSocialAccountEntity *weiboAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToSina];
            weiboAccount.usid = aResponse.userID;
            weiboAccount.accessToken = aResponse.accessToken;
            [UMSocialAccountManager postSnsAccount:weiboAccount completion:^(UMSocialResponseEntity *response) {
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [UMSocialAccountManager setSnsAccount:weiboAccount];
                    if ([[UserDataController sharedInstance] isLogin]) {
                        [[UserDataController sharedInstance] bindingOpenPlatform:@"SINA" uid:weiboAccount.usid token:weiboAccount.accessToken completionBlock:^(BOOL success, NSError *error) {
                            if (success) {
                                [AlertWithTip flashSuccessMessage:@"成功绑定开放平台"];
                            }
                            else {
                                [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
                            }
                        }];
                    }
                    else {
                        [[ShareAssistantController sharedInstance] logonOpenPlatform:@"SINA" uid:weiboAccount.usid token:weiboAccount.accessToken];
                    }
                }
            }];
        }
    }
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YYTHD" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YYTHD.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[PushDataController singleTon] bindToApns:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"失败：注册推送: %@", error);
//    [UIAlertView alertViewWithTitle:@"音悦台HD" message:@"注册推送失败"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    BOOL isActive = NO;
    PushItem *pushItem = [[PushDataController singleTon] pushDataParseWithDict:userInfo];
    PushDataItem *pushDataItem = pushItem.data;
    NSString *dataType = pushItem.dataType;
//    PushApsItem *pushApsItem = pushItem.aps;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"message" message:dataType delegate:self cancelButtonTitle:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber] otherButtonTitles:nil];
//    [alert show];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        isActive = YES;
    }
    if (isActive) {
        return;
    }else{
        if ([dataType isEqualToString:@"frontpage"]) {
            //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            HomeViewController *home = [[HomeViewController alloc] init];
            [self.rootController.singleButtonGroup addItem:self.rootController.mlBtn];
            [self.rootController showViewController:home];
            
        }else if ([dataType isEqualToString:@"video"]){
            //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            MVDetailViewController *mvDetailViewController = [[MVDetailViewController alloc] initWithId:pushDataItem.keyId];
            [self.rootController showViewController:mvDetailViewController];
        }else if ([dataType isEqualToString:@"playlist"]){
            //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            MLItem *mlItem = [[MLItem alloc] init];
            mlItem.keyID = [NSNumber numberWithInteger:[pushDataItem.keyId integerValue]];
            MLParticularViewController *mlParticularViewController = [[MLParticularViewController alloc] initWithMLItem:mlItem];
            [self.rootController showViewController:mlParticularViewController];
        }else if ([dataType isEqualToString:@"vchart"]){
            //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            VViewController *vViewController = [[VViewController alloc] initWithCodeDate:pushDataItem.datecode area:pushDataItem.area];
            [self.rootController showViewController:vViewController];
            //        [viewController presentModalViewController:vViewController animated:YES];
        }else if ([dataType isEqualToString:@"subscribe"]){
            self.unReadCount = pushDataItem.unreadCount;
            //        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadCount" object:self.unReadCount];
        }

    }
   
}

@end
