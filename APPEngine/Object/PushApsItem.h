//
//  PushApsItem.h
//  YYTHD
//
//  Created by ssj on 13-12-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface PushApsItem : MTLModel<MTLJSONSerializing>
@property (nonatomic, readonly, strong) NSString *alert;
@property (strong,nonatomic,readonly) NSString *badge;
@property (strong,nonatomic,readonly) NSString *sound;
@end
