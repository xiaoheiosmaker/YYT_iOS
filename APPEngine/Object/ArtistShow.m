
//
//  ArtistShow.m
//  YYTHD
//
//  Created by ssj on 13-10-25.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistShow.h"
#import "MVItem.h"
#import "Artist.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation ArtistShow

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return nil;
}

+ (NSValueTransformer *)artistJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Artist class]];
}

+ (NSValueTransformer *)videosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MVItem class]];
}


@end
