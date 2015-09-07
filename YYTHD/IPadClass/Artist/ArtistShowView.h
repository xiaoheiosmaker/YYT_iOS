//
//  ArtistView.h
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ArtistShowViewDelegate;
@class Artist;
@interface ArtistShowView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *artistHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) id<ArtistShowViewDelegate>delegate;

+(instancetype)defaultSizeView;
+ (CGSize)defaultSize;
- (void)setContentWithAtist:(Artist*)artist;
@end

@protocol ArtistShowViewDelegate <NSObject>
- (void)artistShowViewClicked:(NSInteger)index;

@end
