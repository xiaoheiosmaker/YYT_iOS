//
//  MVSearchCondition.m
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVSearchCondition.h"

@interface MVSearchCondition ()
{
    NSArray *_options; //选项数组
    NSInteger _selectedIndex; //选中项index
    NSString *_paramName; //接口参数名
}

@end

@implementation MVSearchCondition

- (NSArray *)optionNames
{
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:_options.count];
    for (NSDictionary *opt in _options) {
        [names addObject:opt[@"name"]];
    }
    return names;
}

- (NSString *)optionNameAtIndex:(NSInteger)index
{
    if (index < [_options count]) {
        NSDictionary *option = [_options objectAtIndex:_selectedIndex];
        return option[@"name"];
    }
    return nil;
}

- (NSDictionary *)resultForSever
{
    NSDictionary *option = [_options objectAtIndex:_selectedIndex];
    NSString *key = option[@"key"];
    if (key) {
        return @{_paramName: key};
    }
    return nil;
}

- (void)selectOptionAtIndex:(NSInteger)index
{
    if (index < [_options count]) {
        _selectedIndex = index;
    }
}

- (NSInteger)selectedIndex
{
    return _selectedIndex;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        MVSearchCondition *condition = object;
        NSString *pName1 = self->_paramName;
        NSString *pName2 = condition->_paramName;
        NSString *key1 = [[_options objectAtIndex:_selectedIndex] objectForKey:@"key"];
        NSString *key2 = [[condition->_options objectAtIndex:condition->_selectedIndex] objectForKey:@"key"];
        if ([pName1 isEqualToString:pName2] && [key1 isEqualToString:key2]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Convenient Creator
+ (MVSearchCondition *)areaCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"艺人区域";
    searchCondition->_paramName = @"area";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"全部"},
                                  @{@"name":@"内地", @"key":@"ML"},
                                  @{@"name":@"港台", @"key":@"HT"},
                                  @{@"name":@"欧美", @"key":@"US"},
                                  @{@"name":@"韩国", @"key":@"KR"},
                                  @{@"name":@"日本", @"key":@"JP"},
                                  @{@"name":@"二次元", @"key":@"ACG"},
                                  @{@"name":@"其他", @"key":@"Other"}
                                  ];
    
    return searchCondition;
}

+ (MVSearchCondition *)singerTypeCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"艺人类型";
    searchCondition->_paramName = @"singerType";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"全部"},
                                  @{@"name":@"女艺人", @"key":@"Female"},
                                  @{@"name":@"男艺人", @"key":@"Male"},
                                  @{@"name":@"乐队组合", @"key":@"Band"},
                                  @{@"name":@"其他", @"key":@"Other"},
                                  ];
    return searchCondition;
}

+ (MVSearchCondition *)videoTypeCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"MV类型";
    searchCondition->_paramName = @"videoType";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"全部"},
                                  @{@"name":@"官方版", @"key":@"Official"},
                                  @{@"name":@"演唱会", @"key":@"Concert"},
                                  @{@"name":@"现场版", @"key":@"Live"},
                                  @{@"name":@"饭团视频", @"key":@"Fans"},
                                  @{@"name":@"字幕版", @"key":@"Subtitles"},
                                  @{@"name":@"竖屏视频", @"key":@"Others"},
                                  ];
    return searchCondition;
}

+ (MVSearchCondition *)orderCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"排序类型";
    searchCondition->_paramName = @"order";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"最新发布", @"key":@"VideoPubDate"},
                                  @{@"name":@"最多观看", @"key":@"TotalViews"},
                                  @{@"name":@"最多收藏", @"key":@"TotalFavorites"},
                                  @{@"name":@"最多推荐", @"key":@"TotalRecommends"}
                                  ];
    return searchCondition;
}

+ (MVSearchCondition *)MVOrderCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"排序类型";
    searchCondition->_paramName = @"order";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"最新发布", @"key":@"VideoPubDate"},
                                  @{@"name":@"最多观看", @"key":@"WeekViews"},
                                  ];
    return searchCondition;
}

+ (MVSearchCondition *)tagCondition
{
    MVSearchCondition *searchCondition = [[MVSearchCondition alloc] init];
    searchCondition->_caption = @"标签类型";
    searchCondition->_paramName = @"tag";
    searchCondition->_selectedIndex = 0;
    searchCondition->_options = @[@{@"name":@"全部"},
                                  //@{@"name":@"演唱会", @"key":@"Concert"},
                                  @{@"name":@"超清", @"key":@"HyperCrystal"},
                                  @{@"name":@"高清", @"key":@"HDV"},
                                  @{@"name":@"首播", @"key":@"FirstShow"},
                                  @{@"name":@"音乐人", @"key":@"Musician"},
                                  @{@"name":@"打榜入围", @"key":@"VchartOnTime"}
                                  ];
    return searchCondition;
}


@end
