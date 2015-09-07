//
//  ArtistShow.h
//  YYTHD
//
//  Created by ssj on 13-10-25.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@class Artist;
@interface ArtistShow : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong, readonly) Artist *artist;
@property (nonatomic, strong, readonly) NSArray *videos;

@end
