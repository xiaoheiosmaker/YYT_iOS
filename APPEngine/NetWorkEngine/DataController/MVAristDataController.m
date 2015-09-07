//
//  MVAristDataController.m
//  YYTHD
//
//  Created by ssj on 13-10-25.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVAristDataController.h"
#import "Artist.h"
#import "ArtistShow.h"
#import "MyOrderArtist.h"
#import "MVItem.h"

@implementation MVAristDataController

- (void)getArtistSubscribeMeSuccess:(void (^)(MVAristDataController *, NSArray *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"100",@"size", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_Subscribe parameters:params success:^(id content, id responseObject) {
        NSError *error;
        NSMutableArray *artistArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *resultArray = (NSArray *)[responseObject objectForKey:@"artist"];
        for (int i = 0; i < resultArray.count; i++) {
            Artist *artist = [MTLJSONAdapter modelOfClass:[Artist class] fromJSONDictionary:[resultArray objectAtIndex:i] error:&error];
            [artistArray addObject:artist];
        }
        success(weakSelf,artistArray);
        
    } failure:^(id content, NSError *error) {
        NSLog(@"-----%@",error);
        failure(weakSelf,error);
    }];
    
}

- (void)getArtistDetailWithArtistParams:(NSDictionary *)params success:(void (^)(MVAristDataController *, ArtistShow *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Artist_Show parameters:params success:^(id content, id responseObject) {
        NSError *error;
        ArtistShow *artistShow = [MTLJSONAdapter modelOfClass:[ArtistShow class] fromJSONDictionary:responseObject error:&error];
        success(weakSelf, artistShow);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
    }];
}

- (void)createArtistWithArtistID:(NSString *)artistId success:(void (^)(MVAristDataController *, NSDictionary *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:artistId, @"artistId", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_Create parameters:params success:^(id content, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@",[dict objectForKey:@"display_message"]);
        if ([[dict objectForKey:@"isSuccess"] boolValue]) {
            success(weakSelf,dict);
        }else{
            success(weakSelf,dict);
        }
    } failure:^(id content, NSError *error) {
        NSLog(@"MVArtist-create-Error :%@",error);
        failure(weakSelf,error);
    }];
}

- (void)deleteArtistWithArtistID:(NSString *)artistId success:(void (^)(MVAristDataController *, NSDictionary *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:artistId, @"artistId", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_Delete parameters:params success:^(id content, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@",[dict objectForKey:@"display_message"]);
        if ([[dict objectForKey:@"isSuccess"] boolValue]) {
            success(weakSelf,dict);
        }else{
            success(weakSelf,dict);
        }
    } failure:^(id content, NSError *error) {
        NSLog(@"MVArtist-delete-Error :%@",error);
        failure(weakSelf,error);
    }];
}

- (void)getArtistOrderMessage:(NSDictionary *)params success:(void (^)(MVAristDataController *, MyOrderArtist *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Artist_Subscribe_me parameters:params success:^(id content, id responseObject) {
        NSError *error;
        MyOrderArtist *orderArtist = [MTLJSONAdapter modelOfClass:[MyOrderArtist class] fromJSONDictionary:responseObject error:&error];
        success(weakSelf,orderArtist);
    } failure:^(id content, NSError *error) {
        NSLog(@"Artist - error%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchByParams:(NSDictionary *)params success:(void (^)(MVAristDataController *, NSArray *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
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

- (void)getSuggestArtistWithParams:(NSDictionary *)params success:(void (^)(MVAristDataController *, NSArray *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Artist_Suggest parameters:params success:^(id content, id responseObject) {
        NSError *error;
        NSMutableArray *artistArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *resultArray = (NSArray *)[responseObject objectForKey:@"artist"];
        for (int i = 0; i < resultArray.count; i++) {
            Artist *artist = [MTLJSONAdapter modelOfClass:[Artist class] fromJSONDictionary:[resultArray objectAtIndex:i] error:&error];
            [artistArray addObject:artist];
        }
        success(weakSelf,artistArray);
    } failure:^(id content, NSError *error) {
        NSLog(@"artist suggest - error:%@",error);
        failure(weakSelf,error);
    }];
}

- (void)searchArtistByParams:(NSDictionary *)params success:(void (^)(MVAristDataController *, NSArray *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
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

- (void)orderBatchByArtistIds:(NSArray *)artistIds success:(void (^)(MVAristDataController *, NSDictionary *))success failure:(void (^)(MVAristDataController *, NSError *))failure{
    __weak MVAristDataController *weakSelf = self;
    NSMutableString *artists = [[NSMutableString alloc] initWithCapacity:0];
    [artistIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name;
        if (idx == 0) {
            name = [NSString stringWithFormat:@"%@",(NSString*)obj];
        }else{
            name = [NSString stringWithFormat:@",%@",(NSString*)obj];
        }
        [artists appendString:name];
    }];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:artists, @"artistIds", nil];
    [[YYTClient sharedInstance] getPath:URL_Artist_Create_Batch parameters:params success:^(id content, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@",[dict objectForKey:@"display_message"]);
        if ([[dict objectForKey:@"success"] boolValue]) {
            success(weakSelf,dict);
        }else{
            success(weakSelf,dict);
        }
    } failure:^(id content, NSError *error) {
        NSLog(@"orderBatch artist - error:%@",error);
        failure(weakSelf,error);
    }];
}

@end
