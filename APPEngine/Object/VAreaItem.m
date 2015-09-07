//
//  VListItem.m
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "VAreaItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation VAreaItem
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"areaName": @"name",
             };
}


@end
