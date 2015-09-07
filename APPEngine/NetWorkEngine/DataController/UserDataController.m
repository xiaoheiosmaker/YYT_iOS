//
//  UserDataController.m
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "UserDataController.h"
#import "YYTClient.h"
#import "NSString+MD5Addition.h"
#import "YYTLoginInfo.h"
#import "MF_Base64Additions.h"
#import "YYTUserDetail.h"
#import "PushDataController.h"
#import "OpenSocialPlatformBind.h"
#import "SignResult.h"
#import "UnreadMessageItem.h"
#import "VerificationCodeResult.h"
#import "GetBackPasswordResult.h"
#import "OperationResult.h"

#define kYYTLoginInfo           @"YYTLoginInfo"

NSString * const kVerificationCodeRegister = @"register";
NSString * const kVerificationCodeBind = @"bind";
NSString * const kVerificationCodeChangeBind = @"changeBind";
NSString * const kVerificationCodeActivate = @"activate";
NSString * const kVerificationCodeResetPassword = @"resetPassword";

NSString * const YYTDidLogin = @"YYTDidLogin";
NSString * const YYTFetchUserInfo = @"YYTFetchUserInfo";
NSString * const YYTDidLogout = @"YYTDidLogout";

@interface UserDataController ()
{
    YYTLoginInfo *loginInfo;
}
- (void)loginSuccessed;

@end

@implementation UserDataController
static UserDataController *sharedDataController = nil;

+ (UserDataController *)sharedInstance
{
    if (sharedDataController == nil) {
        sharedDataController = [[self alloc] init];
    }
    return sharedDataController;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self loadLoginInfo];
    }
    return self;
}

- (YYTUserDetail *)currentUser
{
    return loginInfo.user;
}

- (BOOL)isLogin
{
    return loginInfo.isLogin;
}

- (YYTLoginInfo *)loginInfo
{
    return loginInfo;
}

- (void)loginSuccessed
{
    loginInfo.isLogin = YES;
    [self saveLoginInfo];
    
    //重新绑定推送
    [[PushDataController singleTon] performSelectorOnMainThread:@selector(rebindApns) withObject:nil waitUntilDone:NO];
    
    
    int expiresInSeconds = [loginInfo.expires_in intValue];
    NSDate *now = [NSDate date];
    NSDate *expiresDate = [now dateByAddingTimeInterval:expiresInSeconds];
    [[NSUserDefaults standardUserDefaults] setObject:expiresDate forKey:@"expiresDate"];
    [[NSNotificationCenter defaultCenter] postNotificationName:YYTDidLogin object:self];
    [self fetchParticularUserInfo];
}

- (void)fetchParticularUserInfo
{
    //__weak UserDataController *weakSelf = self;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@"TRUE" forKey:@"showBind"];
    [[YYTClient sharedInstance] getPath:URL_ACCOUNT_SHOW parameters:paras success:^(id content, id responseObject) {
        NSError *error;
        YYTUserDetail *newUser = [MTLJSONAdapter modelOfClass:[YYTUserDetail class] fromJSONDictionary:responseObject error:&error];
        if (!error) {
            loginInfo.user = newUser;
            [[NSNotificationCenter defaultCenter] postNotificationName:YYTFetchUserInfo object:self];
        }
    } failure:^(id content, NSError *error) {
        if (error) {
            NSLog(@"%@", [error yytErrorMessage]);
        }
    }];
}

- (void)loginForUser:(NSString *)mail
                password:(NSString *)pwd
         completionBlock:(void (^)(YYTLoginInfo *, NSError *))completionBlock
{
    if (!mail || !pwd || [mail isEqualToString:@""] || [pwd isEqualToString:@""]) {
        if (completionBlock) completionBlock(nil, [NSError yytLoginFailureError]);
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:mail forKey:@"username"];
    [parameters setObject:pwd forKey:@"password"];
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *error = nil;
    
        loginInfo = [MTLJSONAdapter modelOfClass:[YYTLoginInfo class] fromJSONDictionary:responseObject error:&error];
        if (!error) {
            [self loginSuccessed];
            //[MobClick event:@"Account_Signin" label:@"音悦台账号登陆"];
            if (completionBlock) completionBlock(loginInfo, error);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        //loginInfo = nil;
        if (completionBlock) completionBlock(nil, [NSError yytLoginFailureError]);
    };
    [[YYTClient sharedInstance] getPath:URL_ACCOUNT_LOGIN parameters:parameters success:successBlock failure:failureBlock];
}

- (void)registerWithMail:(NSString *)mail
                nickName:(NSString *)nickName
                password:(NSString *)password
         completionBlock:(void (^)(YYTUserDetail *, NSError *))completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mail forKey:@"email"];
    [params setObject:nickName forKey:@"nickname"];
    [params setObject:password forKey:@"password"];
    [[YYTClient sharedInstance] postPath:URL_ACCOUNT_REGISTER parameters:params success:^(id content, id responseObject) {
        NSError *newError;
        YYTUserDetail *user = [MTLJSONAdapter modelOfClass:[YYTUserDetail class] fromJSONDictionary:responseObject error:&newError];
        if (user) {
            [MobClick event:@"login_Account" label:@"注册账号使用频数"];
        }
        if (completionBlock) completionBlock(user, newError);
    } failure:^(id content, NSError *error) {
        if (completionBlock) completionBlock(nil, error);
    }];
}

- (void)bindingEmail:(NSString *)email
            password:(NSString *)password
             isExist:(BOOL)isExist
     completionBlock:(void (^)(BOOL, NSError *))completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:isExist ? @"exist" : @"new" forKey:@"type"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"productId"];
    [[YYTClient sharedInstance] getPath:URL_ACCOUNT_BIND_EMAIL parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        loginInfo = [MTLJSONAdapter modelOfClass:[YYTLoginInfo class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (completionBlock) {
                completionBlock(NO, parseErr);
            }
        }
        else {
            if (completionBlock) {
                [self loginSuccessed];
                completionBlock(YES, nil);
            }
        }
    } failure:^(id content, NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)bindingOpenPlatform:(NSString *)optype uid:(NSString *)opuid token:(NSString *)token completionBlock:(void (^)(BOOL, NSError *))completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:optype forKey:@"optype"];
    [params setObject:opuid forKey:@"opuid"];
    [params setObject:token forKey:@"token"];
    [[YYTClient sharedInstance] getPath:URL_OPEN_BIND parameters:params success:^(id content, id responseObject) {
        if (completionBlock) completionBlock(YES, nil);
    } failure:^(id content, NSError *error) {
        if (completionBlock) completionBlock(NO, error);
    }];
}

- (void)loginForOpenPlatform:(NSString *)opType
                      userID:(NSString *)uid
                 accessToken:(NSString *)accessToken
             completionBlock:(CompletionBlock)completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *error = nil;
        loginInfo = [MTLJSONAdapter modelOfClass:[YYTLoginInfo class] fromJSONDictionary:responseObject error:&error];
        
        if (!error) {
            [MobClick event:@"Account_Signin" label:@"新浪微博账号登陆"];
            [self loginSuccessed];
            if (completionBlock) completionBlock(loginInfo, error);
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        //loginInfo = nil;
        if (completionBlock) completionBlock(nil, [NSError yytLoginFailureError]);
    };
    [[YYTClient sharedInstance] getPath:URL_OPEN_ACCOUNT_LOGIN
                              parameters:@{@"optype":opType, @"opuid":uid, @"token":accessToken}
                                 success:successBlock
                                 failure:failureBlock];
}

- (void)changeUserInfo:(NSDictionary *)infos completion:(void (^)(BOOL, NSError *))completionBlock
{
    if (!loginInfo.isLogin) {
        @throw [NSException exceptionWithName:@"修改用户信息失败" reason:@"用户没有登录" userInfo:infos];
        return;
    }
    __weak UserDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_ACCOUNT_PROFILE parameters:infos success:^(id content, id responseObject) {
        [weakSelf currentUser].nickName = [[responseObject objectForKey:@"user"] objectForKey:@"nickName"];
        [weakSelf saveLoginInfo];
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    } failure:^(id content, NSError *error) {
        if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)logoutWithCompletion:(void (^)(YYTUserDetail *, NSError *))completionBlock
{
    if (!loginInfo.isLogin) {
        NSLog(@"注销操作只对登录后有效");
        return;
    }
    
    //NSLog(@"注销结果： %@",responseObject);
    loginInfo.isLogin = NO;
    loginInfo.user = nil;
    loginInfo.access_token = nil;
    [self saveLoginInfo];
    
    //重新绑定推送
    [[PushDataController singleTon] performSelectorOnMainThread:@selector(rebindApns) withObject:nil waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YYTDidLogout object:self];
    
    if (completionBlock)
        completionBlock(loginInfo.user, nil);
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
    };
    
    [[YYTClient sharedInstance] postPath:URL_ACCOUNT_LOGOUT
                              parameters:nil
                                 success:successBlock
                                 failure:failureBlock];
}

- (void)allOpenPlatformAccounts:(void (^)(YYTUserDetail *, NSError *))completionBlock
{
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        YYTUserDetail * userDetail = [MTLJSONAdapter modelOfClass:[YYTUserDetail class]
                                               fromJSONDictionary:responseObject
                                                            error:&error];
        completionBlock(userDetail, error);
    };
    void (^failureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    };
    [[YYTClient sharedInstance] postPath:URL_OPEN_ACCOUNT_LOGIN parameters:@{@"showBind":@YES} success:successBlock failure:failureBlock];
}

- (void)signInWithCompletion:(void (^)(SignResult *result, NSError *err))block
{
    if (![self isLogin]) {
        NSError *loginErr = [NSError yytNotLoginError];
        if (block) {
            block(nil, loginErr);
        }
        return;
    }
    
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_SIGN_IN parameters:nil success:^(id content, id responseObject) {
        NSError *parseErr;
        SignResult *result = [MTLJSONAdapter modelOfClass:[SignResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (block)
            block(result, parseErr);
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)fetchUnreadMessagesWithCompletion:(void (^)(NSArray *, NSError *))block
{
    if (![self isLogin]) {
        NSError *notLoginErr = [NSError yytNotLoginError];
        if (block)
            block(nil, notLoginErr);
        return;
    }
    
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_UNREAD_MESSAGE parameters:nil success:^(id content, id responseObject) {
        NSArray *messageItems = responseObject;
        if (messageItems == nil) {
            NSAssert(NO, @"返回数据有错误");
        }
        else {
            __block NSMutableArray *newMessageItems = [NSMutableArray array];
            [messageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *parseErr;
                UnreadMessageItem *item = [MTLJSONAdapter modelOfClass:[UnreadMessageItem class] fromJSONDictionary:obj error:&parseErr];
                if (parseErr) {
                    if (block)
                        block(nil, parseErr);
                    *stop = NO;
                    newMessageItems = nil;
                    return;
                }
                else {
                    [newMessageItems addObject:item];
                }
            }];
            
            if (newMessageItems != nil) {
                if (block)
                    block(newMessageItems, nil);
            }
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)fetchSMSVerificationCodeToPhone:(NSString *)phoneNumber
                          opertaionType:(VerificationCodeType)type
                              productId:(NSNumber *)productId
                         withCompletion:(void (^)(VerificationCodeResult *, NSError *))block
{
    if (![type isEqualToString:kVerificationCodeRegister] && ![self isLogin])
    {
        NSError *notLoginErr = [NSError yytNotLoginError];
        if (block) {
            block(nil, notLoginErr);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:type forKey:@"type"];
    if (productId)
        [params setObject:productId forKey:@"productId"];
    
    NSString *apiPath = URL_ACCOUNT_VERIFICATION_CODE;
    if ([type isEqualToString:kVerificationCodeActivate] || [type isEqualToString:kVerificationCodeResetPassword]) {
        apiPath = URL_PRODUCT_VERIFICATION_CODE;
    }
    
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:apiPath parameters:params success:^(id content, id responseObject) {
        
        NSError *parseErr;
        VerificationCodeResult *result = [MTLJSONAdapter modelOfClass:[VerificationCodeResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
            return;
        }
        if (block)
            block(result, nil);
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)registerWithPhone:(NSString *)phoneNumber
          verficationCode:(NSString *)code
           withCompletion:(void (^)(YYTLoginInfo *, NSError *))block
{
    NSAssert(![self isLogin], @"already login, can't register");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:code forKey:@"code"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_REGISTER_WITH_PHONE parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        YYTLoginInfo *info = [MTLJSONAdapter modelOfClass:[YYTLoginInfo class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            loginInfo = info;
            if (block)
                block(info, nil);
            [self loginSuccessed];
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)getBackPasswordByEmail:(NSString *)email
                withCompletion:(void (^)(GetBackPasswordResult *, NSError *))block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_GET_BACK_PASSWORD parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        GetBackPasswordResult *result = [MTLJSONAdapter modelOfClass:[GetBackPasswordResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            if (block)
                block(result, nil);
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)resetPasswordByPhone:(NSString *)phoneNumber
                 newPassword:(NSString *)password
             verficationCode:(NSString *)code
              withCompletion:(void (^)(OperationResult *, NSError *))block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params setObject:code forKey:@"code"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_RESET_PASSWORD parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        OperationResult *result = [MTLJSONAdapter modelOfClass:[OperationResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            if (block)
                block(result, nil);
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

// 修改密码
- (void)changePassword:(NSString *)password
         toNewPassword:(NSString *)newPasssword
        withCompletion:(void (^)(OperationResult *, NSError *))block
{
    if (![self isLogin]) {
        if (block) {
            NSError *notLoginErr = [NSError yytNotLoginError];
            block(nil, notLoginErr);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:password forKey:@"password"];
    [params setObject:newPasssword forKey:@"newPassword"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_CHANGE_PASSWORD parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        OperationResult *result = [MTLJSONAdapter modelOfClass:[OperationResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            if (block)
                block(result, nil);
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)bindingPhone:(NSString *)phoneNumber
     verficationCode:(NSString *)code
           productID:(NSNumber *)pID
      withCompletion:(void (^)(YYTLoginInfo *, NSError *))block
{
    if (![self isLogin]) {
        if (block) {
            NSError *notLoginErr = [NSError yytNotLoginError];
            block(nil, notLoginErr);
        }
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:code forKey:@"code"];
    [params setObject:pID forKey:@"productId"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_BING_PHONE parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        loginInfo = [MTLJSONAdapter modelOfClass:[YYTLoginInfo class] fromJSONDictionary:responseObject error:&parseErr];
        [self loginSuccessed];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            if (block)
                block(loginInfo, nil);
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

- (void)sendVerficationToEmail:(NSString *)email
                withCompletion:(void (^)(OperationResult *, NSError *))block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    YYTClient *client = [YYTClient sharedInstance];
    [client getPath:URL_ACCOUNT_SEND_EMAIL parameters:params success:^(id content, id responseObject) {
        NSError *parseErr;
        OperationResult *result = [MTLJSONAdapter modelOfClass:[OperationResult class] fromJSONDictionary:responseObject error:&parseErr];
        if (parseErr) {
            if (block)
                block(nil, parseErr);
        }
        else {
            if (block)
                block(result, nil);
        }
    } failure:^(id content, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

//用户信息读写
- (void)saveLoginInfo
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.loginInfo];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:kYYTLoginInfo];
    [userDefaults synchronize];
    NSLog(@"saveLoginInfo complete");
}

- (void)loadLoginInfo
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefaults objectForKey:kYYTLoginInfo];
    if (data)
    {
        loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

@end
