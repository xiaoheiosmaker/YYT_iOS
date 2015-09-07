//
//  NSError+YYTError.h
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const YYTErrorDomain;

//Error Code
extern NSInteger const YYTErrorNotLogin;
extern NSInteger const YYTErrorLoginFailure;
extern NSInteger const YYTErrorOperFailure; //操作失败，向服务器写数据，服务器返回操作失败
extern NSInteger const YYTErrorAddFavoriteFailure;
extern NSInteger const YYTErrorAddMVToMLFailure;
extern NSInteger const YYTErrorPlayStatusProblem;

@interface NSError (YYTError)

+ (NSError *)yytErrorWithErrorCode:(NSInteger)code userInfo:(NSDictionary *)info;

//未登录错误
+ (NSError *)yytNotLoginError;
+ (NSError *)yytLoginFailureError;
+ (NSError *)yytAddFavoriteMLFailureError;
+ (NSError *)yytAddMVToMLFailureError;

+ (NSError *)yytSeverErrorWithJSON:(NSDictionary *)jsonDic;

+ (NSError *)yytOperErrorWithMessage:(NSString *)message;

- (NSString *)yytErrorMessage;

@end
