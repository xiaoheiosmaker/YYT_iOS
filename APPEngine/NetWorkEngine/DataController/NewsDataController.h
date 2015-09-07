//
//  NewsDataController.h
//  YYTHD
//
//  Created by IAN on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"

typedef NS_ENUM(NSInteger, YYTNewsType) {
    YYTNewsTypeML = 0,
    YYTNewsTypeHK,
    YYTNewsTypeEU,
    YYTNewsTypeSK,
    YYTNewsTypeJP,
    YYTNewsTypeEX,
};

@class NewsItem;

@interface NewsDataController : BaseDataController
{
    NSMutableDictionary *_newsData;
}

- (void)getNewsListWithType:(YYTNewsType)newsType range:(NSRange)range completionHandler:(void(^)(NSArray *newsList, NSError *error))handler;
- (void)refreshNewsListWithType:(YYTNewsType)newsType length:(NSInteger)length completionHandler:(void(^)(NSArray *newsList, NSError *error))handler;

- (void)getNewsDetailWithID:(NSNumber *)newsID completionHandler:(void(^)(NewsItem *item, NSError *error))handler;

@end
