//
//  PushDataController.m
//  YYTHD
//
//  Created by shuilin on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "PushDataController.h"
#import "UserDataController.h"
#import "YYTLoginInfo.h"

#define NSStringFromBOOL(aBOOL) aBOOL? @"true" : @"false"

@interface PushDataController ()
{
    
}
@property(retain,nonatomic) PushDataObject* dataObject;//模型数据

- (void)enableCenterPushWithError:(NSError*)error;
- (void)enableSubscribePushWithError:(NSError*)error;

@end

@implementation PushDataController

+ (PushDataController*) singleTon
{
    @synchronized(self)
    {
        static PushDataController* dataController = nil;
        if(dataController == nil)
        {
            dataController = [[PushDataController alloc] init];
        }
        return dataController;
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.dataObject = [[PushDataObject alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.dataObject = nil;
}

- (void)readyCenterPush:(BOOL)bOnCenterPush andSubscribePush:(BOOL)bOnSubscribePush
{
    self.dataObject.enableCenterPush = bOnCenterPush;
    self.dataObject.enableSubscribePush = bOnSubscribePush;
}

//
- (BOOL)bOnCenterPush
{
    return self.dataObject.enableCenterPush;
}

- (BOOL)bOnSubscribePush
{
    return self.dataObject.enableSubscribePush;
}

//
- (void)bindToApns:(NSData *)tokenData
{
    if(tokenData == nil)
    {
        return;
    }
    
    NSString *cacheToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH_DEVICE_TOKEN"];
    if(cacheToken.length > 0)//已经在我们的服务器上成功注册过
    {
        self.dataObject.token = cacheToken;
        NSLog(@"My token is %@", self.dataObject.token);
        return;
    }
    else
    {
        self.dataObject.token = [[[tokenData description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"My token is %@", self.dataObject.token);
        
        [self rebindApns];
    }
}

- (void)rebindApns
{
    if (self.dataObject.token)
    {
        NSDictionary *params;
        UserDataController* userDataController = [UserDataController sharedInstance];
        NSString* access_token = userDataController.loginInfo.access_token;
        if(access_token.length > 0 && userDataController.isLogin)
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      access_token,@"access_token",
                      self.dataObject.token, @"device_token",
                      nil];
        }
        else
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:
                      self.dataObject.token, @"device_token",
                      nil];
        }
        
        [[YYTClient sharedInstance] getPath:URL_ApnsBind parameters:params success:^(id content, id responseObject) {
            
            NSLog(@"Bind Result : %@",responseObject);
            
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSString* message = [responseObject objectForKey:@"message"];
                NSLog(@"message : %@",message);
                
                NSString* successStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
                NSInteger success = [successStr integerValue];
                if(success == 1)
                {
                    //登记成功，本地标志一下
                    [[NSUserDefaults standardUserDefaults] setObject:self.dataObject.token forKey:@"PUSH_DEVICE_TOKEN"];
                }
                else
                {
                    //重试
                }
            }
        } failure:^(id content, NSError *error) {
            
            NSLog(@"Error Bind :%@",error);
            
            //重试
        }];
    }
}

- (void)enableCenterPush:(BOOL)bOn
{
    NSDictionary *params;
    UserDataController* userDataController = [UserDataController sharedInstance];
    NSString* access_token = userDataController.loginInfo.access_token;
    if(access_token.length > 0 && userDataController.isLogin)
    {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  access_token,@"access_token",
                  NSStringFromBOOL(bOn), @"allow_frontpage",
                  NSStringFromBOOL(bOn), @"allow_video",
                  NSStringFromBOOL(bOn), @"allow_playlist",
                  NSStringFromBOOL(bOn), @"allow_vchart",
                  NSStringFromBOOL(bOn), @"allow_message",
                  NSStringFromBOOL(self.dataObject.enableSubscribePush), @"allow_subscribe",
                  NSStringFromBOOL(bOn), @"allow_notification",
                  NSStringFromBOOL(bOn), @"allow_groupmsg",
                  self.dataObject.token, @"device_token",
                  nil];
    }
    else
    {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  NSStringFromBOOL(bOn), @"allow_frontpage",
                  NSStringFromBOOL(bOn), @"allow_video",
                  NSStringFromBOOL(bOn), @"allow_playlist",
                  NSStringFromBOOL(bOn), @"allow_vchart",
                  NSStringFromBOOL(bOn), @"allow_message",
                  NSStringFromBOOL(self.dataObject.enableSubscribePush), @"allow_subscribe",
                  NSStringFromBOOL(bOn), @"allow_notification",
                  NSStringFromBOOL(bOn), @"allow_groupmsg",
                  self.dataObject.token, @"device_token",
                  nil];
    }
    
    
    [[YYTClient sharedInstance] getPath:URL_ApnsSetting parameters:params success:^(id content, id responseObject) {
        
        NSLog(@"Setting Push Result : %@",responseObject);
        
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* message = [responseObject objectForKey:@"message"];
            NSLog(@"message : %@",message);
            
            NSString* successStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
            NSInteger success = [successStr integerValue];
            if(success == 1)
            {
                //设置成功
                NSLog(@"设置推送成功");
                
                //更新模型数据
                self.dataObject.enableCenterPush = bOn;
                
                //通知
                [self enableCenterPushWithError:nil];
            }
            else
            {
                //设置失败
                NSLog(@"设置推送失败");
                NSError* error = [NSError errorWithDomain:@"设置推送失败" code:3333 userInfo:nil];
                [self enableCenterPushWithError:error];
            }
        }
    } failure:^(id content, NSError *error) {
        
        NSLog(@"Error Setting Push :%@",error);
        [self enableCenterPushWithError:error];
        
    }];
}

- (void)enableSubscribePush:(BOOL)bOn
{
    NSDictionary *params;
    UserDataController* userDataController = [UserDataController sharedInstance];
    NSString* access_token = userDataController.loginInfo.access_token;
    if(access_token.length > 0 && userDataController.isLogin)
    {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  access_token,@"access_token",
                  self.dataObject.token, @"device_token",
                  NSStringFromBOOL(NO), @"allow_frontpage",
                  NSStringFromBOOL(NO), @"allow_video",
                  NSStringFromBOOL(NO), @"allow_playlist",
                  NSStringFromBOOL(NO), @"allow_vchart",
                  NSStringFromBOOL(NO), @"allow_message",
                  NSStringFromBOOL(bOn), @"allow_subscribe",
                  NSStringFromBOOL(self.dataObject.enableCenterPush), @"allow_notification",
                  NSStringFromBOOL(NO), @"allow_groupmsg",
                  nil];
    }
    else
    {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  self.dataObject.token, @"device_token",
                  NSStringFromBOOL(NO), @"allow_frontpage",
                  NSStringFromBOOL(NO), @"allow_video",
                  NSStringFromBOOL(NO), @"allow_playlist",
                  NSStringFromBOOL(NO), @"allow_vchart",
                  NSStringFromBOOL(NO), @"allow_message",
                  NSStringFromBOOL(bOn), @"allow_subscribe",
                  NSStringFromBOOL(self.dataObject.enableCenterPush), @"allow_notification",
                  NSStringFromBOOL(NO), @"allow_groupmsg",
                  nil];
    }
    
    [[YYTClient sharedInstance] getPath:URL_ApnsSetting parameters:params success:^(id content, id responseObject) {
        
        NSLog(@"Setting Push Result : %@",responseObject);
        
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString* message = [responseObject objectForKey:@"message"];
            NSLog(@"message : %@",message);
            
            NSString* successStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
            NSInteger success = [successStr integerValue];
            if(success == 1)
            {
                //设置成功
                NSLog(@"设置推送成功");
                self.dataObject.enableSubscribePush = bOn;
                [self enableSubscribePushWithError:nil];
            }
            else
            {
                //设置失败
                NSLog(@"设置推送失败");
                NSError* error = [NSError errorWithDomain:@"设置推送失败" code:3333 userInfo:nil];
                [self enableSubscribePushWithError:error];
            }
        }
    } failure:^(id content, NSError *error) {
        
        NSLog(@"Error Setting Push :%@",error);
        [self enableSubscribePushWithError:error];
        
    }];
}

- (void)enableCenterPushWithError:(NSError *)error
{
    NSUInteger count = [self countOfObservers];
    for(NSUInteger i = 0 ; i < count; i++)
    {
        id observer = [self observerAtIndex:i];
        if([observer respondsToSelector:@selector(pushDataController:enableCenterPushWithError:)])
        {
            [observer pushDataController:self enableCenterPushWithError:error];
        }
    }
}

- (void)enableSubscribePushWithError:(NSError *)error
{
    NSUInteger count = [self countOfObservers];
    for(NSUInteger i = 0 ; i < count; i++)
    {
        id observer = [self observerAtIndex:i];
        if([observer respondsToSelector:@selector(pushDataController:enableSubscribePushWithError:)])
        {
            [observer pushDataController:self enableSubscribePushWithError:error];
        }
    }
}

- (PushItem *)pushDataParseWithDict:(NSDictionary *)dict{
    NSError *error;
    PushItem *pushItem = [MTLJSONAdapter modelOfClass:[PushItem class] fromJSONDictionary:dict error:&error];
    return pushItem;
}

@end
