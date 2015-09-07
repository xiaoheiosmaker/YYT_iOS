//
//  NewsItem.m
//  YYTHD
//
//  Created by IAN on 14-3-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "NewsItem.h"

@interface NewsItem ()

@property (nonatomic) NSArray *thumbnailImageUrls;
@property (nonatomic) NSArray *imageUrls;
@property (nonatomic) NSArray *originalImageUrls;

@end


@implementation NewsItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"keyID": @"id",
             @"imageURL": @"imgUrl"};
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbnailImageUrlsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
        for (NSString *str in array) {
            if (str) {
                NSURL *url = [NSURL URLWithString:str];
                [result addObject:url];
            }
        }
        return result;
    }];
}

+ (NSValueTransformer *)imageUrlsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
        for (NSString *str in array) {
            if (str) {
                NSURL *url = [NSURL URLWithString:str];
                [result addObject:url];
            }
        }
        return result;
    }];
}

+ (NSValueTransformer *)originalImageUrlsJSONTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSArray *array) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
        for (NSString *str in array) {
            if (str) {
                NSURL *url = [NSURL URLWithString:str];
                [result addObject:url];
            }
        }
        return result;
    }];
}

- (NSUInteger)newsImagesCount
{
    return [self.thumbnailImageUrls count];
}

- (NSURL *)previewImageURLAtIndex:(NSInteger)index
{
    return [self.thumbnailImageUrls objectAtIndex:index];
}

- (NSURL *)originImageURLAtIndex:(NSInteger)index
{
    return [self.originalImageUrls objectAtIndex:index];
}

@end
