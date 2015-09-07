//
//  MVChannel.m
//  YYTHD
//
//  Created by IAN on 13-10-12.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVChannel.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation MVChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"channelID" : @"id",
             @"coverURL" : @"coverImage",
             @"subscribed" : @"promo"
             };
    
}

+ (NSValueTransformer *)coverURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)subscribedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (void)subscribeWithUserOrder:(NSNumber *)order
{
    _subscribed = YES;
    _userOrder = order;
}

- (void)unSubscribe
{
    _subscribed = NO;
    //TODO:对userOder进行处理
}

- (NSString *)keyWord
{
    if ([self.channelID integerValue] < 0) {
        return @"@";
    }
    
    return self.name;
}

@end
