//
//  VListItem.m
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "VListItem.h"
#import "MVOfVListItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
@implementation VListItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSValueTransformer *)programJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MVItem class]];
}

+ (NSValueTransformer *)videosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVItem class]];
}

@end
