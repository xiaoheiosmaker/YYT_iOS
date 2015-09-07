//
//  MVChannelDataController.m
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVChannelDataController.h"
#import "MVItem.h"
#import "MVSearchCondition.h"
#import "MVChannel.h"
#import "NetWorkAPI.h"
#import "UserDataController.h"

@interface MVChannelDataController ()

@property(nonatomic, strong)NSDictionary *cdiParams;
@property(nonatomic, strong)NSMutableArray *mvList;
@property(nonatomic, strong)NSArray *channelList;

@end


@implementation MVChannelDataController

- (id)init
{
    self = [super init];
    if (self) {
        _mvList = nil;
        _channelList = nil;
        
        _cdiParams = [NSDictionary dictionary]; //初始化一个空字典，表示无任何搜索条件
    }
    
    return self;
}

- (void)cancelHTTPOperationsWithURL:(NSString *)url
{
    [[YYTClient sharedInstance] cancelAllHTTPOperationsWithMethod:nil path:url];
}

#pragma mark - 频道
- (void)getChannelListSuccess:(void (^)(MVChannelDataController *, NSArray *))success failure:(void (^)(MVChannelDataController *, NSError *))failure
{
    if ([_channelList count]) {
        success(self, _channelList);
        return;
    }
    
    //发送请求
    __weak MVChannelDataController *weekSelf = self;
    [[YYTClient sharedInstance] getPath:URL_MVChannel_List parameters:nil success:^(id content, id responseObject) {
        //解析
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *jArray = responseObject[@"channels"];
            NSError *error = nil;
            NSArray *channels = [weekSelf channelListParserFromJSONArray:jArray error:&error];
            if (error) {
                failure(weekSelf, error);
                return;
            }
            weekSelf.channelList = [channels copy];
            success(weekSelf, channels);
        }
        
    } failure:^(id content, NSError *error) {
        failure(weekSelf, error);
    }];
}

- (void)saveSubscribeChannels:(NSArray *)channels success:(void (^)(MVChannelDataController *))success failure:(void (^)(MVChannelDataController *, NSError *))failure
{
    //判断登录
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        failure(self, error);
        return;
    }
    
    //保存到服务器
    NSString *ids = [channels yytParamWithTransformer:^NSString *(id object, NSUInteger idx) {
        NSString *string = [NSString stringWithFormat:@"%@_%u",[object channelID],idx];
        return string;
    }];
    NSDictionary *params = @{@"id": ids};
    __weak MVChannelDataController *weekSelf = self;
    [[YYTClient sharedInstance] getPath:URL_MVChannel_Subscribe parameters:params success:^(id content, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSNumber *result = responseDic[@"success"];
            NSString *message = responseDic[@"message"];
            if ([result boolValue]) {
                //保存成功
                [weekSelf saveSubscribeChannels:channels];
                success(weekSelf);
            } else {
                NSError *error = [NSError yytOperErrorWithMessage:message];
                failure(weekSelf, error);
            }
        }
    } failure:^(id content, NSError *error) {
        failure(weekSelf, error);
    }];
}

- (void)saveSubscribeChannels:(NSArray *)array
{
    NSInteger index = 0;
    for (MVChannel *channel in _channelList) {
        if ([array containsObject:channel]) {
            NSNumber *order = [NSNumber numberWithInteger:index++];
            [channel subscribeWithUserOrder:order];
        } else {
            [channel unSubscribe];
        }
    }
}

#pragma mark - 搜索条件
- (void)getSearchConditionSuccess:(void (^)(MVChannelDataController *, NSArray *))success failure:(void (^)(MVChannelDataController *, NSError *))failure
{
    MVSearchCondition *videoTypeCondition = [MVSearchCondition videoTypeCondition];
    [videoTypeCondition selectOptionAtIndex:1]; //默认官方版
    
    NSArray *array = @[[MVSearchCondition singerTypeCondition], videoTypeCondition, [MVSearchCondition tagCondition]];
    __weak MVChannelDataController *weekSelf = self;
    success(weekSelf, array);
}

#pragma mark - 搜索
- (NSMutableDictionary *)paramsDicWithChannels:(NSArray *)channels searchConditions:(NSSet *)conditionSet
{
    //搜索条件，将MVSearchConditionSet转化为请求用的字典类型
    NSMutableDictionary *cdiParams = [NSMutableDictionary dictionary];
    
    [conditionSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[MVSearchCondition class]]) {
            NSDictionary *dic = [obj resultForSever];
            if ([dic count]>0) {
                [cdiParams addEntriesFromDictionary:dic];
            }
        }
        *stop = NO;
    }];
    
    //加入频道条件
    NSString *channelName = [channels yytParamWithTransformer:^NSString *(id object, NSUInteger idx) {
        MVChannel *channel = object;
        return [channel keyWord];
    }];
    channelName = [channelName stringByReplacingOccurrencesOfString:@"," withString:@" "];
    [cdiParams addEntriesFromDictionary:@{@"channelName": channelName}];
    
    return cdiParams;
}

- (void)searchMVListWithChannels:(NSArray *)channels searchConditions:(NSSet *)conditionSet range:(NSRange)range success:(void (^)(MVChannelDataController *, NSArray *))success failure:(void (^)(MVChannelDataController *, NSError *))failure
{
    __weak MVChannelDataController *weekSelf = self;
    
    NSMutableDictionary *cdiParams = [self paramsDicWithChannels:channels searchConditions:conditionSet];
    
    NSRange requestRange;
    if ([_cdiParams isEqualToDictionary:cdiParams]) {
        //搜索条件相同，试图访问缓存数据
        //默认缓存数据是连续的
        NSInteger maxIndex = range.location + range.length;
        NSInteger locCount = [_mvList count];
        if ((locCount >= maxIndex)) {
            //返回缓存数据
            NSArray *array = [_mvList subarrayWithRange:range];
            success(weekSelf, array);
            return;
        }
        
        //仅请求缺少的数据
        requestRange = NSMakeRange(locCount, maxIndex-locCount);
    }
    else {
        //搜索条件不同，清除缓存，重新请求数据
        requestRange = NSUnionRange(NSMakeRange(0, [_mvList count]), range);
        [self refreshSearchResultWithChannels:channels searchConditions:conditionSet length:requestRange.length success:^(MVChannelDataController *dataController, NSArray *mvArray) {
            NSArray *array = [mvArray safeSubarrayWithRange:range];
            success(weekSelf, array);
        } failure:^(MVChannelDataController *dataController, NSError *error) {
            failure(weekSelf, error);
        }];
        
        return;
    }
    
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:cdiParams];
    [params addEntriesFromDictionary:@{@"offset": [NSNumber numberWithUnsignedInteger:requestRange.location], @"size": [NSNumber numberWithUnsignedInteger:requestRange.length]}];
    
    //发送请求
    [[YYTClient sharedInstance] getPath:URL_MVChannel_Videos
                             parameters:params
                                success:^(id content, id responseObject){
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSArray *jArray = responseObject[@"videos"];
                                        NSError *error = nil;
                                        NSArray *responseArray = [weekSelf searchParserFromJSONArray:jArray error:&error];
                                        if (error) {
                                            failure(weekSelf, error);
                                            return;
                                        }
                                        
                                        //保存缓存
                                        [weekSelf.mvList addObjectsFromArray:responseArray];
                                        //返回Range范围数组
                                        NSArray *array = [weekSelf.mvList safeSubarrayWithRange:range];
                                        success(weekSelf, array);
                                    }
                                }
                                failure:^(id content, NSError *error){
                                    failure(weekSelf, error);
                                }];
}

- (void)refreshSearchResultWithChannels:(NSArray *)channels searchConditions:(NSSet *)conditionSet length:(NSUInteger)length success:(void (^)(MVChannelDataController *, NSArray *))success failure:(void (^)(MVChannelDataController *, NSError *))failure
{
    //发送请求
    __weak MVChannelDataController *weekSelf = self;
    NSDictionary *cdiParams = [self paramsDicWithChannels:channels searchConditions:conditionSet];
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:cdiParams];
    [params addEntriesFromDictionary:@{@"offset": [NSNumber numberWithUnsignedInteger:0], @"size": [NSNumber numberWithUnsignedInteger:length]}];
    
    [[YYTClient sharedInstance] getPath:URL_MVChannel_Videos
                             parameters:params
                                success:^(id content, id responseObject){
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        NSArray *jArray = responseObject[@"videos"];
                                        NSError *error = nil;
                                        NSArray *responseArray = [weekSelf searchParserFromJSONArray:jArray error:&error];
                                        if (error) {
                                            failure(weekSelf, error);
                                            return;
                                        }
                                        //更新
                                        weekSelf.mvList = [responseArray mutableCopy];
                                        weekSelf.cdiParams = cdiParams;
                                        
                                        //返回
                                        NSArray *array = [weekSelf.mvList safeSubarrayWithRange:NSMakeRange(0, length)];
                                        success(weekSelf, array);
                                    }
                                }
                                failure:^(id content, NSError *error){
                                    failure(weekSelf, error);
                                }];
}

#pragma mark - 解析
- (NSArray *)channelListParserFromJSONArray:(NSArray *)jsonArray error:(NSError **)error
{
    //*error = nil;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:jsonArray.count];
    for (NSDictionary *channelDic in jsonArray) {
        MVChannel *item  = [MTLJSONAdapter modelOfClass:[MVChannel class] fromJSONDictionary:channelDic error:error];
        if (*error) {
            return nil;
        }
        [result addObject:item];
    }
    return result;
}

- (NSArray *)searchParserFromJSONArray:(NSArray *)jsonArray error:(NSError **)error
{
    //*error = nil;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:jsonArray.count];
    for (NSDictionary *videoDic in jsonArray) {
        MVItem *item  = [MTLJSONAdapter modelOfClass:[MVItem class] fromJSONDictionary:videoDic error:error];
        if (*error) {
            return nil;
        }
        [result addObject:item];
    }
    
    return result;
}

@end
