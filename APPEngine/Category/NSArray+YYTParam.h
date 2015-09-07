//
//  NSArray+YYTParam.h
//  YYTHD
//
//  Created by IAN on 13-10-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

//转化数组为服务器所需要的参数格式
@interface NSArray (YYTParam)

//使用,拼接数组元素，每个元素使用transformer转换为string类型
- (NSString *)yytParamWithTransformer:(NSString *(^)(id object, NSUInteger idx))transformer;

//取得range范围的数组，超出数组长度没有异常抛出
- (NSArray *)safeSubarrayWithRange:(NSRange)range;

@end