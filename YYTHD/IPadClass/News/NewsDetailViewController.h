//
//  NewsDetailViewController.h
//  YYTHD
//
//  Created by IAN on 14-3-13.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsDetailViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) IBOutlet UIImageView *newsImageView;
@property (nonatomic) IBOutlet UILabel *previewLabel;
@property (nonatomic) IBOutlet UICollectionView *previewCollectionView;
@property (nonatomic) IBOutlet UITextView *textView;

- (void)loadNewsWithID:(NSNumber *)newsID;


@end
