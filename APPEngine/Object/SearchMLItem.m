//
//  SearchMLItem.m
//  YYTHD
//
//  Created by ssj on 14-1-23.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "SearchMLItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
@implementation SearchMLItem
+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{};
}
+ (NSValueTransformer *)playListsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MLItem class]];
}

+ (NSValueTransformer *)appsModelJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SearchAppsModel class]];
}
@end
