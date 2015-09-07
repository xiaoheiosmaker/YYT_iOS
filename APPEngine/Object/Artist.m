//
//  Aritst.m
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "Artist.h"

@implementation Artist

- (instancetype)initWithID:(NSString *)keyID name:(NSString *)name
{
    if (self = [super init]) {
        self->_keyID = [keyID copy];
        self->_name = [name copy];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"keyID": @"id",
             };
}

@end
