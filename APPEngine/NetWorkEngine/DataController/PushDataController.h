//
//  PushDataController.h
//  YYTHD
//
//  Created by shuilin on 11/5/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
#import "PushDataObject.h"
#import "PushItem.h"

//2通知外部此模型已经改变
@class PushDataController;
@protocol PushDataControllerDelegate <NSObject>
@optional
- (void)pushDataController:(PushDataController*) dataController bindedToApnsWithError:(NSError*)error;
- (void)pushDataController:(PushDataController*) dataController enableCenterPushWithError:(NSError*)error;
- (void)pushDataController:(PushDataController*) dataController enableSubscribePushWithError:(NSError*)error;
@end


@interface PushDataController : BaseDataController
{
    
}

+ (PushDataController*) singleTon;
//初始化属性
- (void)readyCenterPush:(BOOL)bOnCenterPush andSubscribePush:(BOOL)bOnSubscribePush;

//3获取模型改变结果
- (BOOL)bOnCenterPush;
- (BOOL)bOnSubscribePush;

//1改变模型
- (void)enableCenterPush:(BOOL)bOn;
- (void)enableSubscribePush:(BOOL)bOn;

- (void)bindToApns:(NSData*)tokenData;
- (void)rebindApns;//登陆，注销成功后也要调用

//处理推送消息
- (PushItem *)pushDataParseWithDict:(NSDictionary *)dict;

@end
