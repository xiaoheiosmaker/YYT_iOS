//
//  GetBackPasswordResult.h
//  YYTHD
//
//  Created by 崔海成 on 1/24/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBackPasswordResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSNumber *nextActionTime;

@end
