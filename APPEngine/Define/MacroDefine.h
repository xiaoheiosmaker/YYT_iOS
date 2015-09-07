//
//  MacroDefine.h
//  KSApp
//
//  Created by kenshin on 13-8-18.
//  Copyright (c) 2013年 kenshin. All rights reserved.
//

#import "AppConfig.h"

/*--------------------------------快捷方法简写--------------------------------------*/


#define CurrentAppDelegate	(AppDelegate*)[UIApplication sharedApplication].delegate

#define RootDirectory	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CacheDirectory	[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define TmpDirectory	NSTemporaryDirectory()

#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define COLORA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//判断设备是否IPHONE5
#define INTERFACE_IS_Phone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


//简单 AlertView
#define _SPAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];




/*--------------------------------页面设计相关--------------------------------------*/


/*--------------------------------系统相关--------------------------------------*/

#define APISource		@"ios"

#define DeviceName		[[UIDevice currentDevice] name]
#define DeviceSys		[[UIDevice currentDevice] model]
#define DeviceModel		[[UIDevice currentDevice] localizedModel]
#define DeviceSdk		[[UIDevice currentDevice] systemName]
#define DeviceVersion	[[UIDevice currentDevice] systemVersion]

#define DeviceWidth		(int)([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.width	: [UIScreen mainScreen].bounds.size.width)
#define DeviceHeight	(int)([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height: [UIScreen mainScreen].bounds.size.height)

#define IMEI            [[UIDevice currentDevice] myuniqueDevIdentifier]

#define Param_Source		@"source"
#define Param_Sys			@"model"
#define Param_QuDao			@"qudao"
#define Param_Model			@"model_local"
#define Param_Sdk			@"sdk"
#define Param_Ver			@"ver"
#define Param_ClientVer     @"version"
#define Param_Width			@"w"
#define Param_Height		@"h"
#define Param_User			@"user"
#define Param_Pass			@"pass"
#define Param_Wuser			@"wuser"
#define Param_Wpass			@"wpass"
#define Param_UUID			@"imei_dev"
#define Param_IMEI			@"imei"
#define Param_Product		@"product"


#define SYS_PARAMS [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%d&%@=%d&%@=%@&%@=%@&%@=%@",\
Param_Source,APISource,\
Param_QuDao,APP_QUDAO,\
Param_Sys,DeviceSys,\
Param_Model,DeviceModel,\
Param_Sdk,DeviceSdk,\
Param_Ver,DeviceVersion,\
Param_Width,DeviceWidth,\
Param_Height,DeviceHeight,\
Param_IMEI,IMEI,\
Param_ClientVer,VERSION,\
Param_Product,PRODUCT]


#define SYS_PARAMS_DICT [NSMutableDictionary dictionaryWithObjectsAndKeys:\
APISource,Param_Source,\
APP_QUDAO,Param_QuDao,\
DeviceSys,Param_Sys,\
DeviceModel,Param_Model,\
DeviceSdk,Param_Sdk,\
DeviceVersion,Param_Ver,\
VERSION,Param_ClientVer,\
[NSNumber numberWithInt:DeviceWidth],Param_Width,\
[NSNumber numberWithInt:DeviceHeight],Param_Height,\
IMEI,Param_IMEI,\
PRODUCT,Param_Product,nil]


/*--------------------------------页面设计相关--------------------------------------*/


#define NavBarHeight         44
#define TabBarHeight         49

//屏幕尺寸
#define ScreenSize [UIScreen mainScreen].bounds.size

//动态获取设备高度
#define IPHONE_WIDTH ScreenSize.width
#define IPHONE_HEIGHT ScreenSize.height


#define _colorDefaultBG [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]

#define _colorTxt1 COLOR(102,102,102)   //主标题
#define _colorTxt2 COLOR(153,153,153)   //副标题
#define _colorTxt3 COLOR(132,132,132)   //首页灰色小标题


#define _colorLine1 COLOR(204,204,204)  //灰色分割线
#define _colorLine2 COLOR(245,245,245)  //白色分割线


#define _colorListBG1 COLOR(248,248,248)  //列表行 偶
#define _colorListBG2 COLOR(239,239,239)  //列表行 奇
#define _colorListBGSelected COLOR(255,255,236)  //列表行 选中