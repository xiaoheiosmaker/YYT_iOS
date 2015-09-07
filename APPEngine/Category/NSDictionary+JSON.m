//
//  NSDictionary+JSON.m
//  YYTHD
//
//  Created by IAN on 14-1-6.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString *)JSONString
{
    NSMutableString *str = [@"{" mutableCopy];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *objStr = nil;
        if ([obj respondsToSelector:@selector(stringValue)]) {
            objStr = [obj stringValue];
        }
        else {
            objStr = [obj description];
        }
        
        [str appendFormat:@"%@:%@, ",key,objStr];
    }];
    
    [str deleteCharactersInRange:NSMakeRange(str.length-2, 2)];
    
    [str appendString:@"}"];
    
    return str;
}

@end
