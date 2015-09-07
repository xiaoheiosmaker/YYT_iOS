//
//  VListDataController.h
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "BaseDataController.h"
#import "VListItem.h"

@interface VListDataController : BaseDataController

//@property (nonatomic, strong)
//获取所有的V榜周期
- (void)getAllVListDateWithArea:(NSString*)areaName success:(void (^)(VListDataController *,NSMutableArray *))success
                           failure:(void (^)(VListDataController *,NSError*))failure;

//根据某周期编号获取V榜详细数据
- (void)getSelectVListParams:(NSDictionary *)params success:(void (^)(VListDataController *,VListItem *))success
                   failure:(void (^)(VListDataController *,NSError *error))failure;
//获取相应地域的地域代码
- (void)getCodeWithAreaName:(NSString *)areaName success:(void (^)(VListDataController *,NSString *))success failure:(void (^)(VListDataController *, NSError *))failure;

//获取特别企划视频
- (void)getSpecialVideoByRange:(NSRange)range success:(void (^)(VListDataController *vListDataController,NSArray*specialList))success failure:(void (^)(VListDataController *vListDataController, NSError *error))failure;
@end
