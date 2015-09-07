//
//  SocialPlatformAssistantController.m
//  YYTHD
//
//  Created by 崔海成 on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SocialPlatformAssistantController.h"
@interface SocialPlatformAssistantController()
- (NSString *)switchToUM:(SocialPlatformType)socialPlatformType;
@end

@implementation SocialPlatformAssistantController
+ (SocialPlatformAssistantController *)sharedInstance
{
    static SocialPlatformAssistantController *instance;
    if (!instance) {
        instance = [[super allocWithZone:nil] init];
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (void)bindingPlatform:(SocialPlatformType)socialPlatformType
{
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[self switchToUM:socialPlatformType]].loginClickHandler([self rootViewController], [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[self switchToUM:socialPlatformType]];
            NSLog(@"username is %@, uid is %@, token is %@", snsAccount.userName, snsAccount.usid, snsAccount.accessToken);
        }
    });
}

- (NSString *)switchToUM:(SocialPlatformType)socialPlatformType
{
    NSArray *array = [NSArray arrayWithObjects:UMShareToSina, UMShareToQzone, UMShareToTencent, UMShareToWechatTimeline, nil];
    return [array objectAtIndex:socialPlatformType];
}
@end
