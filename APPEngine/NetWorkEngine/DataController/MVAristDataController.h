//
//  MVAristDataController.h
//  YYTHD
//
//  Created by ssj on 13-10-25.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"

@class ArtistShow;
@class MyOrderArtist;
@interface MVAristDataController : BaseDataController

//获取我订阅的艺人
- (void)getArtistSubscribeMeSuccess:(void (^)(MVAristDataController *dataController,NSArray *artistArray))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;

//查看艺人详情
- (void)getArtistDetailWithArtistParams:(NSDictionary *)params success:(void (^)(MVAristDataController *dataController,ArtistShow *artistShow))success failure:(void (^)(MVAristDataController *dataController,NSError*error))failure;

//订阅一个艺人
- (void)createArtistWithArtistID:(NSString *)artistId success:(void (^)(MVAristDataController *dataController,NSDictionary * responseDict))success failure:(void (^)(MVAristDataController *dataController,NSError*error))failure;

//删除订阅一个艺人
- (void)deleteArtistWithArtistID:(NSString *)artistId success:(void (^)(MVAristDataController *dataController,NSDictionary * responseDict))success failure:(void (^)(MVAristDataController *dataController,NSError*error))failure;

//获取订阅信息
- (void)getArtistOrderMessage:(NSDictionary *)params success:(void (^)(MVAristDataController *dataController,MyOrderArtist *orderArtist))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;

//搜索视频
- (void)searchByParams:(NSDictionary *)params success:(void (^)(MVAristDataController *dataController,NSArray *videoArray))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;

//获取推荐艺人

- (void)getSuggestArtistWithParams:(NSDictionary *)params success:(void(^)(MVAristDataController *dataController, NSArray *artistArray))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;

//搜索艺人
- (void)searchArtistByParams:(NSDictionary *)params success:(void(^)(MVAristDataController *dataController, NSArray *artistArray))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;

//批量订阅艺人
- (void)orderBatchByArtistIds:(NSArray *)artistIds success:(void(^)(MVAristDataController *dataController, NSDictionary *responseDict))success failure:(void (^)(MVAristDataController *dataController,NSError *error))failure;


@end
