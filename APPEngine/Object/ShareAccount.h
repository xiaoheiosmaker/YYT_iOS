//
//  ShareAccount.h
//  YYTHD
//
//  Created by shuilin on 11/2/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Login_Status,   //已登录
    Logout_Status,  //未登录
}ShareAccountStatus;

@interface ShareAccount : NSObject
{
    
}
@property(assign,nonatomic) ShareAccountStatus status;
@property(retain,nonatomic) NSString* token;
@property(retain,nonatomic) NSString* name; //昵称
@end
