//
//  MVDataController.h
//  YYTHD
//
//  Created by IAN on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
@class MVItem;
@class MVDiscussItem;

@interface MVDataController : BaseDataController

+ (MVDataController *)sharedDataController;

//获取音悦台MV区域信息
- (void)getMVAreasWithCompletion:(void(^)(NSArray *, NSError *))completion;

//获取视频列表数据
- (void)loadMVListWithAreaCode:(NSString *)areaCode range:(NSRange)range completion:(void(^)(NSArray *, NSError *))completion;

//获取收藏
- (void)getCollectionsWithRange:(NSRange)range
              completionHandler:(void(^)(NSArray *collections, NSError *error))completionHandler;

//刷新收藏数据
- (void)refreshCollectionsWithlength:(NSUInteger)length
                  completionHandler:(void(^)(NSArray *collections, NSError *error))completionHandler;

//删除收藏
- (void)removeCollection:(MVItem *)item withCompletionHandler:(void(^)(NSArray *collections, NSError *error))completionHandler;
- (void)removeCollections:(NSArray *)items withCompletionHandler:(void (^)(NSArray *collections, NSError *error))completionHandler;

//添加收藏
- (void)addCollection:(MVItem *)item withCompletionHandler:(void(^)(NSString *message, NSError *error))completionHandler;
- (void)addCollections:(NSArray *)items withCompletionHandler:(void (^)(NSString *message, NSError *error))completionHandler;

//mv详情
- (void)getMVDetailWithID:(NSString *)viewId
                  Success:(void(^)(MVDataController *dataController, MVItem *mvItem))success
                  failure:(void (^)(MVDataController *dataController, NSError *error))failure;
//mv评论
- (void)getMVDiscussWithParams:(NSDictionary *)params Success:(void(^)(MVDataController *dataController, MVDiscussItem *mvDiscuss))success
                       failure:(void (^)(MVDataController *dataController, NSError *error))failure;

//发表评论  params包括  videoID repliedId content
- (void)postMVCommentWithParams:(NSDictionary *)params success:(void(^)(MVDataController *dataControllerl,NSDictionary * responseDict))success failure:(void (^)(MVDataController *dataController, NSError *error))farlure;

@end
