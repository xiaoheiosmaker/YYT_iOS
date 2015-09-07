//
//  SettingsDataController.h
//  YYTHD
//
//  Created by shuilin on 11/1/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
#import "ShareAccount.h"

#define kVideoQualityItem       @"VideoQualityItem"
#define kLockSwitchItem         @"LockSwitchItem"
#define kSinaAccountItem        @"SinaAccountItem"
#define kQQAccountItem        @"QQAccountItem"
#define kTencentAccountItem        @"TencentAccountItem"
#define kRenrenAccountItem        @"RenrenAccountItem"
#define kMessageSwitchItem          @"MessageSwitchItem"
#define kNewMVSwitchItem            @"NewMVSwitchItem"
#define kNetSwitchItem              @"NetSwitchItem"

typedef enum
{
	Normal_Video,       //标清
	P540_Video,         //540P
} VideoQualityType;

@interface SettingsDataController : BaseDataController
{
    
}
@property(assign,nonatomic) VideoQualityType videoQualityType;
@property(assign,nonatomic) BOOL lockOn;
@property(retain,nonatomic) ShareAccount* sinaAccount;
@property(retain,nonatomic) ShareAccount* qqAccount;
@property(retain,nonatomic) ShareAccount* tencentAccount;
@property(retain,nonatomic) ShareAccount* renrenAccount;
@property(assign,nonatomic) BOOL messageOn;
@property(assign,nonatomic) BOOL newMvOn;
@property(assign,nonatomic) BOOL netOn;

+ (SettingsDataController*) singleTon;

- (void)saveItem:(NSString*)kItem;      //把设置数据存入磁盘上
- (void)loadItems;                      //从磁盘中加载设置数据
@end
