//
//  YYTClient.m
//  YYTHDMVCDemo
//
//  Created by btxkenshin on 10/8/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTClient.h"

#import "AFJSONRequestOperation.h"
#import "NSString+MD5Addition.h"
#import "YYTClientParamGenerator.h"
#import "UserDataController.h"

static YYTClient *gSharedInstance = nil;

@implementation YYTClient
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.useCacheOnly = NO;
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"App-Id" value:[YYTClientParamGenerator AppID]];
    [self setDefaultHeader:@"Device-Id" value:[YYTClientParamGenerator DeviceID]];
    [self setDefaultHeader:@"Device-V" value:[YYTClientParamGenerator DeviceV]];
    [self setDefaultHeader:@"Device-N" value:[YYTClientParamGenerator DeviceN:self.networkReachabilityStatus]];
    [self setDefaultHeader:@"Authorization" value:[YYTClientParamGenerator Authorization]];
    
    
    //注册通知，用于及时改变头文件信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:YYTDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:YYTDidLogout object:nil];
#ifdef _SYSTEMCONFIGURATION_H
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
#endif
    return self;
}

+(YYTClient *)sharedInstance
{
    @synchronized(self)
    {
        if (gSharedInstance == nil) {
            gSharedInstance = [[YYTClient alloc] initWithBaseURL:[NSURL URLWithString:URL_SERVER_ROOT]];
        }
        
    }
    return gSharedInstance;
}

// 封装了接口统一解析逻辑 1.json数据格式错误的error封装  2.接口返回服务器错误信息的error封装
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id content, id responseObject))success
        failure:(void (^)(id content, NSError *error))failure
{
    [super getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {//json 格式错误
            NSError *error = [NSError errorWithDomain:@"json数据格式错误" code:10001 userInfo:[NSDictionary dictionaryWithObject:responseObject forKey:@"response"]];
            failure(operation,error);
            
        }
        else {

            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (!error.localizedRecoverySuggestion) {
            failure(operation,error);
            return ;
        }
        
        NSDictionary *errJson = [NSJSONSerialization JSONObjectWithData:[error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        if (errJson && [errJson objectForKey:@"error"]) {//接口返回错误信息
            NSError *tmpError = [NSError yytSeverErrorWithJSON:errJson];
            failure(nil,tmpError);
            // 表示用户登录状态失效，需要通知UserDataController
            if (tmpError.code == 20006) {
                [[UserDataController sharedInstance] logoutWithCompletion:nil];
            }
        }
        else {
            failure(operation,error);
        }
        
    }];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    //add 请求统一需要的默认系统参数
    NSDictionary *parametersFinal = parameters;
    if (!parametersFinal) {
        parametersFinal = [self defaultGetParameters];
    }else{
        NSMutableDictionary *dict = [self defaultGetParameters];
        [dict addEntriesFromDictionary:parameters];
        parametersFinal = dict;
    }
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parametersFinal];
    if (self.useCacheOnly) {
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }else{
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    }
    //[request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    //[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:90];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil &&
        [[cachedResponse data] length] > 0)
    {
        // Get cached data
//        NSLog(@"cache exist---%@",[cachedResponse data]);
    }
    
    return request;
}

- (NSMutableDictionary *)defaultGetParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //NSString *token = [[[UserDataController sharedInstance] loginInfo] access_token];
    //[parameters setValue:token forKey:@"access_token"];
    //[parameters setObject:@"KTN-I-PH" forKey:@"product"];
    //[parameters setObject:ParmDeviceInfo forKey:@"deviceinfo"];
    
    return parameters;
}

- (void)requestDataWithParams:(NSDictionary *)dict
                         path:(NSString *)path
                      success:(KSFinishedBlock)success
                      failure:(KSFailureBlock)failure
{
    NSMutableDictionary *parameters = [self defaultGetParameters];
    [parameters addEntriesFromDictionary:dict];
    
    [self getPath:path
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  return;
              }
              
              if (success) {
                  success(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(operation, error);
              }
          }];
    
}

- (void)requestTableDataWithParams:(NSDictionary *)dict
                              path:(NSString *)path
                           success:(KSFinishedBlock)success
                           failure:(KSFailureBlock)failure
{
    NSMutableDictionary *parameters = [self defaultGetParameters];
    [parameters addEntriesFromDictionary:dict];
    
    [self getPath:path
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (![responseObject isKindOfClass:[NSDictionary class]]) {
                  return;
              }
              
              if (success) {
                  success(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(operation, error);
              }
          }];
    
}


#pragma mark - Notifications
- (void)userDidLogin:(id)sender
{
    //刷新Authorization字段，值为token
    [self setDefaultHeader:@"Authorization" value:[YYTClientParamGenerator Authorization]];
}

- (void)userDidLogout:(id)sender
{
    //刷新Authorization字段，值为base64 oath
    [self setDefaultHeader:@"Authorization" value:[YYTClientParamGenerator Authorization]];
}

- (void)netStatusDidChanged:(id)sender
{
    [self setDefaultHeader:@"Device-N" value:[YYTClientParamGenerator DeviceN:self.networkReachabilityStatus]];
}

@end

