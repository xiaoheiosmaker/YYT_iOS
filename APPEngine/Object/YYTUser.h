//
//  YYTUser.h
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTUser : MTLModel <MTLJSONSerializing>

@property (nonatomic,retain) NSNumber *uid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSURL *smallAvatar;
@property (nonatomic, strong) NSURL *largeAvatar;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, retain) NSNumber *createdAt;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, retain) NSNumber *bindStatus;

@end
