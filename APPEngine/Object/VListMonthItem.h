//
//  VListMonthItem.h
//  YYTHD
//
//  Created by ssj on 13-10-19.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface VListMonthItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *month;
@property (nonatomic, copy, readonly) NSString *monthChn;
@property (nonatomic, strong) NSArray *periodModels;
@end
