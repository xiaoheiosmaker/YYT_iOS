//
//  Aritst.h
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *keyID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *aliasName;
@property (nonatomic, copy, readonly) NSString *smallAvatar;
@property (nonatomic, copy, readonly) NSString *area;
@property (nonatomic, copy, readonly) NSString *videoCount;
@property (nonatomic, copy, readonly) NSString *fanCount;
@property (nonatomic, copy, readonly) NSString *subCount;
@property (nonatomic, copy, readonly) NSString *sub;

- (instancetype)initWithID:(NSString *)keyID name:(NSString *)name;

@end
