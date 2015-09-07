//
//  PickYueDan.m
//  YYTHD
//
//  Created by 崔海成 on 10/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLList.h"
#import "MLItem.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation MLList
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}
+ (NSValueTransformer *)playListsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MLItem class]];
}
@end
