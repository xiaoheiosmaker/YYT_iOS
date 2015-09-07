//
//  MLAuthor.m
//  YYTHD
//
//  Created by 崔海成 on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import "MLAuthor.h"

@implementation MLAuthor
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)smallAvatarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)largeAvatarJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
