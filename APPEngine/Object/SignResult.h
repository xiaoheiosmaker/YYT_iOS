//
//  SignResult.h
//  YYTHD
//
//  Created by 崔海成 on 1/22/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *increasedCredits;
@property (nonatomic, strong) NSNumber *continuousDays;
@property (nonatomic, strong) NSNumber *signTotal;

@end
