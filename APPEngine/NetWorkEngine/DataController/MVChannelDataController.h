//
//  MVChannelDataController.h
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
@class MVChannel;
@class MVSearchCondition;
@class MVItem;
@class MVDiscussItem;

@interface MVChannelDataController : BaseDataController

//频道
- (void)getChannelListSuccess:(void(^)(MVChannelDataController *dataController, NSArray *channelList)) success
                      failure:(void(^)(MVChannelDataController *dataController, NSError *error)) failure;

//保存已选频道
- (void)saveSubscribeChannels:(NSArray *)channels
                      success:(void (^)(MVChannelDataController *dataController))success
                      failure:(void (^)(MVChannelDataController *dataController, NSError *error))failure;

/**
 *	@brief	get a array Of MVSearchCondition Objects 
            方法立即调用Success Block,无网络请求。异步接口为以后网络请求做准备。
 */
- (void)getSearchConditionSuccess:(void(^)(MVChannelDataController *dataController, NSArray *conditionList)) success
                          failure:(void(^)(MVChannelDataController *dataController, NSError *error)) failure;


//搜索MV列表
- (void)searchMVListWithChannels:(NSArray *)channels
                searchConditions:(NSSet *)conditionSet
                           range:(NSRange)range
                         success:(void(^)(MVChannelDataController *dataController, NSArray *mvArray))success
                         failure:(void (^)(MVChannelDataController *dataController, NSError *error))failure;
//刷新搜索结果
- (void)refreshSearchResultWithChannels:(NSArray *)channels
                       searchConditions:(NSSet *)conditionSet
                                 length:(NSUInteger)length
                              success:(void(^)(MVChannelDataController *dataController, NSArray *mvArray))success
                              failure:(void (^)(MVChannelDataController *dataController, NSError *error))failure;

//取消请求
- (void)cancelHTTPOperationsWithURL:(NSString *)url;

@end
