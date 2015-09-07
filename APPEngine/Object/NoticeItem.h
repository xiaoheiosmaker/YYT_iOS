//
//  NoticeItem.h
//  YYTHD
//
//  Created by ssj on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface NoticeItem : MTLModel<MTLJSONSerializing>
@property (copy, readonly, nonatomic) NSString *subject;
@property (copy, readonly, nonatomic) NSString *content;
@property (copy, readonly, nonatomic) NSString *dateCreated;
@end
