//
//  NetWorkAPI.h
//  KSApp
//
//  Created by kenshin on 13-8-18.
//  Copyright (c) 2013年 kenshin. All rights reserved.
//

//成功失败Blocks
typedef void (^KSFinishedBlock) (NSDictionary *data);
typedef void (^KSFailedBlock)   (NSString *error);

// ipad app信息
#define UMENG_APP_KEY @"517cadf056240b4f1902324b"
#define UMENG_TRACK_APP_KEY @"c7a898408250ac251537fddab928fe4f"
#define WEIBO_OATH_KEY @"3101884427"
#define WEIBO_OAUTH_SECRET @"8dd22958ebe6db7b46b2afa24e94bc9d"
#define WEIBO_CALLBACK_URL @"http://open.weibo.com/apps/3101884427/privilege/oauth"
#define WX_APP_ID @"wxc88c00b289ff14eb"


#define URL_SERVER_ROOT @"http://mapi.yinyuetai.com/"

//测试数据
//#define URL_SERVER_ROOT @"http://beta.yinyuetai.com:8089/"

#define URL_TIME @"common/time.json" //系统时间

//首页
#define URL_INDEX [NSString stringWithFormat:@"%@/index",URL_SERVER_ROOT]

//首页大图
#define URL_FONTPAGE @"suggestions/front_page.json"

//猜你喜欢
#define URL_GuessVideos @"video/get_guess_videos.json"

//排行榜
#define URL_PANKING_ENTRY [NSString stringWithFormat:@"%@/panking",URL_SERVER_ROOT]

//悦单
#define URL_PICK_MLLIST @"playlist/list.json"               // 精品悦单
#define URL_ML_DETAIL @"playlist/show.json"                 // 悦单详情
#define URL_FAVORITE_MLLIST @"playlist/favorites.json"       // 我收藏的悦单
#define URL_ADD_FAVORITE @"playlist/favorites/create.json"  // 收藏悦单
#define URL_UPDATE_OWN_ML @"playlist/update.json"          // 修改悦单
#define URL_OWN_MLLIST @"playlist/me.json"                  // 创建的悦单
#define URL_CREATE_ML @"playlist/create.json"               // 创建悦单
#define URL_ADD_MV_TO_ML @"playlist/add_video.json"         // 添加到悦单
#define URL_DELETE_FAVORITE_MLLIST @"playlist/favorites/delete_batch.json" // 删除多个收藏
#define URL_DELETE_FAVORITE_MLITEM @"playlist/favorites/delete.json"    // 删除收藏的MLItem
#define URL_DELETE_OWN_ML @"playlist/delete_batch.json"    // 删除多个悦单
#define URL_DELETE_OWN_MLITEM @"playlist/delete.json"   // 删除创建的MLItem
#define URL_UPLOAD_ML_COVER @"http://upload.sapi.yinyuetai.com/upload/image.do" // 上传悦单封面

//用户
#define URL_ACCOUNT_REGISTER @"account/register.json" //用户注册
#define URL_ACCOUNT_BIND_EMAIL @"account/bind_email.json" // 绑定邮箱
#define URL_ACCOUNT_LOGIN @"account/login.json" //用户登录
#define URL_ACCOUNT_LOGOUT @"account/logout.json"   // 注销
#define URL_OPEN_ACCOUNT_LOGIN @"account/login_by_open.json" //开放平台登录
#define URL_OPEN_BIND @"open/bind.json" // 绑定开放平台
#define URL_ACCOUNT_SHOW @"account/show.json" //用户信息，验证是否登录
#define URL_ACCOUNT_PROFILE @"account/settings/profile.json" // 修改用户资料
#define URL_ACCOUNT_SIGN_IN @"account/sign_in.json" // 签到
#define URL_ACCOUNT_UNREAD_MESSAGE @"account/message_notify.json" // 未读消息
#define URL_ACCOUNT_VERIFICATION_CODE @"account/check_phone.json" // 获取验证码，注册、绑定、重绑
#define URL_ACCOUNT_REGISTER_WITH_PHONE @"account/register_by_phone.json" // 手机注册
#define URL_ACCOUNT_GET_BACK_PASSWORD @"account/forgot/password.json"  // 找回密码
#define URL_PRODUCT_VERIFICATION_CODE @"product/send_code.json" // 获取验证码，激活、重置密码
#define URL_ACCOUNT_RESET_PASSWORD @"account/reset/password.json" // 重设密码
#define URL_ACCOUNT_CHANGE_PASSWORD @"account/change/password.json" // 修改密码
#define URL_ACCOUNT_BING_PHONE @"account/bind_phone.json" // 绑定手机
#define URL_ACCOUNT_SEND_EMAIL @"account/send_email.json" // 发送验证信

// 未实现
#define URL_ACCOUNT_VERIFY_EMAIL @"account/verify_email.json" // 邮箱是否已经使用

//mv
#define URL_MVList @"video/list.json"
#define URL_MVAreas @"video/get_mv_areas.json"
#define URL_MVListByArtist @"video/list_by_artist.json"
#define URL_MVListByTag @"video/list_by_tag.json"
#define URL_MVDetail_Show @"video/show.json"
#define URL_MVDiscuss @"video/comment/list.json"
#define URL_MVPostComment @"video/comment/create.json"
#define URL_MVCollection_Show @"video/favorites.json" //MV收藏
#define URL_MVCollection_Add @"video/favorites/create.json"
#define URL_MVCollection_Add_Bat @"video/favorites/create_batch.json"
#define URL_MVCollection_Del @"video/favorites/delete.json"
#define URL_MVCollection_Del_Bat @"video/favorites/delete_batch.json"

//mv频道
#define URL_MVChannel_List @"video/channel/list.json"
#define URL_MVChannel_Videos @"video/channel/videos.json"
#define URL_MVChannel_Subscribe @"video/channel/subscribe.json"

//V榜
#define URL_VChart_Areas @"vchart/get_vchart_areas.json"//获取V榜区域列表信息
#define URL_VChart_Period @"vchart/period.json"//获取V榜所有周期数据
#define URL_VChart_Show @"vchart/show.json"//根据某周期编号获取V榜详细数据
#define URL_VChart_Calendar_Period @"vchart/calendar_period.json"//获取V榜所有周期数据日历风格的数据格式
#define URL_VChart_SpecilList @"video/special_plan_video_list.json"//获取特别企划视频列表数据

//通知中心
#define URL_Notice_Count @"notice/count.json"//获取通知消息数量
#define URL_Notice_Comment_List @"notice/comment/list.json"//获取评论列表
#define URL_NOtice_System_List @"notice/system/list.json"//获取系统提醒列表
#define URL_Notice_Announcement_List @"notice/announcement/list.json"//获取公告列表

//艺人
#define URL_Artist_Subscribe @"artist/subscribe/me.json"//获取订阅艺人
#define URL_Artist_Show @"artist/show.json"//查看艺人详情
#define URL_Artist_Delete @"artist/subscribe/delete.json"//取消订阅一个艺人
#define URL_Artist_Delete_Batch @"artist/subscribe/delete_batch.json"//取消订阅一批艺人
#define URL_Artist_Create @"artist/subscribe/create.json"//新订阅一个艺人
#define URL_Artist_Create_Batch @"artist/subscribe/create_batch.json"//新订阅一批艺人
#define URL_Artist_Subscribe_me @"box/subscribe/me.json"//获取我的订阅信息
#define URL_Artist_SearchMV @"search/video.json"//按条件搜索
#define URL_Artist_Suggest @"suggestions/sug_artist.json"//获取推荐订阅的艺人
#define URL_Artist_Search @"search/artist.json"//搜索艺人

#define URL_SendEmail @"/account/send_email.json"//发送验证邮箱
//搜索
#define URL_Search_Suggest @"search/suggest.json"//搜索自动补全
#define URL_Search_Recommend @"search/search_recommend.json"//搜索推荐
#define URL_Search_ML @"/search/playlist.json"//搜索悦单
#define URL_Search_TopKeyWord @"search/top_keyword.json"//获取热门搜索关键词

//推送
#define URL_ApnsBind                   @"apns/bind.json"
#define URL_ApnsSetting                @"apns/setting.json"
#define URL_ApnsBadge                  @"apns/badge/setting.json"      //不用到

//应用推荐
#define URL_Game_Formal @"http://mapi.yinyuetai.com/recommend/apps/index_view"//正式
#define URL_Game_Test @"http://beta.yinyuetai.com:8089/recommend/apps/index_view"//测试

//资讯
#define URL_News_List @"/news/article/list.json"
#define URL_News_Detail @"news/article/show.json"
