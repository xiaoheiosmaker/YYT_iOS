//
//  OpenSocialPlatformBind.h
//  YYTHD
//
//  Created by 崔海成 on 11/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenSocialPlatformBind : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy)NSString *opType;
@property (nonatomic, copy)NSString *token;
@property (nonatomic, strong)NSNumber *shareConf;
@property (nonatomic, copy)NSString *openuid;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *headImage;
@property (nonatomic, copy)NSString *bigHeadImage;

@end
