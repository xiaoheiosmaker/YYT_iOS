//
//  SearchAppsModel.h
//  YYTHD
//
//  Created by ssj on 14-1-23.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface SearchAppsModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy)NSString *appName;
@property (nonatomic, copy)NSString *intro;
@property (nonatomic, strong)NSURL *logo;
@property (nonatomic, strong)NSURL *link;
@end
