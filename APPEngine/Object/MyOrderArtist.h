//
//  MyOrderArtist.h
//  YYTHD
//
//  Created by ssj on 13-10-28.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface MyOrderArtist : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong, readonly)NSArray *data;
@property (nonatomic, copy, readonly)NSString *unreadCount;
@property (nonatomic, copy, readonly)NSString *totalCount;

@end
