//
//  SearchDataController.m
//  YYTHD
//
//  Created by ssj on 13-11-1.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "SearchDataController.h"
#import "MVItem.h"
#import "Artist.h"

@implementation SearchDataController

- (void)searchVideoByParam:(NSDictionary *)params success:(void (^)(SearchDataController *, NSArray *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:keyWord,@"keyword ", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_SearchMV parameters:params success:^(id content, id responseObject) {
        NSError *error;
        NSMutableArray *artistArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *resultArray = (NSArray *)[responseObject objectForKey:@"videos"];
        for (int i = 0; i < resultArray.count; i++) {
            MVItem *mvItem = [MTLJSONAdapter modelOfClass:[MVItem class] fromJSONDictionary:[resultArray objectAtIndex:i] error:&error];
            [artistArray addObject:mvItem];
        }
        success(weakSelf,artistArray);
        
    } failure:^(id content, NSError *error) {
        NSLog(@"searchArtist_MV - error:%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchArtistByParam:(NSDictionary *)params success:(void (^)(SearchDataController *, NSArray *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
//     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:keyWord,@"keyword ", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_Search parameters:params success:^(id content, id responseObject) {
        NSError *error;
        NSMutableArray *artistArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *resultArray = (NSArray *)[responseObject objectForKey:@"artist"];
        for (int i = 0; i < resultArray.count; i++) {
            Artist *artist = [MTLJSONAdapter modelOfClass:[Artist class] fromJSONDictionary:[resultArray objectAtIndex:i] error:&error];
            [artistArray addObject:artist];
        }
        success(weakSelf,artistArray);
    } failure:^(id content, NSError *error) {
        NSLog(@"search artist - error:%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchSuggestByKeyWord:(NSString *)keyWord success:(void (^)(SearchDataController *, NSArray *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:keyWord,@"keyword", nil];
    
    [[YYTClient sharedInstance] getPath:URL_Search_Suggest parameters:params success:^(id content, id responseObject) {
        NSArray *resultArray = (NSArray *)responseObject;
        NSMutableArray *wordArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dict in resultArray) {
            NSString *word = [dict objectForKey:@"word"];
            NSLog(@"%@",word);
            [wordArray addObject:word];
        }
        success(weakSelf,wordArray);
    } failure:^(id content, NSError *error) {
        NSLog(@"search suggest :%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchRecommendSuccess:(void (^)(SearchDataController *, NSArray *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Search_Recommend parameters:nil success:^(id content, id responseObject) {
        NSArray *array = [responseObject objectForKey:@"words"];
        success(weakSelf,array);
    } failure:^(id content, NSError *error) {
        NSLog(@"search recommend :%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchPlayListByParam:(NSDictionary *)params success:(void (^)(SearchDataController *, SearchMLItem *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Search_ML parameters:params success:^(id content, id responseObject) {
        NSError *error;
        SearchMLItem *searchMLItem = [MTLJSONAdapter modelOfClass:[SearchMLItem class] fromJSONDictionary:(NSDictionary*)responseObject error:&error];
        success(weakSelf,searchMLItem);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
    }];
}

- (void)searchTopKeyWordByCount:(NSString *)count success:(void (^)(SearchDataController *, NSArray *))success failure:(void (^)(SearchDataController *, NSError *))failure{
    __weak SearchDataController *weakSelf = self;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:count,@"count", nil];
    [[YYTClient sharedInstance] getPath:URL_Search_TopKeyWord parameters:params success:^(id content, id responseObject) {
        success(weakSelf,(NSArray *)responseObject);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
    }];
}

@end
