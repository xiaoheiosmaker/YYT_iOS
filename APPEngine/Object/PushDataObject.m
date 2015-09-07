//
//  PushDataObject.m
//  YYTHD
//
//  Created by shuilin on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "PushDataObject.h"

@implementation PushDataObject

- (void)dealloc
{
    self.token = nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    PushDataObject *copy = [[[self class] allocWithZone: zone] init];
    
    copy.enableSubscribePush = self.enableSubscribePush;
    copy.enableCenterPush = self.enableCenterPush;
   
    copy.token = [self.token copyWithZone:zone];
    
    return copy;
}
@end
