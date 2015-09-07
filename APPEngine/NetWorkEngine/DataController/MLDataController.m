//
//  YueDanDataControl.m
//  YYTHD
//
//  Created by 崔海成 on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLDataController.h"
#import "MLList.h"
#import "MLItem.h"
#import "YYTClient.h"
#import "YYTLoginInfo.h"
#import "UserDataController.h"
#import "MVItem.h"
#import "NSArray+YYTParam.h"
#import "UploadImageInfo.h"
@interface MLDataController()
{
    void (^_fetchMLListSuccessBlock)(AFHTTPRequestOperation *, id);
    void (^_fetchMLListFailureBlock)(AFHTTPRequestOperation *, NSError *);
    void (^_completionBlock)(NSArray *, NSError *);
}
@property (nonatomic, strong)NSMutableArray *favoriteList;
@property (nonatomic, strong)NSMutableArray *pickList;
@property (nonatomic, strong)NSMutableArray *ownList;
@end

@implementation MLDataController

+ (MLDataController *)sharedObject
{
    static MLDataController *mlDC = nil;
    if (!mlDC) {
        mlDC = [[MLDataController alloc] init];
        mlDC->_fetchMLListSuccessBlock = ^(AFHTTPRequestOperation *operation, id responseObject){
            NSError *error = nil;
            MLList *pickMLList = [MTLJSONAdapter modelOfClass:[MLList class]
                                           fromJSONDictionary:responseObject error:&error];
            mlDC->_completionBlock(pickMLList.playLists, error);
        };
        mlDC->_fetchMLListFailureBlock = ^(AFHTTPRequestOperation *operation, NSError *error){
            mlDC->_completionBlock(nil, error);
        };
    }
    return mlDC;
}

- (void)fetchPickMLListForRange:(NSRange)range
                     completion:(FetchMLListCompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:range.location] forKey:@"offset"];
    [parameters setValue:[NSNumber numberWithInt:range.length] forKey:@"size"];
    [[YYTClient sharedInstance] getPath:URL_PICK_MLLIST
                             parameters:parameters
                                success:^(AFHTTPRequestOperation *operation, id responseObject){
                                    NSError *error = nil;
                                    self.pickList = [MTLJSONAdapter modelOfClass:[MLList class] fromJSONDictionary:responseObject error:&error];
                                    _fetchMLListSuccessBlock(operation, responseObject);
                                }
                                failure:_fetchMLListFailureBlock];

}

- (void)fetchMLDetailForID:(NSNumber *)keyID
                completion:(FetchMLItemCompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        MLItem *item = [MTLJSONAdapter modelOfClass:[MLItem class]
                                 fromJSONDictionary:responseObject error:&error];
        completionBlock(item, error);
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:keyID forKey:@"id"];
    [[YYTClient sharedInstance] getPath:URL_ML_DETAIL
                             parameters:parameters
                                success:successBlock
                                failure:failureBlock];
}

- (NSArray *)fetchOwnMLListForRange:(NSRange)range
                    completion:(FetchMLListCompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:range.location] forKey:@"offset"];
    [parameters setValue:[NSNumber numberWithInt:range.length] forKey:@"size"];
    [[YYTClient sharedInstance] getPath:URL_OWN_MLLIST
                              parameters:parameters
                                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                                        NSError *error = nil;
                                        MLList *list = [MTLJSONAdapter modelOfClass:[MLList class] fromJSONDictionary:responseObject error:&error];
                                        self.ownList = [list.playLists mutableCopy];
                                        _fetchMLListSuccessBlock(operation, responseObject);
                                    }
                                 failure:_fetchMLListFailureBlock];
    return self.ownList;
}

- (void)fetchFavoriteMLList:(NSRange)range
                completion :(FetchMLListCompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
    if ([[UserDataController sharedInstance] isLogin]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInt:range.location] forKey:@"offset"];
        [parameters setObject:[NSNumber numberWithInt:range.length] forKey:@"size"];
        [[YYTClient sharedInstance] getPath:URL_FAVORITE_MLLIST
                                  parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id responseObject){
                                         NSError *error = nil;
                                         MLList *list = [MTLJSONAdapter modelOfClass:[MLList class] fromJSONDictionary:responseObject error:&error];
                                         self.favoriteList = [list.playLists mutableCopy];
                                         _fetchMLListSuccessBlock(operation, responseObject);
                                     }
                                     failure:_fetchMLListFailureBlock];
    } else {
        // TODO: tip user login
    }
}

- (void)addFavoriteWithID:(NSNumber *)keyID
               completion:(OperationCompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            completionBlock(YES, nil);
        } else {
            NSError *addFavoriteError = [NSError yytAddFavoriteMLFailureError];
            completionBlock(NO, addFavoriteError);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:keyID forKey:@"id"];
    [[YYTClient sharedInstance] getPath:URL_ADD_FAVORITE parameters:parameters success:successBlock failure:failureBlock];
}

- (void)deleteFavoriteML:(MLItem *)item completionBlock:(void (^)(NSArray *, NSError *))completion
{
    NSMutableArray *list = self.favoriteList;
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id response) {
        if ([response objectForKey:@"success"]) {
            [list removeObject:item];
            completion(self.favoriteList, nil);
        }
        else {
            NSError *error = [NSError yytOperErrorWithMessage:[response objectForKey:@"message"]];
            completion(list, error);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(list, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:item.keyID forKey:@"id"];
    [[YYTClient sharedInstance] getPath:URL_DELETE_FAVORITE_MLITEM
                             parameters:parameters
                                success:successBlock
                                failure:failureBlock];
}

- (void)deleteOwnML:(MLItem *)item completionBlock:(void (^)(NSArray *, NSError *))completion
{
    NSMutableArray *list = self.ownList;
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id response) {
        if ([response objectForKey:@"success"]) {
            [list removeObject:item];
            completion(list, nil);
        }
        else {
            NSError *error = [NSError yytOperErrorWithMessage:[response objectForKey:@"message"]];
            completion(list, error);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(list, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:item.keyID forKey:@"id"];
    [[YYTClient sharedInstance] getPath:URL_DELETE_OWN_MLITEM
                             parameters:parameters
                                success:successBlock
                                failure:failureBlock];
}

- (void)createMLWithTitle:(NSString *)title
          completionBlock:(FetchMLItemCompletionBlock)completionBlock
{
    [self createMLWithTitle:title category:nil tags:nil description:@"" headImgURLString:@"" vids:nil completionBlock:completionBlock];
}

- (void)createMLWithTitle:(NSString *)title
                 category:(NSString *)category
                     tags:(NSString *)tags
              description:(NSString *)description
         headImgURLString:(NSString *)URLString
                     vids:(NSString *)vids
          completionBlock:(FetchMLItemCompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *error = nil;
        if ([responseObject objectForKey:@"success"]) {
            MLItem * item = [MTLJSONAdapter modelOfClass:[MLItem class] fromJSONDictionary:[responseObject objectForKey:@"playlist"] error:&error];
            if (error) {
                completionBlock(NO, error);
            } else {
                completionBlock(item, nil);
            }
        } else {
            error = [NSError yytOperErrorWithMessage:[responseObject objectForKey:@"message"]];
            completionBlock(NO, error);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        completionBlock(NO, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:title forKey:@"title"];
    if (category) {
        [parameters setObject:category forKey:@"category"];
    }
    if (tags) {
        [parameters setObject:tags forKey:@"tags"];
    }
    if (vids) {
        [parameters setObject:vids forKey:@"vids"];
    }
    if (description)
        [parameters setObject:description forKey:@"description"];
    
    if (URLString)
        [parameters setObject:URLString forKey:@"headImg"];
    [[YYTClient sharedInstance] getPath:URL_CREATE_ML parameters:parameters success:successBlock failure:failureBlock];
}

- (void)updateMLWithID:(NSNumber *)keyID
                 title:(NSString *)title
               descrip:(NSString *)descrip
             headImage:(NSString *)headImg
       backgroundImage:(NSString *)bgImg
             videoData:(NSArray *)videos
            completion:(OperationCompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            completionBlock(YES, nil);
        } else {
            NSError *addFavoriteError = [NSError yytAddFavoriteMLFailureError];
            completionBlock(NO, addFavoriteError);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    };
    NSMutableString *videoDataString = [NSMutableString stringWithString:@"["];
    for (int i = 0; i < [videos count]; i++) {
        MVItem *item = [videos objectAtIndex:i];
        [videoDataString appendFormat:@"{\"vid\":%d,\"description\":\"\",\"displayOrder\":%d}", item.keyID.intValue, i];
        if (i + 1 < [videos count]) {
            [videoDataString appendString:@","];
        }
    }
    [videoDataString appendString:@"]"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:keyID forKey:@"id"];
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:descrip forKey:@"description"];
    [parameters setObject:headImg forKey:@"headImg"];
    [parameters setObject:bgImg forKey:@"bgImg"];
    [parameters setObject:videoDataString forKey:@"videoData"];
    [[YYTClient sharedInstance] getPath:URL_UPDATE_OWN_ML
                             parameters:parameters
                                success:successBlock
                                failure:failureBlock];
}

- (void)addMV:(NSNumber *)mvID toML:(NSNumber *)mlID completion:(OperationCompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"success"]) {
            completionBlock(YES, nil);
        } else {
            NSError *addMVToMLError = [NSError yytAddMVToMLFailureError];
            completionBlock(NO, addMVToMLError);
        }
    };
        
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:mlID forKey:@"id"];
    [parameters setObject:mvID forKey:@"vid"];
    [[YYTClient sharedInstance] getPath:URL_ADD_MV_TO_ML
                             parameters:parameters
                                success:successBlock
                                failure:failureBlock];
}

- (void)uploadCoverImage:(UIImage *)img completionBlock:(void (^)(NSString *, NSError *))completion
{
    YYTClient *client = [[YYTClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://upload.sapi.yinyuetai.com/"]];
    NSString *accessToken = [UserDataController sharedInstance].loginInfo.access_token;
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [client setDefaultHeader:@"Authorization" value:authorization];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/upload/image.json" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.5) name:@"file" fileName:@"uploadfile.jpg" mimeType:@"image/jpeg"];
        
    }];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"response is %@ %@", dict, NSStringFromClass([responseObject class]));
        NSError *upError = nil;
        UploadImageInfo *upInfo = [MTLJSONAdapter modelOfClass:[UploadImageInfo class] fromJSONDictionary:responseObject error:&upError];
        NSLog(@"upload complete, image URL:%@", upInfo.originUrl);
        completion(upInfo.originUrl, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"upload failure: %@", [error localizedDescription]);
        completion(nil, error);
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"upload %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [client enqueueHTTPRequestOperation:operation];
}

@end
