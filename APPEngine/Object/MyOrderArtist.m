//
//  MyOrderArtist.m
//  YYTHD
//
//  Created by ssj on 13-10-28.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MyOrderArtist.h"
#import "MVItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
@implementation MyOrderArtist
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return nil;
}

+ (NSValueTransformer *)dataJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVItem class]];
}

@end
