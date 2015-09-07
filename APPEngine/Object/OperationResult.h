//
//  OperationResult.h
//  YYTHD
//
//  Created by 崔海成 on 1/24/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationResult : MTLModel <MTLJSONSerializing>
@property (nonatomic) BOOL success;
@property (nonatomic, copy) NSString *message;
@end
