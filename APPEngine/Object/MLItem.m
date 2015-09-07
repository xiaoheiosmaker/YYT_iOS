//
//  YueDanList.m
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/8/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVItem.h"
#import "MLItem.h"
#import "MLAuthor.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation MLItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"keyID": @"id",
             @"coverPic": @"thumbnailPic",
             @"author": @"creator",
             };
}

+ (NSValueTransformer *)authorJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MLAuthor class]];
}

+ (NSValueTransformer *)videosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVItem class]];
}

+ (NSValueTransformer *)coverPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)traceUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)clickUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)playUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)playListPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)playListBigPicJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[MLItem class]]) {
        return NO;
    }
    return [self.keyID isEqual:[object keyID]];
}

@end
