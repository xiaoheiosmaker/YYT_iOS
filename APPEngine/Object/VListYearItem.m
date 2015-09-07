//
//  VListYearItem.m
//  YYTHD
//
//  Created by ssj on 13-10-19.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "VListYearItem.h"
#import "VListMonthItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation VListYearItem
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return nil;
}
+ (NSValueTransformer *)monthModelsJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[VListMonthItem class]];
}

@end
