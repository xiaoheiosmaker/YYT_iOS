//
//  MVDiscussItem.h
//  YYTHD
//
//  Created by ssj on 13-10-22.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface MVDiscussItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString * commentCount;
@property (nonatomic, strong, readonly) NSArray *comments;

@end
