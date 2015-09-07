//
//  OperationResult.m
//  YYTHD
//
//  Created by 崔海成 on 1/24/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "OperationResult.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation OperationResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)successJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
