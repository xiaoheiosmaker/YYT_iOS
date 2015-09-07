//
//  UnreadMessageItem.h
//  YYTHD
//
//  Created by 崔海成 on 1/22/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnreadMessageItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *source;

@end
