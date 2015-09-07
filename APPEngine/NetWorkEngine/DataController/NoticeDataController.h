//
//  NoticeDataController.h
//  YYTHD
//
//  Created by ssj on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
@class MVDiscussItem;
@interface NoticeDataController : BaseDataController
@property (nonatomic, assign)BOOL isNew;//是否有新的通知
@property (nonatomic, strong)NSMutableArray *countArray;//新通知每一种的个数

+ (NoticeDataController *)sharedInstance;

- (void)getNotice;


//获取通知消息数量
- (void)getNoticeCount:(void (^)(NoticeDataController *dataController,NSDictionary *resultDict))success failure:(void (^)(NoticeDataController *dataController, NSError *error))failure;

//获取评论列表
- (void)getNoticeCommentListByRange:(NSRange)range success:(void (^)( NoticeDataController *dataController, MVDiscussItem *discussItem))success failure:(void (^)(NoticeDataController *dataController, NSError *error))failure;

//获取系统提醒列表
- (void)getNoticeSystemListByRange:(NSRange)range success:(void (^)( NoticeDataController *dataController, NSArray *systemList))success failure:(void (^)(NoticeDataController *dataController, NSError *error))failure;

//获取站内公告列表
- (void)getNoticeAnnouncementListByRange:(NSRange)range success:(void (^)( NoticeDataController *dataController, NSArray *announcementList))success failure:(void (^)(NoticeDataController *dataController, NSError *error))failure;

@end
