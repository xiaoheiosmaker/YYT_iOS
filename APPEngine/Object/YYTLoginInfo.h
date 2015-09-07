//
//  YYTLoginInfo.h
//  YYTHD
//
//  Created by 崔海成 on 10/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYTUserDetail.h"

@interface YYTLoginInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) YYTUserDetail *user;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) NSString *expires_in;
@property (nonatomic, strong) NSString *refresh_token;
@property(nonatomic,assign) BOOL isLogin;

@end
