//
//  FontPageItem.h
//  YYTHD
//
//  Created by btxkenshin on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVItem.h"

@interface FontPageItem : MVItem

@property (nonatomic, readonly) NSString *url;
@property (nonatomic,copy, readonly) NSString *description;
@property (nonatomic,strong, readonly) NSURL *posterPic;
@property (nonatomic,copy,readonly) NSString *subType;

@end
