//
//  PushItem.h
//  YYTHD
//
//  Created by ssj on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"
@class PushApsItem;
@class PushDataItem;
@interface PushItem : MTLModel<MTLJSONSerializing>
@property (nonatomic,readonly,strong) PushApsItem *aps;
@property (nonatomic,readonly,strong) NSString * dataType;
@property (nonatomic,readonly,strong) PushDataItem *data;
@end
