//
//  UploadImageInfo.h
//  YYTHD
//
//  Created by 崔海成 on 11/19/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy)NSString *keyID;
@property (nonatomic, copy)NSString *originUrl;
@end
