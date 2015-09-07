//
//  NSArray+YYTParam.m
//  YYTHD
//
//  Created by IAN on 13-10-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "NSArray+YYTParam.h"

@implementation NSArray (YYTParam)

- (NSString *)yytParamWithTransformer:(NSString *(^)(id, NSUInteger))transformer
{
    NSMutableString *str = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *objStr = transformer(obj, idx);
        if ([objStr length] > 0) {
            [str appendFormat:@"%@,",objStr];
        }
    }];
    if ([str length] > 0) {
        //去除最后一个,分隔符
        [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
    }
    
    return str;
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
    //判断range范围是否超出数据长度
    NSRange resultRange = range;
    if (NSMaxRange(range) > [self count]) {
        NSRange locRange = NSMakeRange(0, self.count);
        resultRange = NSIntersectionRange(locRange, range);
    }
    
    return [self subarrayWithRange:resultRange];
}

@end
