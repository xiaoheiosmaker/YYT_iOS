//
//  MVDiscussItem.m
//  YYTHD
//
//  Created by ssj on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVDiscussItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import "MVDiscussComment.h"

@implementation MVDiscussItem
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return nil;
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVDiscussComment class]];
}

@end
