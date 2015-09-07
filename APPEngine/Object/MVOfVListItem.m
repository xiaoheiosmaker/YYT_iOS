//
//  MVOfVListItem.m
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVOfVListItem.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>
@implementation MVOfVListItem

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
        @"keyID": @"id",
        @"describ": @"description"
    };
}

//+ (NSValueTransformer *)urlJSONTransformer
//{
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}



@end
