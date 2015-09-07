//
//  VListYearItem.h
//  YYTHD
//
//  Created by ssj on 13-10-19.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface VListYearItem : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy, readonly) NSString *year;
@property (nonatomic, strong, readonly) NSArray *monthModels;
@end
