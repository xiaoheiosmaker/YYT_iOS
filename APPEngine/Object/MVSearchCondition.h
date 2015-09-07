//
//  MVSearchCondition.h
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVSearchCondition : NSObject

/**
 搜索条件的标题,如：艺人区域
 */
@property (nonatomic, readonly)NSString *caption;

/**
 选项名称数组如：内地，港台，欧美
 */
- (NSArray *)optionNames;
- (NSString *)optionNameAtIndex:(NSInteger)index;

/**
 根据index选中选项
 
 @param index 与optionNames数组对应
 
 @return
 */
- (void)selectOptionAtIndex:(NSInteger)index;


/**
 *	@brief	当前选中项index
 *
 *	@return	与optionNames数组对应
 */
- (NSInteger)selectedIndex;


/**
 *	@brief	用于回传服务器的字典类型
 *
 *	@return	如 @{@"area":@"ML"}
 */
- (NSDictionary *)resultForSever;

+ (MVSearchCondition *)areaCondition; //艺人区域
+ (MVSearchCondition *)singerTypeCondition; //艺人类型
+ (MVSearchCondition *)videoTypeCondition; //MV类型
+ (MVSearchCondition *)orderCondition; //排序类型
+ (MVSearchCondition *)MVOrderCondition; //MV频道内排序
+ (MVSearchCondition *)tagCondition; //标签类型

@end
