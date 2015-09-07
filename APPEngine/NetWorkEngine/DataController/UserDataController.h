//
//  UserDataController.h
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+YYTError.h"
#import "ShareAssistantController.h"
#import "YYTLoginInfo.h"

@class VerificationCodeResult;
@class YYTUserDetail;
@class SignResult;
@class GetBackPasswordResult;
@class OperationResult;

typedef NSString * VerificationCodeType;
extern NSString * const kVerificationCodeRegister;
extern NSString * const kVerificationCodeBind;
extern NSString * const kVerificationCodeChangeBind;
extern NSString * const kVerificationCodeActivate;
extern NSString * const kVerificationCodeResetPassword;

extern NSString * const YYTDidLogin;
extern NSString * const YYTFetchUserInfo;
extern NSString * const YYTDidLogout;

typedef void (^CompletionBlock)(YYTLoginInfo *, NSError *);

@interface UserDataController : NSObject

+ (UserDataController *)sharedInstance;

- (YYTUserDetail *)currentUser;
@property (nonatomic, readonly) BOOL isLogin;

- (YYTLoginInfo *)loginInfo;


- (void)registerWithMail:(NSString *)mail
                nickName:(NSString *)nickName
                password:(NSString *)password
         completionBlock:(void (^)(YYTUserDetail *, NSError *))completionBlock ;

// 开放平台已登录，绑定到站内
- (void)bindingEmail:(NSString *)email
            password:(NSString *)password
             isExist:(BOOL)isExist
     completionBlock:(void (^)(BOOL success, NSError *error))completionBlock;
// 站内已登录，绑定开放平台
- (void)bindingOpenPlatform:(NSString *)optype
                        uid:(NSString *)opuid
                      token:(NSString *)token
            completionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

- (void)loginForUser:(NSString *)mail
                password:(NSString *)pwd
         completionBlock:(CompletionBlock)completionBlock;

- (void)loginForOpenPlatform:(NSString *)opType
                      userID:(NSString *)uid
                 accessToken:(NSString *)accessToken
             completionBlock:(CompletionBlock)completionBlock;

- (void)fetchParticularUserInfo;

- (void)changeUserInfo:(NSDictionary *)infos completion:(void (^)(BOOL success, NSError *error))completionBlock;

//注销
- (void)logoutWithCompletion:(void (^)(YYTUserDetail *user, NSError *error))completionBlock;

// 获得当前用户绑定的第三方信息
- (void)allOpenPlatformAccounts:(void (^)(YYTUserDetail *userDetail, NSError *error))completionBlock;

// 签到
- (void)signInWithCompletion:(void(^)(SignResult *result, NSError *err))block;

// 获取未读消息
- (void)fetchUnreadMessagesWithCompletion:(void(^)(NSArray *messageItems, NSError *err))block;

// 获取短信验证码
- (void)fetchSMSVerificationCodeToPhone:(NSString *)phoneNumber
                          opertaionType:(VerificationCodeType)type
                              productId:(NSNumber *)productId
                         withCompletion:(void(^)(VerificationCodeResult *, NSError *))block;

// 用手机注册
- (void)registerWithPhone:(NSString *)phoneNumber
          verficationCode:(NSString *)code
           withCompletion:(void(^)(YYTLoginInfo *, NSError *))block;

// 找回密码
- (void)getBackPasswordByEmail:(NSString *)email
                withCompletion:(void(^)(GetBackPasswordResult *, NSError *))block;

// 重置密码
- (void)resetPasswordByPhone:(NSString *)phoneNumber
                 newPassword:(NSString *)password
             verficationCode:(NSString *)code
              withCompletion:(void(^)(OperationResult *, NSError *))block;

// 修改密码
- (void)changePassword:(NSString *)password
         toNewPassword:(NSString *)newPasssword
        withCompletion:(void(^)(OperationResult *, NSError *))block;

// 绑定手机号
- (void)bindingPhone:(NSString *)phoneNumber
     verficationCode:(NSString *)code
           productID:(NSNumber *)pID
      withCompletion:(void(^)(YYTLoginInfo *, NSError *))block;

// 发送验证信
- (void)sendVerficationToEmail:(NSString *)email
                withCompletion:(void(^)(OperationResult *, NSError *))block;

//用户信息持久化
- (void)saveLoginInfo;  //登录或者注销成功后调用

@end
