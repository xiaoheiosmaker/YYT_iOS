//
//  NewsItemCell.h
//  YYTHD
//
//  Created by IAN on 14-3-11.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NAImageView;

@interface NewsItemCell : UICollectionViewCell

@property (nonatomic, readwrite) IBOutlet NAImageView *imageView;
@property (nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (nonatomic, readwrite) IBOutlet UILabel *userNameLabel;
@property (nonatomic, readwrite) IBOutlet UILabel *summaryLabel;

- (void)setImageWithURL:(NSURL *)imageURL;

- (void)setSummaryText:(NSString *)summaryText;

@end