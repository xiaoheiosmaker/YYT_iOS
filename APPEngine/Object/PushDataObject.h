//
//  PushDataObject.h
//  YYTHD
//
//  Created by shuilin on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushDataObject : NSObject
{
    
}
@property(retain,nonatomic) NSString* token;
@property(assign,nonatomic) BOOL enableCenterPush;
@property(assign,nonatomic) BOOL enableSubscribePush;
@end
