//
//  ListViewController.h
//  YYTHD
//
//  Created by 崔海成 on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLList.h"
#import "EditableViewController.h"
#define YUEDAN_PAGE_SIZE 20
@interface MLViewController : EditableViewController <GMGridViewDataSource, GMGridViewActionDelegate>
{
    __weak GMGridView *_gridView;
}
@property (nonatomic, strong) NSMutableArray *mlList;

- (id)initWithEditable:(BOOL)editable;
- (void)fetchPickMLList;    // 获取精品悦单
- (void)morePickMLList;     // 精品悦单翻页
- (void)fetchFavoriteMLList;// 获取收藏悦单
- (void)moreFavoriteMLList; // 收藏悦单翻页
- (void)fetchOwnMLList;     // 获取创建的悦单
- (void)moreOwnMLList;      // 创建的悦单翻页
- (void)deleteItem:(MLItem *)item;

- (void)completeLoadingData;
@end
