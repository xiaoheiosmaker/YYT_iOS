//
//  NoticeDataController.m
//  YYTHD
//
//  Created by ssj on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NoticeDataController.h"
#import "NoticeItem.h"
#import "MVDiscussItem.h"
static NoticeDataController *gSharedInstance = nil;

@interface NoticeDataController()

@end

@implementation NoticeDataController

- (id)init{
    self = [super init];
    if (!self) {
        
    }
    return self;
}

+ (NoticeDataController *)sharedInstance{
    @synchronized(self)
    {
        if (gSharedInstance == nil) {
            gSharedInstance = [[NoticeDataController alloc] init];
            gSharedInstance.isNew = NO;
            gSharedInstance.countArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
    }
    return gSharedInstance;
}

- (void)getNotice{
    [[NoticeDataController sharedInstance] getNoticeCount:^(NoticeDataController *dataController, NSDictionary *resultDict) {
        if ([[resultDict objectForKey:@"new"] integerValue]) {
            [NoticeDataController sharedInstance].isNew = YES;
        }else{ 
            [NoticeDataController sharedInstance].isNew = NO;
        }
        NSArray *resultArray = [resultDict objectForKey:@"data"];
        [[NoticeDataController sharedInstance].countArray removeAllObjects];
        [[NoticeDataController sharedInstance].countArray addObjectsFromArray:resultArray];
    } failure:^(NoticeDataController *dataController, NSError *error) {
        
    }];
}

- (void)getNoticeCount:(void (^)(NoticeDataController *, NSDictionary*))success failure:(void (^)(NoticeDataController *, NSError *))failure
{
    __weak NoticeDataController *weakSelf = self;
    [[YYTClient sharedInstance] getPath:URL_Notice_Count parameters:nil success:^(id content, id responseObject) {
        success(weakSelf,responseObject);
    } failure:^(id content, NSError *error) {
        NSLog(@"getNoticeCountError");
        failure(weakSelf,error);
    }];
    
}

- (void)getNoticeCommentListByRange:(NSRange)range success:(void (^)(NoticeDataController *,  MVDiscussItem *))success failure:(void (^)(NoticeDataController *, NSError *))failure{
     __weak NoticeDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.location], @"offset", [NSString stringWithFormat:@"%d",range.length],@"size", nil];
    [[YYTClient sharedInstance] getPath:URL_Notice_Comment_List parameters:params success:^(id content, id responseObject) {
        NSError *error;
        MVDiscussItem *mvDiscussItem = [MTLJSONAdapter modelOfClass:[MVDiscussItem class] fromJSONDictionary:responseObject error:&error];
        success(weakSelf,mvDiscussItem);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
        NSLog(@"MVDiscuss-Error :%@",error);
    }];
}

- (void)getNoticeAnnouncementListByRange:(NSRange)range success:(void (^)(NoticeDataController *, NSArray *))success failure:(void (^)(NoticeDataController *, NSError *))failure{
    __weak NoticeDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.location], @"offset", [NSString stringWithFormat:@"%d",range.length],@"size", nil];
    [[YYTClient sharedInstance] getPath:URL_Notice_Announcement_List parameters:params success:^(id content, id responseObject) {
        NSArray *resultArray = [responseObject objectForKey:@"data"];
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:0];
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            NoticeItem *item = [MTLJSONAdapter modelOfClass:[NoticeItem class] fromJSONDictionary:obj error:&error];
            [dataList addObject:item];
        }];
        success(weakSelf, dataList);
    } failure:^(id content, NSError *error) {
        NSLog(@"AnnouncementListError");
        failure(weakSelf,error);
    }];;
}

- (void)getNoticeSystemListByRange:(NSRange)range success:(void (^)(NoticeDataController *, NSArray *))success failure:(void (^)(NoticeDataController *, NSError *))failure{
    __weak NoticeDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.location], @"offset", [NSString stringWithFormat:@"%d",range.length],@"size", nil];
    [[YYTClient sharedInstance] getPath:URL_NOtice_System_List parameters:params success:^(id content, id responseObject) {
        NSArray *resultArray = [responseObject objectForKey:@"data"];
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:0];
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            NoticeItem *item = [MTLJSONAdapter modelOfClass:[NoticeItem class] fromJSONDictionary:obj error:&error];
            [dataList addObject:item];
        }];
        success(weakSelf, dataList);
    } failure:^(id content, NSError *error) {
        NSLog(@"systemListError");
        failure(weakSelf,error);
    }];
}
@end
