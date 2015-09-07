//
//  VListItem.h
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"
#import "VAreaItem.h"
#import "MVOfVListItem.h"
#import "MVItem.h"
@interface VListItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *no;
@property (nonatomic, copy, readonly) NSString *year;
@property (nonatomic, copy, readonly) NSString *dateCode;
@property (nonatomic, copy, readonly) NSString *beginDateText;
@property (nonatomic, copy, readonly) NSString *endDateText;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong, readonly) MVItem *program;
@property (nonatomic, copy, readonly) NSString *prevDateCode;
@property (nonatomic, copy, readonly) NSString *nextDateCode;
@property (nonatomic, readonly, copy) NSString *programPic;


@end
