//
//  NewsItem.h
//  YYTHD
//
//  Created by IAN on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "MTLModel.h"

@interface NewsItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *keyID;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *createTime;
@property (nonatomic, readonly) NSString *summary;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSURL *imageURL;

@property (nonatomic, readonly) NSString *userName;

- (NSUInteger)newsImagesCount;
- (NSURL *)previewImageURLAtIndex:(NSInteger)index;
- (NSURL *)originImageURLAtIndex:(NSInteger)index;

@end
