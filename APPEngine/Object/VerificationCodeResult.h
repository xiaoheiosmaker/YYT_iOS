//
//  VerificationCodeResult.h
//  YYTHD
//
//  Created by 崔海成 on 1/23/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationCodeResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong)NSNumber *codeValidTime;
@property (nonatomic, strong)NSNumber *actionInterval;

@end
