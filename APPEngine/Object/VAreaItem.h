//
//  VListItem.h
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface VAreaItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly)NSString *areaName;
@property (nonatomic, copy, readonly)NSString *code;



@end
