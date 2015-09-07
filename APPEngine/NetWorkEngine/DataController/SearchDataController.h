//
//  SearchDataController.h
//  YYTHD
//
//  Created by ssj on 13-11-1.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
#import "SearchMLItem.h"

@interface SearchDataController : BaseDataController

//搜索视频
- (void)searchVideoByParam:(NSDictionary *)params success:(void (^)(SearchDataController *dataController,NSArray *videoArray))success failure:(void (^)(SearchDataController *dataController,NSError *error))failure;

//搜索艺人
- (void)searchArtistByParam:(NSDictionary *)params success:(void (^)(SearchDataController *dataController,NSArray *artistArray))success failure:(void (^)(SearchDataController *dataController,NSError *error))failure;

//搜索自动补全
- (void)searchSuggestByKeyWord:(NSString *)keyWord success:(void (^)(SearchDataController *dataController,NSArray *suggestArray))success failure:(void (^)(SearchDataController *dataController,NSError *error))failure;
//搜索推荐
- (void)searchRecommendSuccess:(void (^)(SearchDataController *dataController,NSArray *recommendArray))success failure:(void (^)(SearchDataController *dataController,NSError *error))failure;

//搜索悦单
- (void)searchPlayListByParam:(NSDictionary *)params success:(void (^)(SearchDataController *dataController,SearchMLItem *searchMLItem))success failure:(void (^)(SearchDataController *dataController,NSError *error))failure;

//获取热门搜索关键词
- (void)searchTopKeyWordByCount:(NSString *)count success:(void (^)(SearchDataController *dataController,NSArray *nameList))success failure:(void (^)(SearchDataController *dataController, NSError *error))failure;
@end
