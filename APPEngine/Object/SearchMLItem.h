//
//  SearchMLItem.h
//  YYTHD
//
//  Created by ssj on 14-1-23.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"
#import "SearchAppsModel.h"
#import "MLItem.h"
@interface SearchMLItem : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) MLItem *playLists;
@property (nonatomic, strong) SearchAppsModel *appsModel;
@property (nonatomic, readonly)NSNumber *totalCount;
@end
