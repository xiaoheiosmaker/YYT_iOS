//
//  VListPerioditem.h
//  YYTHD
//
//  Created by ssj on 13-10-19.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface VListPerioditem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *year;
@property (nonatomic, copy, readonly) NSString *dateCode;
@property (nonatomic, copy, readonly) NSString *periods;
@property (nonatomic, copy, readonly) NSString *beginDateText;
@property (nonatomic, copy, readonly) NSString *endDateText;

@end
