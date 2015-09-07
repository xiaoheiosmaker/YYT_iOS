//
//  CopyWriter.h
//  YYTHD
//
//  Created by ssj on 13-12-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//
/*---------------------------文案提示------------------------------*/

//无网络 无数据 文案
#define NONETWORK @"网络有问题，暂无数据，您可以尝试点击页面刷新数据试试"
#define VLISTNONETWORK @"V榜找不到了，您可以检查下你的网络或尝试点击页面刷新数据试试，旁白君等着你"
#define NOORDERARTIST @"还没订阅过艺人，马上点击“添加订阅”按钮，添加个喜欢的艺人吧，艺人有MV更新，我们就会通知你"
#define NOCOLLECTML @"还没收藏过悦单喔，赶紧去收藏一个悦单吧"
#define NOCOLLECTMV @"还没收藏过MV喔，赶紧去收藏一首吧"
#define NODOENLOADMV @"还没下载MV，快去尝试去下载一个吧，没网络也能看，台哥就再也不用担心你的网络了"
#define NOOWNML @"一个悦单都没创建？悦单可是MV二次创作的精华，赶紧去创建一个吧"
#define NOSEAECHRESULT(keyWord) [NSString stringWithFormat:@"非常抱歉，找不到 “%@”的相关MV\n音悦Tai建议您：看看输入的文字是否有误；去掉可能不必要的字词",keyWord]