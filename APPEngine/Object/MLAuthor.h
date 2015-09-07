//
//  MLAuthor.h
//  YYTHD
//
//  Created by 崔海成 on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLAuthor : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, strong)NSNumber *uid;
@property (nonatomic, readonly, strong)NSURL *smallAvatar;
@property (nonatomic, readonly, strong)NSURL *largeAvatar;
@property (nonatomic, readonly, copy)NSString *nickName;
@end
