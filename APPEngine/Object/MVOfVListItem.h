//
//  MVOfVListItem.h
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface MVOfVListItem : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSNumber *keyID;
@property (nonatomic,copy, readonly) NSString *title;
@property (nonatomic,copy, readonly) NSString *artistName;
@property (nonatomic,strong, readonly) NSURL *thumbnailPic;
@property (nonatomic, copy, readonly) NSString *describ;
@property (nonatomic, strong, readonly) NSURL *url;

@property (nonatomic, strong, readonly) NSURL * hdUrl;
@property (nonatomic, strong, readonly) NSURL * uhdUrl;



//视频状态：200正常，403无版权 404视频不存在
@property (nonatomic,strong, readonly) NSNumber *status;
//广告曝光链接(曝光后要保证发送出去)
@property (nonatomic,strong, readonly) NSURL *traceUrl;
//广告点击链接(用户点击后要保证发送出去)
@property (nonatomic,strong, readonly) NSURL *clickUrl;
//播放统计地址
@property (nonatomic,strong, readonly) NSURL *playUrl;
//完整播放统计地址
@property (nonatomic,strong, readonly) NSURL *fullPlayUrl;


@end
