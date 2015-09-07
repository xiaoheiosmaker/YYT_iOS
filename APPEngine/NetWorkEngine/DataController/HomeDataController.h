//
//  HomDataControl.h
//  YYTHD
//
//  Created by btxkenshin on 10/14/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDataController.h"

typedef enum : NSInteger{
    MVPremiereAreaTypeALL = 1300,   //全部
    MVPremiereAreaTypeMainland,     //内地
    MVPremiereAreaTypeHK,           //港台
    MVPremiereAreaTypeEU,           //欧美
    MVPremiereAreaTypeSK,           //韩国
    MVPremiereAreaTypeJP            //日本
}MVPremiereAreaType;

@interface HomeDataController : BaseDataController


@property (nonatomic, strong) NSMutableArray *listFrontPage;



//获取推荐大图
- (void)loadFontPage:(void (^)(NSArray *list, NSError *err))block;

//mv首播
- (void)loadMVPremiere:(void (^)(NSArray *list, NSError *err))block;

- (void)loadMVPremiere:(void (^)(NSArray *list, NSError *err))block areaType:(MVPremiereAreaType)areaType;

@end
