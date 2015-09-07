//
//  NewsDataController.m
//  YYTHD
//
//  Created by IAN on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsDataController.h"
#import "NewsItem.h"

@implementation NewsDataController

- (id)init
{
    if (self = [super init]) {
        _newsData = [NSMutableDictionary dictionaryWithCapacity:6];
    }
    return self;
}


- (NSMutableArray *)getNewsListWithType:(YYTNewsType)newsType
{
    NSString *key = [self dataKeyFromType:newsType];
    NSMutableArray *array = [_newsData objectForKey:key];
    return array;
}

- (NSArray *)getNewsListWithType:(YYTNewsType)newsType range:(NSRange)range
{
    NSArray *array = [self getNewsListWithType:newsType];
    if (range.location < array.count) {
        NSInteger length = array.count - range.location;
        if (length < range.length) {
            range.length = length;
        }
        return [array subarrayWithRange:range];
    }
    return nil;
}

- (void)saveNewsList:(NSArray *)newsList withType:(YYTNewsType)newsType locatedIndex:(NSInteger)index
{
    NSMutableArray *array = [self getNewsListWithType:newsType];
    if (!array || index==0) {
        array = [newsList mutableCopy];
        NSString *key = [self dataKeyFromType:newsType];
        [_newsData setObject:array forKey:key];
        return;
    }
    
    //处理的不完全
    [array addObjectsFromArray:newsList];
}


- (NSString *)dataKeyFromType:(YYTNewsType)newsType
{
    NSString *key = nil;
    switch (newsType) {
        case YYTNewsTypeML:
            key = @"YYTNewsTypeML";
            break;
        case YYTNewsTypeHK:
            key = @"YYTNewsTypeHK";
            break;
        case YYTNewsTypeEU:
            key = @"YYTNewsTypeEU";
            break;
        case YYTNewsTypeSK:
            key = @"YYTNewsTypeSK";
            break;
        case YYTNewsTypeJP:
            key = @"YYTNewsTypeJP";
            break;
        case YYTNewsTypeEX:
            key = @"YYTNewsTypeEX";
            break;
    }
    
    return key;
}


- (void)getNewsListWithType:(YYTNewsType)newsType range:(NSRange)range completionHandler:(void (^)(NSArray *, NSError *))handler
{
    if (!handler) {
        return;
    }
    
    NSRange requestRange = range;
    NSMutableArray *newsList = [self getNewsListWithType:newsType];
    NSUInteger max = NSMaxRange(range);
    if ([newsList count] > max) {
        NSArray *array = [newsList subarrayWithRange:range];
        handler(array, nil);
    }
    else {
        if (requestRange.location != [newsList count]) {
            requestRange.location = [newsList count];
            requestRange.length = max - requestRange.location;
        }
    }
    
    
    NSString *typeParam = [self paramValueFromNewsType:newsType];
    NSDictionary *params = @{@"type": typeParam,
                             @"offset": @(requestRange.location),
                             @"size": @(requestRange.length)};
    
    
    __weak NewsDataController *weekSelf = self;
    [[YYTClient sharedInstance] getPath:URL_News_List
                             parameters:params
                                success:^(id content, id responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSArray *data = responseObject[@"data"];
                                        NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:data.count];
                                        
                                        NSError *error = nil;
                                        for (NSDictionary *newsDic in data) {
                                            NewsItem *item = [MTLJSONAdapter modelOfClass:[NewsItem class] fromJSONDictionary:newsDic error:&error];
                                            NSAssert(!error,@"NewsItem解析错误:%@",error);
                                            [itemList addObject:item];
                                        }
                                        
                                        [weekSelf saveNewsList:itemList withType:newsType locatedIndex:requestRange.location];
                                        if (handler) {
                                            handler([weekSelf getNewsListWithType:newsType range:range], nil);
                                        }
                                    }
                                }
                                failure:^(id content, NSError *error) {
                                    if (handler) {
                                        handler(nil, error);
                                    }
                                }];
}

- (void)refreshNewsListWithType:(YYTNewsType)newsType length:(NSInteger)length completionHandler:(void (^)(NSArray *, NSError *))handler
{
    NSString *typeParam = [self paramValueFromNewsType:newsType];
    NSDictionary *params = @{@"type": typeParam,
                             @"offset": @0,
                             @"size": @(length)};
    
    
    __weak NewsDataController *weekSelf = self;
    [[YYTClient sharedInstance] getPath:URL_News_List
                             parameters:params
                                success:^(id content, id responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSArray *data = responseObject[@"data"];
                                        NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:data.count];
                                        
                                        NSError *error = nil;
                                        for (NSDictionary *newsDic in data) {
                                            NewsItem *item = [MTLJSONAdapter modelOfClass:[NewsItem class] fromJSONDictionary:newsDic error:&error];
                                            NSAssert(!error,@"NewsItem解析错误:%@",error);
                                            [itemList addObject:item];
                                        }
                                        
                                        [weekSelf saveNewsList:itemList withType:newsType locatedIndex:0];
                                        if (handler) {
                                            handler(itemList, nil);
                                        }
                                    }
                                }
                                failure:^(id content, NSError *error) {
                                    if (handler) {
                                        handler(nil, error);
                                    }
                                }];
}



- (void)getNewsDetailWithID:(NSNumber *)newsID completionHandler:(void (^)(NewsItem *, NSError *))handler
{
    if (!handler) {
        return;
    }
    
    NSDictionary *params = @{@"id": newsID};
    [[YYTClient sharedInstance] getPath:URL_News_Detail
                             parameters:params
                                success:^(id content, id responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSError *error = nil;
                                        NewsItem *item = [MTLJSONAdapter modelOfClass:[NewsItem class] fromJSONDictionary:responseObject error:&error];
                                        NSAssert(!error,@"NewsItem解析错误:%@",error);
                                        handler(item, nil);
                                    }
                                }
                                failure:^(id content, NSError *error) {
                                    handler(nil, error);
                                }];
}



//内地:neidi,港台:gangtai,欧美:oumei,韩国:hanguo,日本:riben,独家:dujia
- (NSString *)paramValueFromNewsType:(YYTNewsType)type
{
    NSString *param = nil;
    switch (type) {
        case YYTNewsTypeML:
            param = @"neidi";
            break;
        case YYTNewsTypeHK:
            param = @"gangtai";
            break;
        case YYTNewsTypeEU:
            param = @"oumei";
            break;
        case YYTNewsTypeSK:
            param = @"hanguo";
            break;
        case YYTNewsTypeJP:
            param = @"riben";
            break;
        case YYTNewsTypeEX:
            param = @"dujia";
            break;
    }
    
    return param;
}


@end
