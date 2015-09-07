//
//  BindingAssistantController.h
//  YYTHD
//
//  Created by 崔海成 on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertWithShare.h"

extern NSString * const YYTBindingCompletion; // @“绑定完成”

extern NSString * const OPTitleWeibo; // @"新浪微博"
extern NSString * const OPTitleQzone; // @"QQ空间"
extern NSString * const OPTitleTencent; // @"腾讯微博"
extern NSString * const OPTitleRenren; // @"人人网"
extern NSString * const OPTitleWechatTimeline; // @"微信朋友圈"

typedef enum {
    OP_WEIBO = 0,
    OP_QZONE,
    OP_TENCENT,
    OP_RENREN,
    OP_WECHATTIMELINE
} OpenPlatformType;

@protocol ShareAssistantControllerDelegate;

@interface ShareAssistantController : BaseAssistantController 

+ (id)sharedInstance;

+ (NSString *)playlistURLWithID:(NSNumber *)keyID;
+ (NSString *)videoURLWithID:(NSNumber *)keyID;
+ (NSString *)playlistSWFURLWithID:(NSNumber *)keyID;
+ (NSString *)videoSWFURLWithID:(NSNumber *)keyID;
+ (NSString *)playlistURLForWechatTimeline:(NSNumber *)keyID;
+ (NSString *)videoURLForWechatTimeline:(NSNumber *)keyID;

@property (nonatomic, weak) id <ShareAssistantControllerDelegate> delegate;

- (void)shareMLItem:(MLItem *)mlItem
     toOpenPlatform:(OpenPlatformType)opType
   inViewController:(UIViewController *)containerViewController
         completion:(void (^)(BOOL, NSError *))completionBlock;

- (void)shareMVItem:(MVItem *)mvItem
     toOpenPlatform:(OpenPlatformType)opType
   inViewController:(UIViewController *)containerViewController
         completion:(void (^)(BOOL, NSError *))completionBlock;

- (void)bindingOpenPlatform:(OpenPlatformType)opType
                    confirm:(BOOL)confirm
           inViewController:(UIViewController *)container
                 completion:(void (^)(BOOL, NSError *))completionBlock;
- (void)unbindingOpenPlatform:(OpenPlatformType)opType
                   completion:(void (^)(BOOL, NSError *))completionBlock;

- (BOOL)isOAuthInSocialPlatform:(OpenPlatformType)opType;
- (NSString *)nickNameInSocialPlatform:(OpenPlatformType)opType;

- (void)logonOpenPlatform:(NSString *)optype uid:(NSString *)opuid token:(NSString *)token;

@end

@protocol ShareAssistantControllerDelegate

- (NSString *)openPlatformTitle;
- (NSString *)createSWFURLForMLID:(NSNumber *)keyID;
- (NSString *)createURLForMLID:(NSNumber *)keyID;
- (NSString *)createSWFURLForMVID:(NSNumber *)keyID;
- (NSString *)createURLForMVID:(NSNumber *)keyID;

@end
