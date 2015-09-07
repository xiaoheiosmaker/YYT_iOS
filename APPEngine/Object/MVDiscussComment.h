//
//  MVDiscussComment.h
//  YYTHD
//
//  Created by ssj on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface MVDiscussComment : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *commentId;
@property (nonatomic, copy, readonly) NSString *videoId;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *floorInt;
@property (nonatomic, copy, readonly) NSString *floor;
@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *userHeadImg;
@property (nonatomic, copy, readonly) NSString *dateCreated;
@property (nonatomic, copy, readonly) NSString *repliedId;
@property (nonatomic, copy, readonly) NSString *repliedFloorInt;
@property (nonatomic, copy, readonly) NSString *repliedFloor;
@property (nonatomic, copy, readonly) NSString *repliedUserName;
@property (nonatomic, copy, readonly) NSString *repliedUserId;
@property (nonatomic, copy, readonly) NSString *repliedHeadImg;
@property (nonatomic, copy, readonly) NSString *quotedContent;
@property (nonatomic, copy, readonly) NSString *vipLevel;
@property (nonatomic, copy, readonly) NSString *repliedUserVipLevel;
@property (nonatomic, copy, readonly) NSString *vipImg;
@property (nonatomic, copy, readonly) NSString *repliedUserVipImg;

@end
