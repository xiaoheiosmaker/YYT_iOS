//
//  YYTUserDetail.m
//  YYTHD
//
//  Created by 崔海成 on 11/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTUserDetail.h"
#import "OpenSocialPlatformBind.h"
#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation YYTUserDetail
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)emailVerifiedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)signInJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)bindJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[OpenSocialPlatformBind class]];
}
@end
