//
//  PushItem.m
//  YYTHD
//
//  Created by ssj on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PushItem.h"
#import "PushApsItem.h"
#import "PushDataItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
@implementation PushItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}

+ (NSValueTransformer *)dataJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PushDataItem class]];
}

+ (NSValueTransformer *)apsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PushApsItem class]];
}
@end
