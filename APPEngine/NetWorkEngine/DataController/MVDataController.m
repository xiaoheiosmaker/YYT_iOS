//
//  MVDataController.m
//  YYTHD
//
//  Created by IAN on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVDataController.h"
#import "MVItem.h"
#import "MVDownloadItem.h"
#import "UserDataController.h"
#import "MVDiscussItem.h"

@implementation MVDataController
{
    NSMutableArray *_collectionArray;
}

- (id)init
{
    if (self = [super init]) {
        _collectionArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}


static MVDataController *sharedInstance = nil;
+ (MVDataController *)sharedDataController
{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (void)getMVAreasWithCompletion:(void (^)(NSArray *, NSError *))completion
{
    [[YYTClient sharedInstance] getPath:URL_MVAreas
                             parameters:nil
                                success:^(id content, id responseObject) {
                                    if ([responseObject isKindOfClass:[NSArray class]]) {
                                        completion(responseObject, nil);
                                    }
                                    else {
                                        completion(nil, nil);
                                    }
                                }
                                failure:^(id content, NSError *error) {
                                    completion(nil, error);
                                }];
}

- (void)loadMVListWithAreaCode:(NSString *)areaCode range:(NSRange)range completion:(void(^)(NSArray *, NSError *))completion
{
    NSDictionary *params = @{@"area": areaCode,
                             @"size": [NSNumber numberWithInt:range.length],
                             @"offset": [NSNumber numberWithInt:range.location]};
    
    [[YYTClient sharedInstance] getPath:URL_MVList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *datalist = [responseObject objectForKey:@"videos"];
        
        NSMutableArray *listTemp = [NSMutableArray array];
        [datalist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error = nil;
            [listTemp addObject:[MTLJSONAdapter modelOfClass:MVItem.class fromJSONDictionary:obj error:&error]];
        }];
        
        completion(listTemp,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}


#pragma mark - Collection
- (void)getCollectionsWithRange:(NSRange)range completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    if ([_collectionArray count] > NSMaxRange(range)) {
        NSArray *objects = [_collectionArray subarrayWithRange:range];
        completionHandler(objects, nil);
        return;
    }
    
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    
    //发送请求
    NSRange locRange = NSMakeRange(0, _collectionArray.count);
    NSRange unionRange = NSUnionRange(locRange, range);
    NSRange requestRange = NSMakeRange(_collectionArray.count, unionRange.length-locRange.length);
    
    [self requestCollectionWithRange:requestRange completionHandler:^(NSArray * collection, NSError *error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        [_collectionArray addObjectsFromArray:collection]; //保存结果
        //判断range范围是否超出数据长度
        NSRange resultRange = range;
        if (NSMaxRange(range) > [_collectionArray count]) {
            NSRange locRange = NSMakeRange(0, _collectionArray.count);
            resultRange = NSIntersectionRange(locRange, range);
        }
        
        NSArray *array = [_collectionArray subarrayWithRange:resultRange]; //返回结果
        completionHandler(array, nil);
    }];
}

- (void)refreshCollectionsWithlength:(NSUInteger)length completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    NSRange requestRange = {0, length};
    [self requestCollectionWithRange:requestRange completionHandler:^(NSArray * collection, NSError *error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        _collectionArray = [collection mutableCopy]; //保存结果
        completionHandler(collection, nil); //返回结果
    }];
}

- (void)requestCollectionWithRange:(NSRange)range completionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    NSNumber *offset = [NSNumber numberWithUnsignedInteger:range.location];
    NSNumber *size = [NSNumber numberWithUnsignedInteger:range.length];
    NSDictionary *params = @{@"offset": offset, @"size": size};
    
    [[YYTClient sharedInstance] getPath:URL_MVCollection_Show parameters:params success:^(id content, id responseObject) {
        //解析
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *videos = [responseObject objectForKey:@"videos"];
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:videos.count];
            for (NSDictionary *videoDic in videos) {
                NSError *jsonError = nil;
                MVItem *item = [MTLJSONAdapter modelOfClass:[MVItem class] fromJSONDictionary:videoDic error:&jsonError];
                if (jsonError) {
                    completionHandler(nil, jsonError);
                    return;
                }
                [objects addObject:item];
            }
            completionHandler(objects, nil);
        }
    } failure:^(id content, NSError *error) {
        completionHandler(nil, error);
    }];
}

- (void)addCollection:(MVItem *)item withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    NSNumber *mvID = item.keyID;
    if ([item isKindOfClass:[MVDownloadItem class]]) {
        MVDownloadItem *downloadItem = (MVDownloadItem *)item;
        mvID = [downloadItem videoID];
    }
    
    NSDictionary *params = @{@"id": mvID};
    [[YYTClient sharedInstance] getPath:URL_MVCollection_Add parameters:params success:^(id content, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSNumber *result = responseDic[@"success"];
            NSString *message = responseDic[@"message"];
            if ([result boolValue]) {
                //添加成功
                [_collectionArray insertObject:item atIndex:0]; //添加收藏至最前
                completionHandler(message, nil);
            } else {
                NSError *error = [NSError yytOperErrorWithMessage:message];
                completionHandler(message, error);
            }
        }
    } failure:^(id content, NSError *error) {
        completionHandler(nil, error);
    }];
}

- (void)addCollections:(NSArray *)items withCompletionHandler:(void (^)(NSString *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    //转换为一个以,分割各个参数的字符串
    NSString *ids = [items yytParamWithTransformer:^NSString *(id object, NSUInteger idx) {
        MVItem *item = object;
        return [item.keyID stringValue];
    }];
    
    NSDictionary *params = @{@"ids": ids};
    [[YYTClient sharedInstance] getPath:URL_MVCollection_Add_Bat parameters:params success:^(id content, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSNumber *result = responseDic[@"success"];
            NSString *message = responseDic[@"message"];
            if ([result boolValue]) {
                //添加成功
                //添加收藏至最前
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)];
                [_collectionArray insertObjects:items atIndexes:indexSet];
                completionHandler(message, nil);
            } else {
                NSError *error = [NSError yytOperErrorWithMessage:message];
                completionHandler(message, error);
            }
        }
    } failure:^(id content, NSError *error) {
        completionHandler(nil, error);
    }];
}

- (void)removeCollection:(MVItem *)item withCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    NSNumber *mvID = item.keyID;
    NSDictionary *params = @{@"id": mvID};
    [[YYTClient sharedInstance] getPath:URL_MVCollection_Del parameters:params success:^(id content, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSNumber *result = responseDic[@"success"];
            NSString *message = responseDic[@"message"];
            if ([result boolValue]) {
                //删除成功
                [_collectionArray removeObject:item]; //删除本地缓存
                completionHandler(_collectionArray, nil);
            } else {
                NSError *error = [NSError yytOperErrorWithMessage:message];
                completionHandler(_collectionArray, error);
            }
        }
    } failure:^(id content, NSError *error) {
        completionHandler(_collectionArray, error);
    }];
}

- (void)removeCollections:(NSArray *)items withCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    //判断登陆状态
    if (![[UserDataController sharedInstance] isLogin]) {
        NSError *error = [NSError yytNotLoginError];
        completionHandler(nil, error);
        return;
    }
    
    //转换为一个以,分割各个参数的字符串
    NSString *ids = [items yytParamWithTransformer:^NSString *(id object, NSUInteger idx) {
        MVItem *item = object;
        return [item.keyID stringValue];
    }];
    
    NSDictionary *params = @{@"ids": ids};
    [[YYTClient sharedInstance] getPath:URL_MVCollection_Del_Bat parameters:params success:^(id content, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSNumber *result = responseDic[@"success"];
            NSString *message = responseDic[@"message"];
            if ([result boolValue]) {
                //删除成功
                [_collectionArray removeObjectsInArray:items]; //删除本地收藏
                completionHandler(_collectionArray, nil);
            } else {
                NSError *error = [NSError yytOperErrorWithMessage:message];
                completionHandler(_collectionArray, error);
            }
        }
    } failure:^(id content, NSError *error) {
        completionHandler(_collectionArray, error);
    }];
}

#pragma mark - MVDetail
- (void)getMVDetailWithID:(NSString *)viewId Success:(void (^)(MVDataController *, MVItem *))success failure:(void (^)(MVDataController *, NSError *))failure{
    __weak id weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:viewId, @"id", nil];
    [[YYTClient sharedInstance] getPath:URL_MVDetail_Show parameters:params success:^(id content, id responseObject) {
        NSError *error;
        MVItem *mvItem = [MTLJSONAdapter modelOfClass:[MVItem class] fromJSONDictionary:responseObject error:&error];
        
        success(weakSelf,mvItem);
        
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
        NSLog(@"MVDetail-Error :%@",error);
    }];
}

#pragma mark - MVComment
- (void)getMVDiscussWithParams:(NSDictionary *)params Success:(void (^)(MVDataController *, MVDiscussItem *))success failure:(void (^)(MVDataController *, NSError *))failure{
    __weak id weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_MVDiscuss parameters:params success:^(id content, id responseObject) {
        NSError *error;
        //NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"display_message"]);
        MVDiscussItem *mvDiscussItem = [MTLJSONAdapter modelOfClass:[MVDiscussItem class] fromJSONDictionary:responseObject error:&error];
        success(weakSelf,mvDiscussItem);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
        NSLog(@"MVDiscuss-Error :%@",error);
    }];
}


- (void)postMVCommentWithParams:(NSDictionary *)params success:(void (^)(MVDataController *,NSDictionary *))success failure:(void (^)(MVDataController *, NSError *))farlure{
    __weak id weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_MVPostComment parameters:params success:^(id content, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@",[dict objectForKey:@"display_message"]);
        if ([[dict objectForKey:@"isSuccess"] boolValue]) {
            success(weakSelf,dict);
        }else{
            success(weakSelf,dict);
        }
    } failure:^(id content, NSError *error) {
        NSLog(@"MVComment-Error :%@",error);
        farlure(weakSelf,error);
    }];
}

@end
