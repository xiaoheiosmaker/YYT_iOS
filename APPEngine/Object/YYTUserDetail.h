//
//  YYTUserDetail.h
//  YYTHD
//
//  Created by 崔海成 on 11/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTUserDetail : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong)NSNumber *uid;
@property (nonatomic, copy)NSString *email;
@property (nonatomic) BOOL emailVerified;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *description;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *smallAvatar;
@property (nonatomic, copy)NSString *largeAvatar;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *createdAt;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, strong)NSNumber *bindStatus;
@property (nonatomic, strong)NSNumber *credits;
@property (nonatomic) BOOL signIn;
@property (nonatomic, strong)NSNumber *signInContinuousDays;
@property (nonatomic, copy)NSString *woMedalSmallcon;
@property (nonatomic, copy)NSArray *bind;
@end
