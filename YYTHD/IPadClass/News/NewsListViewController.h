//
//  NewsListViewController.h
//  YYTHD
//
//  Created by IAN on 14-3-11.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsListViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

- (void)refreshData;

@end
