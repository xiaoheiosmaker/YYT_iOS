//
//  PickYueDan.h
//  YYTHD
//
//  Created by 崔海成 on 10/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLList : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy)NSMutableArray *playLists;
@property (nonatomic, readonly)NSNumber *totalCount;


@end
