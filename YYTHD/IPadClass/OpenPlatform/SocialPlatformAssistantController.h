//
//  SocialPlatformAssistantController.h
//  YYTHD
//
//  Created by 崔海成 on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAssistantController.h"
typedef enum {
    SocialPlatformTypeSina = 0,
    SocialPlatformTypeQzone,
    SocialPlatformTypeTencent,
    SocialPlatformTypeRenren,
    // SocialPlatformTypeWechatTimeline
} SocialPlatformType;

@interface SocialPlatformAssistantController : BaseAssistantController
+ (SocialPlatformAssistantController *)sharedInstance;
- (void)bindingPlatform:(SocialPlatformType)socialPlatformType;
- (void)debingingPlatform:(SocialPlatformType)socialPlatformType;
@end
