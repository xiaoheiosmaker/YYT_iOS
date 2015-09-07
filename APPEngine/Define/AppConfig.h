//
//  AppConfig.h
//  KSApp
//
//  Created by kenshin on 13-8-18.
//  Copyright (c) 2013年 kenshin. All rights reserved.
//

/*---------------------------------全局/业务相关配置------------------------*/
#define APP_ID  767238876

#define Run_Mode 0 //0表示仅模拟器 1表示真机+模拟器,该宏主要用于一些第三方包不支持模拟器编译的情况
#define IS_IAP NO //是否iap购买

#define AUTO_DrawSysShadow YES
#define AUTO_SDWebImage_Fade YES


#define IS_SELF_EXCEPTION_HANDLE NO  //是否捕获异常 YES启用自己的捕捉，会弹框显示异常信息  NO的话启用友盟的静默捕捉


/*---------------------------------用户相关信息-------------------------------------*/

#define kUsername           @"usernameNew"
#define kUserPassword       @"userPassword"
#define kUserID             @"userID"
#define kUserToken          @"userToken"


/*---------------------------------程序相关常数-------------------------------------*/
//App Id、下载地址、评价地址

#define APP_ADDRESS @"http://itunes.apple.com/us/app/id%d"
#define APP_RATE_ADDRESS    [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APP_ID]

//#define kAppUrl     [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ling-hao-xian/id%@?ls=1&mt=8",kAppId]

#define kPlaceholderImage       [UIImage imageNamed:@"placeholderImage.png"]

#define PRODUCT @"test"  //产品编号
 
//api渠道号不再跟产品号
#define APP_QUDAO @"kuaiyong-F0146"


/*
//------------------快捷登陆配置


//------------------分享配置


*/

/*---------------------------------程序全局通知-------------------------------------*/

#define NF_AliPaySuccess @"NF_AliPaySuccess"

#define NF_Download_Cancel @"NF_Download_Cancel"
#define NF_Download_Delete @"NF_Download_Delete"

/*---------------------------------用户设置相关-------------------------------------*/

#define Setting_WIFI_Down @"Setting_WIFI_Down"
#define Setting_WIFI_Listen @"Setting_WIFI_Listen"


/*---------------------------------文件存贮配置信息-------------------------------------*/


//#define DBNAME @"kting.rdb"
#define DBNAME @"yyt.sqlite"

#define VideoDirectory				@"Video"
#define TmpVideoDirectory			@"VideoTmp"

#define BookInfoDirectory           @"Book"

#define USER_LOGO_FILE              @"user_logo.png"

//---------缓存文件
#define CacheDirectoryRoot              @"KTing_CACHE"          //缓存一级目录-----------

#define CACHE_FILE_HOME             @"cache_home"           //首页
#define CACHE_FILE_CLASSIFY         @"cache_classify"       //分类
#define CACHE_FILE_PANKING          @"cache_panking"        //排行

#define KeyToken @"kting_ios_token"

/*---------------------------------程序界面配置信息-------------------------------------*/
//框架尺寸
#define kTopBarHeight 62
#define kButtomBarHeight 60

//设置app界面字体及颜色
#define kTitleFont1              [UIFont boldSystemFontOfSize:20]//一级标题字号
#define kTitleFont2              [UIFont boldSystemFontOfSize:17]//二级标题字号
#define kContentFont             [UIFont systemFontOfSize:14.5]  //内容部分字号

//内容部分正常显示颜色和突出显示颜色
#define kContentNormalColor      [UIColor colorWithRed:57/255.0 green:32/255.0 blue:0/255.0 alpha:1]
#define kContentHighlightColor   [UIColor colorWithRed:57/255.0 green:32/255.0 blue:0/255.0 alpha:1]

//按钮上字体颜色
#define kBtnTitleNormalColor     [UIColor colorWithRed:57/255.0 green:32/255.0 blue:0/255.0 alpha:1]
#define kBtnTitleHighlightColor  [UIColor colorWithRed:255/255.0 green:96/255.0 blue:0/255.0 alpha:1]

//设置应用的页面背景色
#define kAppBgColor  [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]


//TableView相关设置
//设置TableView分割线颜色
#define kSeparatorColor   [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]
//设置TableView背景色
#define kTableViewBgColor [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]

#define IMAGE(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]




